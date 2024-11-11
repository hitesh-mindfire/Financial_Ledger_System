// /internal/services/card/types.go
package card

import (
	"database/sql"
	"time"

	"github.com/nats-io/nats.go"
	"github.com/shopspring/decimal"
)

// Card represents the card model in the database
type Card struct {
	ID                string          `json:"id"`
	UserID            string          `json:"user_id"`
	CardNumber        string          `json:"card_number"`
	Status            string          `json:"status"`
	CreditLimit       decimal.Decimal `json:"credit_limit"`
	CurrentBalance    decimal.Decimal `json:"current_balance"`
	AvailableBalance  decimal.Decimal `json:"available_balance"`
	LastTransactionAt time.Time       `json:"last_transaction_at"`
	ExpiryDate        time.Time       `json:"expiry_date"`
	CreatedAt         time.Time       `json:"created_at"`
	UpdatedAt         time.Time       `json:"updated_at"`
}

// IssueCardRequest represents a request to issue a new card
type IssueCardRequest struct {
	UserID      string          `json:"user_id"`
	CreditLimit decimal.Decimal `json:"credit_limit"`
}

// AuthRequest represents a request to authorize a transaction
type AuthRequest struct {
	CardID        string          `json:"card_id"`
	TransactionID string          `json:"transaction_id"`
	Amount        decimal.Decimal `json:"amount"`
	MerchantInfo  Merchant        `json:"merchant"`
}

// AuthResponse represents the response for a transaction authorization
type AuthResponse struct {
	Approved bool `json:"approved"`
}

// UpdateLimitRequest represents a request to update the card's credit limit
type UpdateLimitRequest struct {
	CardID   string          `json:"card_id"`
	NewLimit decimal.Decimal `json:"new_limit"`
}

// Balance represents the balance details of a card
type Balance struct {
	CurrentBalance   decimal.Decimal `json:"current_balance"`
	AvailableBalance decimal.Decimal `json:"available_balance"`
}

// CardEvents defines the events published by the CardService
type CardEvents struct {
	Issued struct {
		CardID      string          `json:"card_id"`
		UserID      string          `json:"user_id"`
		CreditLimit decimal.Decimal `json:"credit_limit"`
		IssuedAt    time.Time       `json:"issued_at"`
	}

	TransactionAuthorized struct {
		CardID        string          `json:"card_id"`
		TransactionID string          `json:"transaction_id"`
		Amount        decimal.Decimal `json:"amount"`
		MerchantInfo  Merchant        `json:"merchant"`
		AuthorizedAt  time.Time       `json:"authorized_at"`
	}
}

// Merchant represents details of the merchant involved in a transaction
type Merchant struct {
	Name     string `json:"name"`
	Location string `json:"location"`
}

type CardService struct {
	db   *sql.DB
	nats *nats.Conn
}
