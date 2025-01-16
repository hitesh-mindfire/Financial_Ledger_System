package main

import (
	"card-service-backend/config"
	"card-service-backend/db"
	"context"
	"database/sql"
	"fmt"
	"log"
	"sync"
	"time"

	nat "card-service-backend/nats"

	"net/http"

	"github.com/gorilla/websocket"
	"github.com/nats-io/nats.go"
)

// NotificationRequest defines the request to send a notification.
type NotificationRequest struct {
	UserID  string
	Title   string
	Message string
	Type    string
}

// Notification represents a notification structure.
type Notification struct {
	ID        string  `json:"id"`
	UserID    string  `json:"user_id"`
	Title     string  `json:"title"`
	Message   string  `json:"message"`
	Type      string  `json:"type"`
	Status    string  `json:"status"`
	CreatedAt string  `json:"created_at"`
	ReadAt    *string `json:"read_at,omitempty"`
}

// NotificationList holds a list of notifications.
type NotificationList struct {
	Notifications []Notification `json:"notifications"`
}

// WebSocketMessage represents a message format for WebSocket communication.
type WebSocketMessage struct {
	Type    string `json:"type"`
	Payload struct {
		ID        string      `json:"id"`
		Timestamp string      `json:"timestamp"`
		Data      interface{} `json:"data"` // Actual data to send
	} `json:"payload"`
}

// NotificationService provides methods for handling notifications.
type NotificationService struct {
	db          *sql.DB
	connections map[string]*websocket.Conn
	connMutex   sync.Mutex
}

// NewNotificationService creates a new NotificationService instance.
func NewNotificationService(db *sql.DB) *NotificationService {
	return &NotificationService{
		db:          db,
		connections: make(map[string]*websocket.Conn),
	}
}

func (s *NotificationService) LogEvent(ctx context.Context, eventType, message string) error {
	_, err := s.db.ExecContext(ctx, `
        INSERT INTO notifications (event_type, event_data)
        VALUES ($1, $2)`,
		eventType, message)
	if err != nil {
		log.Print(err, "error")
		return fmt.Errorf("failed to log event: %v", err)
	}
	return nil
}

// WebSocket handler to accept WebSocket connections
func (s *NotificationService) handleWebSocketConnection(w http.ResponseWriter, r *http.Request) {
	upgrader := websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true // Allow all origins, modify as needed
		},
	}
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("WebSocket Upgrade failed:", err)
		return
	}
	defer conn.Close()

	// Handle WebSocket communication here
	s.connMutex.Lock()
	s.connections[conn.RemoteAddr().String()] = conn
	s.connMutex.Unlock()

	log.Printf("New WebSocket connection from %s", conn.RemoteAddr())
}

func main() {
	fmt.Println("Notification Service listening for events...")

	cfg := config.LoadConfig()
	log.Print(cfg, "cfg")
	dbConn := db.ConnectDB(cfg)
	defer dbConn.Close()

	nc := nat.ConnectNATS(cfg)
	defer nc.Close()

	notificationService := NewNotificationService(dbConn)

	// Setup WebSocket server
	http.HandleFunc("/ws", notificationService.handleWebSocketConnection)
	go func() {
		if err := http.ListenAndServe(":8080", nil); err != nil {
			log.Fatalf("WebSocket server failed to start: %v", err)
		}
	}()

	if _, err := nc.Subscribe("card.issued", func(m *nats.Msg) {
		fmt.Printf("Received card issuance notification: %s\n", string(m.Data))
		// Log event in the database
		if err := notificationService.LogEvent(context.Background(), "card.issued", string(m.Data)); err != nil {
			log.Printf("Error logging card issuance event: %v", err)
		}
	}); err != nil {
		log.Fatalf("Error subscribing to card.issued: %v", err)
	}

	// Subscribe to transaction events and log to database
	if _, err := nc.Subscribe("transaction.created", func(m *nats.Msg) {
		fmt.Printf("Received transaction notification: %s\n", string(m.Data))
		// Log event in the database
		if err := notificationService.LogEvent(context.Background(), "transaction.created", string(m.Data)); err != nil {
			log.Printf("Error logging transaction event: %v", err)
		}
	}); err != nil {
		log.Fatalf("Error subscribing to transaction.created: %v", err)
	}

	// Subscribe to ledger entry events and log to database
	if _, err := nc.Subscribe("ledger.entry.created", func(m *nats.Msg) {
		fmt.Printf("Received ledger entry notification: %s\n", string(m.Data))
		// Log event in the database
		if err := notificationService.LogEvent(context.Background(), "ledger.entry.created", string(m.Data)); err != nil {
			log.Printf("Error logging ledger entry event: %v", err)
		}
	}); err != nil {
		log.Fatalf("Error subscribing to ledger.entry.created: %v", err)
	}

	// Keep the service running to listen for messages
	select {
	case <-time.After(24 * time.Hour): // Keep alive for 24 hours or change as needed
		log.Println("Notification Service is shutting down...")
	}
}
