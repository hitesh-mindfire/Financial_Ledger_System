FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY generated/ ./generated/

COPY transaction-service/ .

RUN go build -o transaction-service .

FROM alpine:3.14

WORKDIR /root/

COPY --from=builder /app/transaction-service .

COPY .env ./

RUN chmod +x /root/transaction-service

# Expose gRPC port
EXPOSE 8080
CMD ["./transaction-service"]
