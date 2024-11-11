// /internal/nats/nats.go
package nats

import (
	"card-service-backend/config"
	"log"

	"github.com/nats-io/nats.go"
)

func ConnectNATS(cfg *config.Config) *nats.Conn {
	nc, err := nats.Connect(cfg.NATSUrl)
	if err != nil {
		log.Fatal("Failed to connect to NATS:", err)
	}
	log.Println("NATS connection established")
	return nc
}
