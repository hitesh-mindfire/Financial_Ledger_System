package utils

import (
	"fmt"
	"math/rand"
	"time"

	"github.com/google/uuid"
)

func GenerateCardID() string {
	return fmt.Sprintf("card_%d", rand.Intn(1000000))
}

func GenerateCardNumber() string {
	rand.Seed(time.Now().UnixNano())
	return fmt.Sprintf("%04d-%04d-%04d-%04d", rand.Intn(10000), rand.Intn(10000), rand.Intn(10000), rand.Intn(10000))
}

func GenerateReferenceNumber() string {
	return "REF" + time.Now().Format("20060102150405")
}

func GenerateTransactionID() string {
	return uuid.New().String()
}
