package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"

	pb "card-service-backend/generated/card_proto"

	"github.com/gorilla/mux"
)

// Handler to issue a new card
func (s *CardService) IssueCardHandler(w http.ResponseWriter, r *http.Request) {
	var req pb.IssueCardRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("Error issuing card for user %s: %v", req.UserId, err)
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	card, err := s.IssueCard(context.Background(), &req)
	if err != nil {
		http.Error(w, "Failed to issue card", http.StatusInternalServerError)
		log.Fatal(err, "error")
		return
	}

	json.NewEncoder(w).Encode(card)
}

// Handler to get card details by ID
func (s *CardService) GetCardByIDHandler(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	cardID := params["id"]

	card, err := s.GetCardByID(context.Background(), cardID)
	if err != nil {
		http.Error(w, "Card not found", http.StatusNotFound)
		return
	}

	json.NewEncoder(w).Encode(card)
}

// Handler to authorize a transaction
func (s *CardService) AuthorizeTransactionHandler(w http.ResponseWriter, r *http.Request) {
	var req pb.AuthRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	resp, err := s.AuthorizeTransaction(context.Background(), &req)
	log.Print(resp, err, "def")
	if err != nil {
		http.Error(w, "Authorization failed", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(resp)
}

// Handler to get card balance
func (s *CardService) GetBalanceHandler(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	cardID := params["id"]

	// Create a GetBalanceRequest object
	req := &pb.GetBalanceRequest{
		CardId: cardID,
	}

	// Call GetBalance with the request object
	balance, err := s.GetBalance(context.Background(), req)
	if err != nil {
		http.Error(w, "Failed to retrieve balance", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(balance)
}

// Handler to update card limit
func (s *CardService) UpdateLimitHandler(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	cardID := params["id"]

	var req pb.UpdateLimitRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}
	req.CardId = cardID

	card, err := s.UpdateLimit(context.Background(), &req)
	if err != nil {
		http.Error(w, "Failed to update limit", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(card)
}
