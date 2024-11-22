package main

import (
	"context"
	pb "golang-service/spike"
	"log"
	"net"
	"runtime"

	"google.golang.org/grpc"
)

type server struct {
	pb.UnimplementedSpikeServiceServer
}

func (s server) TriggerSpike(ctx context.Context, req *pb.SpikeRequest) (*pb.SpikeResponse, error) {
	// CPU spike
	go func() {
		for i := 0; i < int(req.CpuIntensity)*1000000; i++ {
			_ = i * i
		}
	}()

	// Memory spike
	memorySlice := make([]byte, req.MemoryMb*1024*1024)
	runtime.KeepAlive(memorySlice)

	return &pb.SpikeResponse{
		Success: true,
		Message: "Spike triggered successfully",
	}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":5002")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterSpikeServiceServer(s, &server{})
	log.Printf("Server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
	select {}
}
