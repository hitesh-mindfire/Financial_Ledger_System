# Stage 1: Build the Go application
FROM golang:1.23-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files first to leverage caching for dependencies
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the golang-service folder containing main.go and other source code files
COPY golang-service/ ./golang-service/

# Copy the spike folder containing protobuf files if needed by your Go code
COPY spike/ ./spike/

# Build the Go binary
RUN go build -o golang-service ./golang-service

# Stage 2: Create a minimal image for running the service
FROM alpine:3.14

# Set the working directory inside the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/golang-service ./

# Expose the gRPC server port
EXPOSE 5002

# Command to run the Go service
CMD ["./golang-service"]
