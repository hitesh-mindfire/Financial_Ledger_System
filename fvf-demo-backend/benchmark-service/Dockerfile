FROM golang:1.23-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go modules files
COPY go.mod go.sum ./

# Download and cache dependencies
RUN go mod download

# Copy the application code
COPY generated/ ./generated/
COPY benchmark-service/ ./

# Build the Go application
RUN go build -o benchmark-service .

# Create a minimal image for running the app
FROM scratch
COPY --from=builder /app/benchmark-service /benchmark-service
COPY --from=builder /app/proto/card.proto /proto/card.proto # Copy proto file

# Use a minimal image to run the application
FROM alpine:3.14

# Set the working directory inside the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/benchmark-service .

# # Ensure the binary is executable
# RUN chmod +x /root/benchmark-service

# Expose the port for Prometheus metrics
EXPOSE 9091

# Command to run the application
CMD ["./benchmark-service"]
