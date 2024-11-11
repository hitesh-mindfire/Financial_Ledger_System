package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/bojand/ghz/runner"
	"github.com/nats-io/nats.go"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// Prometheus metrics
var (
	grpcLatency = prometheus.NewHistogram(prometheus.HistogramOpts{
		Name:    "grpc_latency_ms",
		Help:    "gRPC latency distribution in milliseconds",
		Buckets: prometheus.ExponentialBuckets(1, 2, 10),
	})
	grpcThroughput = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "grpc_throughput_rps",
		Help: "gRPC requests per second",
	})
	grpcErrors = prometheus.NewCounter(prometheus.CounterOpts{
		Name: "grpc_error_total",
		Help: "Total gRPC errors",
	})
	natsLatency = prometheus.NewHistogram(prometheus.HistogramOpts{
		Name:    "nats_latency_ms",
		Help:    "NATS latency distribution in milliseconds",
		Buckets: prometheus.ExponentialBuckets(1, 2, 10),
	})
	natsThroughput = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "nats_throughput_rps",
		Help: "NATS requests per second",
	})
)

func init() {
	// Register Prometheus metrics
	prometheus.MustRegister(grpcLatency, grpcThroughput, grpcErrors, natsLatency, natsThroughput)
}

func runGRPCBenchmark() {
	options := []runner.Option{
		runner.WithProtoFile("./proto/card.proto", []string{}),
		runner.WithInsecure(true),
		runner.WithConcurrency(2),
		runner.WithTotalRequests(100),
		runner.WithDataFromJSON(`{"user_id": "user-131", "credit_limit": "1000.00"}`),
	}

	report, err := runner.Run("proto.CardService.IssueCard", "localhost:8080", options...)
	if err != nil {
		log.Fatalf("Failed to run gRPC benchmark: %v", err)
	}
	log.Print(report, "report")
	totalRequests := report.Count
	totalErrors := report.ErrorDist["Unavailable"]
	rps := float64(totalRequests) / report.Total.Seconds()

	// Extract accurate latency metrics
	minLatency := float64(report.Fastest) / float64(time.Millisecond)
	maxLatency := float64(report.Slowest) / float64(time.Millisecond)
	avgLatency := float64(report.Average) / float64(time.Millisecond)

	// Record Prometheus metrics
	grpcThroughput.Set(rps)
	for _, result := range report.Details {
		grpcLatency.Observe(float64(result.Latency / time.Millisecond))
	}
	grpcErrors.Add(float64(totalErrors))

	// Print results summary
	fmt.Printf("\n=== gRPC Benchmark Results ===\n")
	fmt.Printf("Total Requests: %d\n", totalRequests)
	fmt.Printf("Total Errors: %d (%.2f%%)\n", totalErrors, float64(totalErrors)/float64(totalRequests)*100)
	fmt.Printf("Throughput: %.2f requests/sec\n", rps)
	fmt.Printf("Latency (ms):\n")
	fmt.Printf("  Min: %.2f\n", minLatency)
	fmt.Printf("  Max: %.2f\n", maxLatency)
	fmt.Printf("  Avg: %.2f\n", avgLatency)
	fmt.Println("===========================")
}

func runNATSBenchmark() {
	nc, err := nats.Connect("nats://localhost:4222")
	if err != nil {
		log.Fatalf("Failed to connect to NATS: %v", err)
	}
	defer nc.Drain()

	subject := "benchmark"
	messageCount := 100
	messageSize := 128
	message := make([]byte, messageSize)

	sub, err := nc.SubscribeSync(subject)
	if err != nil {
		log.Fatalf("Failed to subscribe: %v", err)
	}
	defer sub.Unsubscribe()

	start := time.Now()

	for i := 0; i < messageCount; i++ {
		if err := nc.Publish(subject, message); err != nil {
			log.Fatalf("Failed to publish message: %v", err)
		}
	}

	received := 0
	for received < messageCount {
		_, err := sub.NextMsg(time.Second)
		if err != nil {
			log.Fatalf("Failed to receive message: %v", err)
		}
		received++
	}

	duration := time.Since(start)
	rps := float64(messageCount) / duration.Seconds()
	natsThroughput.Set(rps)

	fmt.Printf("\n=== NATS Benchmark Results ===\n")
	fmt.Printf("Total Messages: %d\n", messageCount)
	fmt.Printf("Throughput: %.2f messages/sec\n", rps)
	fmt.Println("===========================")
}

func main() {
	// Start Prometheus metrics server
	go func() {
		http.Handle("/metrics", promhttp.Handler())
		log.Println("Metrics server running on port 9091...")
		if err := http.ListenAndServe(":9091", nil); err != nil {
			log.Fatalf("Failed to serve Prometheus metrics: %v", err)
		}
	}()

	// Run benchmarks
	fmt.Println("Starting gRPC benchmark...")
	runGRPCBenchmark()

	fmt.Println("Starting NATS benchmark...")
	runNATSBenchmark()

	fmt.Println("Benchmark completed!")
	fmt.Println("Check Prometheus metrics at http://localhost:9091/metrics")
}
