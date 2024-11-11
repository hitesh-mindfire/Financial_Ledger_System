package main

import (
	"context"
	"encoding/json"
	"net/http"

	transactionpb "card-service-backend/generated/transaction_proto"

	"github.com/gorilla/mux"
)

// CreateTransactionHandler creates a new transaction
func (s *TransactionService) CreateTransactionHandler(w http.ResponseWriter, r *http.Request) {
	var req transactionpb.CreateTxnRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	txn, err := s.CreateTransaction(context.Background(), &req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(txn)
}

// GetTransactionHandler retrieves a transaction by ID
func (s *TransactionService) GetTransactionHandler(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	txn, err := s.GetTransaction(context.Background(), &transactionpb.GetTxnRequest{TransactionId: id})
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	json.NewEncoder(w).Encode(txn)
}

// ListTransactionsHandler retrieves all transactions with optional filtering
func (s *TransactionService) ListTransactionsHandler(w http.ResponseWriter, r *http.Request) {
	var filter transactionpb.TxnFilter

	// Decode query parameters into filter object
	filter.CardId = r.URL.Query().Get("card_id")
	filter.Status = r.URL.Query().Get("status")

	txns, err := s.ListTransactions(context.Background(), &filter)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Encode the list of transactions as JSON
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(txns)
}

// UpdateStatusHandler updates the status of a transaction
func (s *TransactionService) UpdateStatusHandler(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	var req transactionpb.UpdateStatusRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	req.TransactionId = id
	txn, err := s.UpdateStatus(context.Background(), &req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(txn)
}
