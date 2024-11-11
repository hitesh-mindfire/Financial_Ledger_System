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
	"time"

	"card-service-backend/config"
	"card-service-backend/db"
	pb "card-service-backend/generated/card_proto"
	ledgerpb "card-service-backend/generated/ledger_proto"
	transactionpb "card-service-backend/generated/transaction_proto"
	nat "card-service-backend/nats"

	"github.com/google/uuid"
	"github.com/nats-io/nats.go"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type TransactionService struct {
	transactionpb.UnimplementedTransactionServiceServer
	db           *sql.DB
	nats         *nats.Conn
	ledgerClient ledgerpb.LedgerServiceClient
	cardClient   pb.CardServiceClient
}
type TransactionResponse struct {
	Id              string `json:"id"`
	CardId          string `json:"card_id"`
	Amount          string `json:"amount"`
	Currency        string `json:"currency"`
	Type            string `json:"type"`
	Status          string `json:"status"`
	ReferenceNumber string `json:"reference_number"`
	CreatedAt       string `json:"created_at"`
	UpdatedAt       string `json:"updated_at"`
}

type TransactionUpdateResponse struct {
	Id              string `json:"id"`
	CardId          string `json:"card_id"`
	Amount          string `json:"amount"`
	Currency        string `json:"currency"`
	Type            string `json:"type"`
	Status          string `json:"status"`
	ReferenceNumber string `json:"reference_number"`
	CreatedAt       string `json:"created_at"`
	UpdatedAt       string `json:"updated_at"`
	SettledAt       string `json:"settled_at,omitempty"` // Optional field, use omitempty to skip if nil
}
type TxnList struct {
	Transactions []*TransactionUpdateResponse
}

func NewTransactionService(db *sql.DB, nats *nats.Conn, ledgerClient ledgerpb.LedgerServiceClient,
	cardClient pb.CardServiceClient) *TransactionService {
	return &TransactionService{db: db, nats: nats, ledgerClient: ledgerClient,
		cardClient: cardClient}
}

