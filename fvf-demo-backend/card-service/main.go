package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net"
	"strconv"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/nats-io/nats.go"
	"github.com/shopspring/decimal"
	"golang.org/x/exp/rand"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/protobuf/types/known/timestamppb"

	config "card-service-backend/config"
	db "card-service-backend/db"
	pb "card-service-backend/generated/card_proto"
	ledgerpb "card-service-backend/generated/ledger_proto"
	transactionpb "card-service-backend/generated/transaction_proto"
	nat "card-service-backend/nats"
)

type CardService struct {
	pb.UnimplementedCardServiceServer
	db                *sql.DB
	nats              *nats.Conn
	ledgerClient      ledgerpb.LedgerServiceClient
	transactionClient transactionpb.TransactionServiceClient
}

type CardEvents struct {
	Issued                IssuedEvent                `json:"issued,omitempty"`
	TransactionAuthorized TransactionAuthorizedEvent `json:"transaction_authorized,omitempty"`
}

// Define the IssuedEvent structure
type IssuedEvent struct {
	CardID           string `json:"card_id"`
	UserID           string `json:"user_id"`
	CreditLimit      string `json:"credit_limit"`
	CardNumber       string `json:"card_number"`
	AvailableBalance string `json:"available_balance"`
}

// Define the TransactionAuthorizedEvent structure
type TransactionAuthorizedEvent struct {
	CardID        string    `json:"card_id"`
	TransactionID string    `json:"transaction_id"`
	Amount        string    `json:"amount"`
	AuthorizedAt  time.Time `json:"authorized_at"`
}
type CardResponse struct {
	Id               string `json:"id"`
	UserId           string `json:"user_id"`
	Status           string `json:"status"`
	CreditLimit      string `json:"credit_limit"`
	CardNumber       string `json:"card_number"`
	AvailableBalance string `json:"available_balance"`
	ExpiryDate       string `json:"expiry_date"`
}

func NewCardService(db *sql.DB, nats *nats.Conn, ledgerClient ledgerpb.LedgerServiceClient, transactionClient transactionpb.TransactionServiceClient) *CardService {
	return &CardService{
		db:                db,
		nats:              nats,
		ledgerClient:      ledgerClient,
		transactionClient: transactionClient,
	}

}

func (s *CardService) IssueCard(ctx context.Context, req *pb.IssueCardRequest) (*pb.Card, error) {
	expiryDate := time.Now().AddDate(5, 0, 0)
	cvv := fmt.Sprintf("%03d", rand.Intn(1000))
	log.Print("card-service called")
	card := &pb.Card{
		Id:               generateCardID(),
		UserId:           req.UserId,
		Status:           "active",
		CreditLimit:      req.CreditLimit,
		CardNumber:       generateCardNumber(),
		AvailableBalance: "0",
		Cvv:              cvv,
		ExpiryDate:       timestamppb.New(expiryDate).String(),
	}

	// Save card details to the database
	_, err := s.db.ExecContext(ctx, `
        INSERT INTO cards (id, user_id, status, credit_limit, card_number, available_balance, expiry_date,cvv) 
        VALUES ($1, $2, $3, $4, $5, $6, $7,$8)`,
		card.Id, card.UserId, card.Status, card.CreditLimit, card.CardNumber, card.AvailableBalance, expiryDate, cvv,
	)
	log.Print("card")
	if err != nil {
		return nil, err
	}

	// Publish card.issued event to NATS
	eventData, err := json.Marshal(IssuedEvent{
		CardID:           card.Id,
		UserID:           card.UserId,
		CreditLimit:      card.CreditLimit,
		CardNumber:       card.CardNumber,
		AvailableBalance: card.AvailableBalance,
	})
	if err != nil {
		return nil, err
	}
	s.nats.Publish("card.issued", eventData)
	// Call LedgerService to create a ledger entry
	ledgerReq := &ledgerpb.CreateLedgerEntryRequest{
		AccountId:    card.Id,
		EntryType:    "CREDIT",
		Amount:       card.CreditLimit,
		BalanceAfter: card.CreditLimit,
	}
	ledgerEntry, err := s.ledgerClient.CreateLedgerEntry(ctx, ledgerReq)
	log.Print(err, "error")
	if err != nil {
		return nil, errors.New("failed to create ledger entry")
	}
	log.Printf("Ledger entry created successfully: %+v", ledgerEntry)
	txnReq := &transactionpb.CreateTxnRequest{
		CardId:   card.Id,
		Amount:   "200",
		Currency: "INR",
		Type:     "CREDIT",
	}

	_, err = s.transactionClient.CreateTransaction(ctx, txnReq)
	if err != nil {
		log.Printf("Failed to create initial transaction: %v", err)
		return nil, errors.New("failed to load initial amount")
	}

	return card, nil
}

