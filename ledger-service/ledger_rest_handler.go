package main

import (
	ledgerpb "card-service-backend/generated/ledger_proto"
	"context"
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
)

// CreateLedgerEntryHandler creates a new ledger entry
func (s *LedgerService) CreateLedgerEntryHandler(w http.ResponseWriter, r *http.Request) {
	var req ledgerpb.CreateLedgerEntryRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	ledgerEntry, err := s.CreateLedgerEntry(context.Background(), &req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(ledgerEntry)
}

// GetLedgerEntryHandler retrieves a ledger entry by ID
func (s *LedgerService) GetLedgerEntryHandler(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	ledgerEntry, err := s.GetLedgerEntry(context.Background(), &ledgerpb.GetLedgerRequest{EntryId: id})
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	json.NewEncoder(w).Encode(ledgerEntry)
}

// ListLedgerEntriesHandler retrieves all ledger entries with optional filtering
func (s *LedgerService) ListLedgerEntriesHandler(w http.ResponseWriter, r *http.Request) {
	filter := &ledgerpb.LedgerFilter{}

	accountID := r.URL.Query().Get("account_id")
	if accountID != "" {
		filter.AccountId = accountID
	}

	status := r.URL.Query().Get("status")
	if status != "" {
		filter.Status = status
	}

	ledgerList, err := s.ListLedgerEntries(context.Background(), filter)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(ledgerList)
}