func (s *TransactionService) CreateTransaction(ctx context.Context, req *transactionpb.CreateTxnRequest) (*transactionpb.TransactionUpdateResponse, error) {
	txn := &transactionpb.Transaction{
		Id:              generateTransactionID(),
		CardId:          req.CardId,
		Amount:          req.Amount,
		Currency:        req.Currency,
		Type:            req.Type,
		Status:          "success",
		ReferenceNumber: generateReferenceNumber(),
		CreatedAt:       timestamppb.Now(),
		UpdatedAt:       timestamppb.Now(),
	}

	// Insert the transaction into the database
	_, err := s.db.ExecContext(ctx, `
        INSERT INTO transactions (id, card_id, amount, currency, type, status, reference_number, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
		txn.Id, txn.CardId, txn.Amount, txn.Currency, txn.Type, txn.Status, txn.ReferenceNumber, txn.CreatedAt.AsTime(), txn.UpdatedAt.AsTime())
	if err != nil {
		log.Print("Error inserting transaction:", err)
		return nil, errors.New("failed to create transaction")
	}

	// Publish the transaction creation event
	eventData, _ := json.Marshal(txn)
	if err := s.nats.Publish("transaction.created", eventData); err != nil {
		log.Printf("Failed to publish NATS event: %v", err)
	}

	// Get the current balance for the card
	balanceReq := &pb.GetBalanceRequest{
		CardId: req.CardId,
	}
	balance, _ := s.cardClient.GetBalance(ctx, balanceReq)
	log.Printf("Retrieved balance from DB: %s", balance)
	if err != nil {
		log.Print("Error getting balance:", err)
		return nil, err
	}

	amount, err := strconv.ParseFloat(req.Amount, 64)
	if err != nil {
		log.Print("Error parsing amount:", err)
		return nil, errors.New("invalid amount format")
	}

	cardBalance, err := strconv.ParseFloat(balance.CurrentBalance, 64)
	log.Print(err, "error")
	if err != nil {
		log.Print("Error parsing card balance:", err)
		return nil, errors.New("invalid balance format")
	}

	if req.Type == "DEBIT" {
		if amount > cardBalance {
			// Update the transaction status to "failed" in the database
			_, err := s.db.ExecContext(ctx, `UPDATE transactions SET status = 'failed' WHERE id = $1`, txn.Id)
			if err != nil {
				log.Print("Error updating transaction status:", err)
			}
			return nil, errors.New("insufficient balance for debit transaction")
		}
		cardBalance -= amount
		txn.Status = "success"
	} else if req.Type == "CREDIT" {
		cardBalance += amount
		txn.Status = "success"
	} else {
		return nil, errors.New("invalid transaction type")
	}

	// Update the card balance in the database
	_, err = s.db.ExecContext(ctx, `UPDATE cards SET available_balance = $1 WHERE id = $2`, cardBalance, req.CardId)
	if err != nil {
		log.Print("Error updating card balance:", err)
		return nil, errors.New("failed to update card balance")
	}

	// Create ledger entry for successful transaction
	ledgerEntryType := "CREDIT"
	if req.Type == "DEBIT" {
		ledgerEntryType = "DEBIT"
	}

	ledgerReq := &ledgerpb.CreateLedgerEntryRequest{
		AccountId:    req.CardId,
		EntryType:    ledgerEntryType,
		Amount:       req.Amount,
		BalanceAfter: fmt.Sprintf("%.2f", cardBalance),
	}
	ledgerEntry, err := s.ledgerClient.CreateLedgerEntry(ctx, ledgerReq)
	if err != nil {
		log.Print("Error creating ledger entry:", err)
		return nil, errors.New("failed to create ledger entry")
	}
	log.Printf("Ledger entry created successfully: %+v", ledgerEntry)

	// Return the transaction response
	return &transactionpb.TransactionUpdateResponse{
		Id:              txn.Id,
		CardId:          txn.CardId,
		Amount:          txn.Amount,
		Currency:        txn.Currency,
		Type:            txn.Type,
		Status:          txn.Status,
		ReferenceNumber: txn.ReferenceNumber,
		CreatedAt:       txn.CreatedAt.AsTime().Format("2006-01-02 15:04:05"),
		UpdatedAt:       txn.UpdatedAt.AsTime().Format("2006-01-02 15:04:05"),
	}, nil
}

func (s *TransactionService) UpdateStatus(ctx context.Context, req *transactionpb.UpdateStatusRequest) (*transactionpb.TransactionUpdateResponse, error) {
	log.Print(req.TransactionId)
	txn, err := s.GetTransaction(ctx, &transactionpb.GetTxnRequest{TransactionId: req.TransactionId})
	log.Print(err, txn, "error")

	if err != nil {
		return nil, errors.New("transaction not found")
	}

	oldStatus := txn.Status
	txn.Status = req.NewStatus
	txn.UpdatedAt = timestamppb.Now()

	_, err = s.db.ExecContext(ctx, `UPDATE transactions SET status = $1, updated_at = $2 WHERE id = $3`,
		txn.Status, txn.UpdatedAt.AsTime(), txn.Id)

	log.Print(err, "abc")
	if err != nil {
		return nil, errors.New("failed to update transaction status")
	}

	eventData, _ := json.Marshal(map[string]interface{}{
		"transaction_id": txn.Id,
		"old_status":     oldStatus,
		"new_status":     txn.Status,
		"updated_at":     txn.UpdatedAt,
	})
	if err := s.nats.Publish("transaction.status.updated", eventData); err != nil {
		log.Printf("Failed to publish NATS event: %v", err)
	}
	txn1 := &transactionpb.TransactionUpdateResponse{
		Id:              txn.Id,
		CardId:          txn.CardId,
		Amount:          txn.Amount,
		Currency:        txn.Currency,
		Type:            txn.Type,
		Status:          txn.Status,
		ReferenceNumber: txn.ReferenceNumber,
		CreatedAt:       txn.CreatedAt.AsTime().Format("2006-01-02 15:04:05"),
		UpdatedAt:       txn.UpdatedAt.AsTime().Format("2006-01-02 15:04:05"),
		SettledAt:       txn.SettledAt.AsTime().Format("2006-01-02 15:04:05"),
	}
	return txn1, nil
}

func (s *TransactionService) GetTransaction(ctx context.Context, req *transactionpb.GetTxnRequest) (*transactionpb.Transaction, error) {
	var txn transactionpb.Transaction
	var createdAt, updatedAt, currentTime time.Time
	var settledAt *time.Time
	log.Print(req, "row2")

	row := s.db.QueryRowContext(ctx, `SELECT id, card_id, amount, currency, type, status, reference_number, created_at, updated_at, settled_at
        FROM transactions WHERE id = $1`, req.TransactionId)
	log.Print(*row, &txn.Status, "row")
	if err := row.Scan(&txn.Id, &txn.CardId, &txn.Amount, &txn.Currency, &txn.Type, &txn.Status, &txn.ReferenceNumber, &createdAt, &updatedAt, &settledAt); err != nil {
		log.Print(txn.Status, row, err, "row1")

		return nil, errors.New("transaction not found")
	}
	log.Print(txn.Status, row, "row1")

	txn.CreatedAt = timestamppb.New(createdAt)
	txn.UpdatedAt = timestamppb.New(updatedAt)
	currentTime = time.Now()
	txn.SettledAt = timestamppb.New(currentTime) // Set to current time

	// Update the database with the new settledAt time
	_, err := s.db.ExecContext(ctx, `UPDATE transactions SET settled_at = $1 WHERE id = $2`, currentTime, txn.Id)
	if err != nil {
		return nil, errors.New("failed to update settled_at")
	}

	return &txn, nil
}

func (s *TransactionService) ListTransactions(ctx context.Context, filter *transactionpb.TxnFilter) (*transactionpb.TxnList1, error) {
	var txns []*transactionpb.TransactionUpdateResponse // Use TransactionUpdateResponse for the output list
	query := `SELECT id, card_id, amount, currency, type, status, reference_number, created_at, updated_at, settled_at FROM transactions WHERE 1=1`

	// Add filter conditions
	if filter.CardId != "" {
		query += ` AND card_id = '` + filter.CardId + `'`
	}
	if filter.Status != "" {
		query += ` AND status = '` + filter.Status + `'`
	}

	rows, err := s.db.QueryContext(ctx, query)
	if err != nil {
		return nil, errors.New("failed to list transactions")
	}
	defer rows.Close()

	for rows.Next() {
		var txn transactionpb.Transaction
		var createdAt, updatedAt, currentTime time.Time
		var settledAt *time.Time
		if err := rows.Scan(&txn.Id, &txn.CardId, &txn.Amount, &txn.Currency, &txn.Type, &txn.Status, &txn.ReferenceNumber, &createdAt, &updatedAt, &settledAt); err != nil {
			return nil, err
		}

		// Create a TransactionUpdateResponse for the current transaction
		txnResponse := &transactionpb.TransactionUpdateResponse{
			Id:              txn.Id,
			CardId:          txn.CardId,
			Amount:          txn.Amount,
			Currency:        txn.Currency,
			Type:            txn.Type,
			Status:          txn.Status,
			ReferenceNumber: txn.ReferenceNumber,
			CreatedAt:       createdAt.Format("2006-01-02 15:04:05"),   // Format as string
			UpdatedAt:       updatedAt.Format("2006-01-02 15:04:05"),   // Format as string
			SettledAt:       currentTime.Format("2006-01-02 15:04:05"), // Set to formatted current time as string
		}

		// Append the response to the slice
		txns = append(txns, txnResponse)
	}

	// Return the response as *transactionpb.TxnList with the appropriate conversion
	return &transactionpb.TxnList1{Transactions: txns}, nil
}

func generateReferenceNumber() string {
	return "REF" + time.Now().Format("20060102150405")
}

func generateTransactionID() string {
	return uuid.New().String()
}

func main() {
	cfg := config.LoadConfig()
	log.Print(cfg, "cfg")
	dbConn := db.ConnectDB(cfg)
	defer dbConn.Close()

	natsConn := nat.ConnectNATS(cfg)
	defer natsConn.Close()

	conn, err := grpc.NewClient("card-service:8080", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("Failed to connect to CardService: %v", err)
	}
	defer conn.Close()

	ledgerConn, err1 := grpc.NewClient("ledger-service:8080", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err1 != nil {
		log.Fatalf("Failed to connect to LedgerService: %v", err)
	}
	defer conn.Close()

	ledgerClient := ledgerpb.NewLedgerServiceClient(ledgerConn)
	cardClient := pb.NewCardServiceClient(conn)
	transactionService := NewTransactionService(dbConn, natsConn, ledgerClient, cardClient)
	grpcServer := grpc.NewServer()
	transactionpb.RegisterTransactionServiceServer(grpcServer, transactionService)

	listener, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatalf("Failed to listen on port 8080: %v", err)
	}

	log.Println("TransactionService is running on port 8080...")
	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("Failed to serve gRPC server: %v", err)
	}
}