func (s *CardService) AuthorizeTransaction(ctx context.Context, req *pb.AuthRequest) (*pb.AuthResponse, error) {
	var cardCreditLimit decimal.Decimal
	var cardBalance string
	var credit_limit string
	log.Print("abc", "error")

	err := s.db.QueryRowContext(ctx, `SELECT credit_limit FROM cards WHERE id = $1 AND status = 'active'`, req.CardId).Scan(&cardCreditLimit)

	if err != nil {
		log.Print(err, req, "abc", credit_limit)
		return nil, errors.New("card not found or inactive")
	}
	cardBalance, credit_limit, err = s.GetCardBalance(req.CardId)
	log.Print(cardBalance, "balance")
	if err != nil {
		log.Print(err, "error")
		return nil, err
	}

	log.Print(cardBalance, req.Amount, cardCreditLimit, "balance")
	amount, _ := strconv.ParseFloat(req.Amount, 64)
	cardBalanceUpdated, _ := strconv.ParseFloat(cardBalance, 64)

	if amount > cardBalanceUpdated {
		return &pb.AuthResponse{Authorized: false}, nil
	}
	eventData, _ := json.Marshal(TransactionAuthorizedEvent{
		CardID:       req.CardId,
		Amount:       req.Amount,
		AuthorizedAt: time.Now(),
	})
	s.nats.Publish("card.transaction.authorized", eventData)
	return &pb.AuthResponse{Authorized: true}, nil
}

func (s *CardService) UpdateLimit(ctx context.Context, req *pb.UpdateLimitRequest) (*pb.Card, error) {
	_, err := s.db.ExecContext(ctx, `UPDATE cards SET credit_limit = $1 WHERE id = $2`, req.NewLimit, req.CardId)
	log.Printf("ExecContext error: %v, Request: %+v", err, req)
	if err != nil {
		return nil, errors.New("failed to update card limit")
	}

	updatedCard, err := s.GetCardByID(ctx, req.CardId)
	log.Printf("Updated card details: %+v, Error: %v", updatedCard, err)
	return updatedCard, err
}

func (s *CardService) GetBalance(ctx context.Context, req *pb.GetBalanceRequest) (*pb.Balance, error) {
	return s.getBalance(ctx, req.CardId)
}

func (s *CardService) getBalance(_ context.Context, cardID string) (*pb.Balance, error) {
	balance, credit_limit, err := s.GetCardBalance(cardID)
	if err != nil {
		return nil, err
	}
	log.Print(credit_limit)
	trimmedBalance := strings.TrimSpace(balance)
	if _, parseErr := strconv.ParseFloat(trimmedBalance, 64); parseErr != nil {
		log.Printf("Error parsing trimmed balance to float: %v. Balance value: %s", parseErr, trimmedBalance)
		return nil, errors.New("invalid balance format")
	}

	return &pb.Balance{
		CurrentBalance: trimmedBalance,
	}, nil
}

func (s *CardService) GetCardBalance(cardID string) (string, string, error) {
	var balance string
	var credit_limit string
	err := s.db.QueryRow(`SELECT available_balance,credit_limit FROM cards WHERE id = $1 `, cardID).Scan(&balance, &credit_limit)
	log.Print(err)
	if err != nil {
		return "", "", errors.New("failed to retrieve card balance , credit limit")
	}
	return balance, credit_limit, nil
}

func (s *CardService) GetCardByID(ctx context.Context, cardID string) (*pb.Card, error) {
	var card pb.Card
	err := s.db.QueryRowContext(ctx, `SELECT id, user_id, status, credit_limit, card_number FROM cards WHERE id = $1`, cardID).Scan(
		&card.Id, &card.UserId, &card.Status, &card.CreditLimit, &card.CardNumber)
	log.Print(err, cardID)
	if err != nil {
		return nil, errors.New("card not found")
	}

	return &card, nil
}

func generateCardID() string {
	return uuid.New().String()
}

func generateCardNumber() string {
	return fmt.Sprintf("%016d", rand.Int63n(1_0000_0000_0000_0000))
}

func main() {
	// Connect to the database
	cfg := config.LoadConfig()
	log.Print(cfg, "cfg")
	dbConn := db.ConnectDB(cfg)
	defer dbConn.Close()

	natsConn := nat.ConnectNATS(cfg)
	defer natsConn.Close()

	conn, err := grpc.NewClient("ledger-service:8080", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("Failed to connect to LedgerService: %v", err)
	}
	defer conn.Close()

	transactionconn, err1 := grpc.NewClient("transaction-service:8080", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err1 != nil {
		log.Fatalf("Failed to connect to TransactionService: %v", err)
	}
	defer conn.Close()

	ledgerClient := ledgerpb.NewLedgerServiceClient(conn)
	transactionClient := transactionpb.NewTransactionServiceClient(transactionconn)

	// Create the CardService instance
	cardService := NewCardService(dbConn, natsConn, ledgerClient, transactionClient)

	// Start the gRPC server
	grpcServer := grpc.NewServer()
	pb.RegisterCardServiceServer(grpcServer, cardService)

	listener, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatalf("Failed to listen on port 8080: %v", err)
	}

	log.Println("CardService is running on port 8080...")
	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("Failed to serve gRPC server: %v", err)
	}
}
