FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY generated/ ./generated/

COPY notification-service/ .

RUN go build -o notification-service .

FROM alpine:3.14

WORKDIR /root/

COPY --from=builder /app/notification-service .

COPY .env ./

RUN chmod +x /root/notification-service

# Expose gRPC port
EXPOSE 8080
CMD ["./notification-service"]