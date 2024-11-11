package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"log"
	"net"
	"time"

	"card-service-backend/config"
	"card-service-backend/db"
	ledgerpb "card-service-backend/generated/ledger_proto"

	nat "card-service-backend/nats"

	"github.com/google/uuid"
	"github.com/nats-io/nats.go"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type LedgerService struct {
	ledgerpb.UnimplementedLedgerServiceServer
	db   *sql.DB
	nats *nats.Conn
}

func NewLedgerService(db *sql.DB, nats *nats.Conn) *LedgerService {
	return &LedgerService{db: db, nats: nats}
}

// CreateLedgerEntry creates a new ledger entry
func (s *LedgerService) CreateLedgerEntry(ctx context.Context, req *ledgerpb.CreateLedgerEntryRequest) (*ledgerpb.LedgerEntry, error) {
	entry := &ledgerpb.LedgerEntry{
		Id:           generateLedgerID(),
		AccountId:    req.AccountId,
		EntryType:    req.EntryType,
		Amount:       req.Amount,
		BalanceAfter: req.BalanceAfter,
		Status:       "success",
		CreatedAt:    timestamppb.Now(),
		Version:      1, // Default version
	}

	_, err := s.db.ExecContext(ctx, `
        INSERT INTO ledger_entries (id, account_id, entry_type, amount, balance_after, status, created_at, version)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
		entry.Id, entry.AccountId, entry.EntryType, entry.Amount, entry.BalanceAfter, entry.Status, entry.CreatedAt.AsTime(), entry.Version)
	if err != nil {
		log.Printf("Failed to create ledger entry: %v", err)
		return nil, errors.New("failed to create ledger entry")
	}

	eventData, _ := json.Marshal(entry)
	if err := s.nats.Publish("ledger.entry.created", eventData); err != nil {
		log.Printf("Failed to publish NATS event: %v", err)
	}

	return entry, nil
}

// UpdateStatus updates the status of an existing ledger entry
func (s *LedgerService) UpdateStatus(ctx context.Context, req *ledgerpb.UpdateStatusRequest) (*ledgerpb.LedgerEntry, error) {
	entry, err := s.GetLedgerEntry(ctx, &ledgerpb.GetLedgerRequest{EntryId: req.EntryId})
	if err != nil {
		return nil, errors.New("ledger entry not found")
	}

	oldStatus := entry.Status
	entry.Status = req.NewStatus
	_, err = s.db.ExecContext(ctx, `UPDATE ledger_entries SET status = $1, updated_at = $2 WHERE id = $3`,
		entry.Status, entry.UpdatedAt.AsTime(), entry.Id)
	if err != nil {
		return nil, errors.New("failed to update ledger status")
	}

	eventData, _ := json.Marshal(map[string]interface{}{
		"entry_id":   entry.Id,
		"old_status": oldStatus,
		"new_status": entry.Status,
		"updated_at": entry.UpdatedAt,
	})
	if err := s.nats.Publish("ledger.status.updated", eventData); err != nil {
		log.Printf("Failed to publish NATS event: %v", err)
	}

	return entry, nil
}

// GetLedgerEntry retrieves a ledger entry by ID
func (s *LedgerService) GetLedgerEntry(ctx context.Context, req *ledgerpb.GetLedgerRequest) (*ledgerpb.LedgerEntry, error) {
	var entry ledgerpb.LedgerEntry
	var createdAt, updatedAt time.Time

	row := s.db.QueryRowContext(ctx, `SELECT id, transaction_id, account_id, entry_type, amount, balance_after, status, created_at, updated_at, version
        FROM ledger_entries WHERE4 id = $1`, req.EntryId)
	if err := row.Scan(&entry.Id, &entry.TransactionId, &entry.AccountId, &entry.EntryType, &entry.Amount, &entry.BalanceAfter, &entry.Status, &createdAt, &updatedAt, &entry.Version); err != nil {
		return nil, errors.New("ledger entry not found")
	}

	entry.CreatedAt = timestamppb.New(createdAt)
	entry.UpdatedAt = timestamppb.New(updatedAt)

	return &entry, nil
}

// ListLedgerEntries retrieves all ledger entries with optional filtering
func (s *LedgerService) ListLedgerEntries(ctx context.Context, filter *ledgerpb.LedgerFilter) (*ledgerpb.LedgerList, error) {
	var entries []*ledgerpb.LedgerEntry
	query := `SELECT id, transaction_id, account_id, entry_type, amount, balance_after, status, created_at, updated_at, version FROM ledger_entries WHERE 1=1`

	if filter.AccountId != "" {
		query += ` AND account_id = $1`
	}
	if filter.Status != "" {
		query += ` AND status = $2`
	}

	args := []interface{}{}
	if filter.AccountId != "" {
		args = append(args, filter.AccountId)
	}
	if filter.Status != "" {
		args = append(args, filter.Status)
	}

	rows, err := s.db.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, errors.New("failed to list ledger entries")
	}
	defer rows.Close()

	for rows.Next() {
		var entry ledgerpb.LedgerEntry
		var createdAt time.Time

		if err := rows.Scan(&entry.Id, &entry.TransactionId, &entry.AccountId, &entry.EntryType, &entry.Amount, &entry.BalanceAfter, &entry.Status, &createdAt, &entry.Version); err != nil {
			return nil, err
		}

		entry.CreatedAt = timestamppb.New(createdAt)

		entries = append(entries, &entry)
	}

	return &ledgerpb.LedgerList{Entries: entries}, nil
}

func generateLedgerID() string {
	return uuid.New().String() // Use a UUID generator for unique IDs
}

func main() {
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

	// Create the LedgerService instance
	ledgerService := NewLedgerService(dbConn, natsConn)

	// Start the gRPC server
	grpcServer := grpc.NewServer()
	ledgerpb.RegisterLedgerServiceServer(grpcServer, ledgerService)

	listener, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatalf("Failed to listen on port 8080: %v", err)
	}

	log.Println("LedgerService is running on port 8080...")
	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("Failed to serve gRPC server: %v", err)
	}
}
