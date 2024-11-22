# GoLang vs Dot NET MicroService Benchmarking

## Overview
This repository compares the performance of microservices implemented in .NET and Go. The comparison is based on key performance metrics such as request throughput, latency, resource utilization, and scalability under high-concurrency workloads.

## Goals
The benchmarking process aims to:

- Measure and compare the efficiency of .NET and Go in handling gRPC-based requests.
- Analyze resource consumption (CPU and memory) for both implementations.
- Assess how well each service scales under Kubernetes autoscaling.

## Microservice Description
 Both services expose a common gRPC endpoint:

### Endpoint
Name: TriggerSpike
Purpose: Simulates CPU and memory load based on input parameters.
### Request Parameters
cpu_intensity (int): Simulates computational workload.
memory_mb (int): Simulates memory allocation in megabytes.
### Response
success (bool): Indicates whether the operation was successful.
message (string): Confirmation message.
## Prerequisites
### Software Requirements
- Docker
- Kubernetes (minikube or a Kubernetes cluster)
- kubectl
- ghz (gRPC benchmarking tool)


## Setup Instructions
### For .NET Service:
1. Build Docker Images
```cmd
docker build -t dotnetservice:latest -f ./dotnetservice/Dockerfile .
```

2. Deploy to Kubernetes
```cmd
kubectl apply -f ./k8s/dotnet-deployment.yml
```

3. Enable Autoscaling
```cmd
kubectl apply -f ./k8s/dotnet-hpa.yml
```
3. Expose the Services
```cmd
kubectl port-forward svc/dotnetservice 5000:5001
```
## Benchmarking

Use `ghz` to simulate high-concurrency workloads. Example command:
```cmd
ghz --insecure --async --proto proto/spike.proto --call spike.SpikeService.TriggerSpike -n 5000 -c 100 -d {\"cpu_intensity\":10,\"memory_mb\":50} <SERVICE_URL>
```
For e.g. `<SERVICE_URL>` : `localhost:5000`

## Here are some Benchmarking Results:

```bash
Summary:
  Count:        5000     
  Total:        20.36 s  
  Slowest:      19.11 s  
  Fastest:      596.20 ms
  Average:      19.10 s  
  Requests/sec: 245.58

Response time histogram:
  596.197   [1]   |
  2447.154  [40]  |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  4298.111  [0]   |
  6149.069  [100] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  8000.026  [0]   |
  9850.983  [98]  |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  11701.941 [0]   |
  13552.898 [100] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  15403.855 [0]   |
  17254.813 [100] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  19105.770 [100] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎

Latency distribution:
  10 % in 4.81 s
  25 % in 5.01 s
  50 % in 13.00 s
  75 % in 16.73 s
  90 % in 18.89 s
  95 % in 18.93 s
  99 % in 19.00 s

Status code distribution:
  [OK]                 539 responses
  [DeadlineExceeded]   4461 responses
```

### For Golang Service:
1. Build Docker Images
```cmd
docker build -t golang-service:latest -f ./golang-service/Dockerfile .
```

2. Deploy to Kubernetes
```cmd
kubectl apply -f k8s/golang-deployment.yaml
```

3. Enable Autoscaling
```cmd
kubectl apply -f k8s/hpa.yaml
```
3. Expose the Services
```cmd
kubectl port-forward svc/golang-service 5002:5002
```
## Benchmarking

Use `ghz` to simulate high-concurrency workloads. Example command:
```cmd
ghz --insecure --proto=proto/spike.proto --call=spike.SpikeService.TriggerSpike -n 5000 -c 100 -d "{\"cpu_intensity\":100,\"memory_mb\":100}" <SERVICE_URL>
```

For e.g. `<SERVICE_URL>` : `localhost:5002`

## Here are some Benchmarking Results:

```bash
Summary:
  Count:        1000
  Total:        25.77 s
  Slowest:      7.91 s
  Fastest:      102.24 ms       
  Average:      1.28 s
  Requests/sec: 38.81

Response time histogram:        
  102.239  [1]   |
  882.606  [51]  |∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  1662.973 [91]  |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  2443.340 [147] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  3223.707 [76]  |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  4004.074 [63]  |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  4784.441 [30]  |∎∎∎∎∎∎∎∎
  5564.808 [12]  |∎∎∎
  6345.175 [4]   |∎
  7125.542 [1]   |
  7905.909 [1]   |

Latency distribution:
  10 % in 868.36 ms
  25 % in 1.49 s
  50 % in 2.20 s
  75 % in 3.11 s
  90 % in 4.11 s
  95 % in 4.49 s
  99 % in 5.89 s

Status code distribution:
  [OK]            477 responses
  [Unavailable]   523 responses
```