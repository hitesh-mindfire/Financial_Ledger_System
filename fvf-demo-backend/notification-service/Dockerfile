
# Stage 1: Build the Go application
FROM golang:1.23-alpine AS builder

# Set working directory in the container
WORKDIR /app

# Copy go.mod and go.sum and install dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the generated code and application source
COPY generated/ ./generated/
COPY notification-service/ ./

# Copy the additional folders (config, db, nats) from the root directory
COPY config/ ./config/
COPY db/ ./db/
COPY nats/ ./nats/
COPY utils/ ./utils/

# Build the Go application
RUN go build -o notification-service .

# Stage 2: Create the final image
FROM alpine:3.14

# Set working directory in the final image
WORKDIR /root/

# Copy the built binary from the builder stage
COPY --from=builder /app/notification-service ./

# Copy .env file
COPY .env ./

# Ensure the binary is executable
RUN chmod +x /root/notification-service

# Expose gRPC port
EXPOSE 8080

# Define the command to run the app
CMD ["./notification-service"] 