package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/bojand/ghz/runner"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	grpcLatency = prometheus.NewHistogramVec(
		prometheus.HistogramOpts{
			Name:    "grpc_latency_ms",
			Help:    "gRPC latency distributions in milliseconds",
			Buckets: prometheus.ExponentialBuckets(1, 2, 10),
		},
		[]string{"service", "method"},
	)
	grpcThroughput = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "grpc_throughput_rps",
			Help: "gRPC throughput requests per second",
		},
		[]string{"service"},
	)
	grpcErrors = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "grpc_error_total",
			Help: "Total gRPC errors",
		},
		[]string{"service"},
	)
)

func init() {
	// Register Prometheus metrics
	prometheus.MustRegister(grpcLatency)
	prometheus.MustRegister(grpcThroughput)
	prometheus.MustRegister(grpcErrors)
}

func runGRPCBenchmark(serviceName, address, method, protoFile string) {
	fmt.Printf("Running benchmark for %s on %s...\n", serviceName, address)

	res, err := runner.Run(
		method,
		address,
		runner.WithProtoFile(protoFile, []string{}), // Adjust the path if necessary
		runner.WithDataFromJSON(`{"user_id": "user-131", "credit_limit": "1000.00"}`),
		runner.WithInsecure(true),
		runner.WithConcurrency(5),
		runner.WithConnections(1),
		runner.WithRunDuration(30*time.Second),
		runner.WithTimeout(15*time.Second),
	)
	log.Print(res, "benchmark-script")
	if err != nil {
		log.Printf("Error running gRPC benchmark for %s: %v", serviceName, err)
		grpcErrors.WithLabelValues(serviceName).Inc()
		return
	}

	grpcThroughput.WithLabelValues(serviceName).Set(res.Rps)
	for _, bucket := range res.Histogram {
		grpcLatency.WithLabelValues(serviceName, method).Observe(bucket.Mark)
	}
	if len(res.ErrorDist) > 0 {
		grpcErrors.WithLabelValues(serviceName).Add(float64(len(res.ErrorDist)))
	}
}

func main() {
	// Hardcoded values for configuration
	cardServiceURL := "card-service:8080"       // Directly set the service URL
	grpcMethod := "proto.CardService.IssueCard" // Directly set the gRPC method
	protoFile := "/proto/card.proto"            // Directly set the proto file path

	// Start Prometheus metrics server
	go func() {
		http.Handle("/metrics", promhttp.Handler())
		log.Println("Metrics server running on port 9091...")
		if err := http.ListenAndServe(":9091", nil); err != nil {
			log.Fatalf("Failed to serve Prometheus metrics: %v", err)
		}
	}()

	// Benchmark the card-service
	runGRPCBenchmark("card-service", cardServiceURL, grpcMethod, protoFile)

	// Keep the application running
	select {}
}
