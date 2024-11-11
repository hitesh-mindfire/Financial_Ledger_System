FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY generated/ ./generated/

COPY ledger-service/ .

RUN go build -o ledger-service .

FROM alpine:3.14

WORKDIR /root/

COPY --from=builder /app/ledger-service .
COPY .env ./

RUN chmod +x /root/ledger-service

# Expose gRPC port
EXPOSE 8080

CMD ["./ledger-service"]
