# Financial Ledger System

This project implements a financial ledger system using a microservices architecture to handle transactions, ledger entries, and notifications efficiently. The architecture leverages **gRPC** for direct service-to-service communication and **NATS** as an event streaming platform to manage real-time event-driven workflows. Each microservice is containerized with **Docker** and orchestrated on **Kubernetes** to ensure scalability, resilience, and ease of management.

## Project Overview

In this financial ledger system, each microservice plays a specialized role:

- **Card Service**: Manages and provides card information via gRPC, allowing other services to access card details on demand.
- **Transaction Service**: Handles financial transactions and publishes events to the ledger and notification services via NATS.
- **Ledger Service**: Maintains a financial ledger, updating entries for each transaction and publishing updates to notify other services.
- **Notification Service**: Listens for transaction and ledger events on NATS and manages user notifications related to account activities.

### Key Tools and Technologies

- **gRPC**: Facilitates secure and high-performance service-to-service communication, ensuring that data between services (e.g., card details) is shared reliably and efficiently.
- **NATS**: Provides a lightweight messaging system for real-time event streaming, ensuring seamless integration of event-driven processes.
- **Docker**: Enables consistent and isolated runtime environments for each microservice.
- **Kubernetes**: Manages and scales the containerized services across clusters for high availability and resource efficiency.

## Service Descriptions

### 1. Card Service

- **Purpose**: Serves as the central source for card-related information within the system.
- **Implementation**:
  - Built in Go, utilizing gRPC for fast and secure communication.
  - Offers the `GetCard` RPC method, which provides information (e.g., cardholder name, card type) when a valid card ID is passed.
  - This service is crucial for ensuring transaction validity by verifying card details.
- **Tools**: `gRPC`, `Docker`, `Kubernetes`.

#### Example Request

A client or service can request card details by sending a `CardRequest` with a card ID. The Card Service responds with a `CardResponse` containing the requested card information, which is then used by other services, such as the Transaction Service, for further processing.

### 2. Transaction Service

- **Purpose**: Manages financial transactions and communicates transaction events to the ledger and notification systems.
- **Implementation**:
  - Retrieves card details by calling the Card Service using gRPC.
  - Processes each transaction and publishes a `transaction.created` event to the NATS messaging system, allowing other services to react to new transactions.
  - Acts as the entry point for transaction-related actions, ensuring transactions are properly recorded and broadcasted.
- **Tools**: `gRPC`, `NATS`, `Docker`, `Kubernetes`.

#### Example Flow

1. Receives a request to process a new transaction.
2. Calls the Card Service’s `GetCard` RPC to verify card details.
3. Publishes a message to the NATS `transaction.created` subject with transaction information (e.g., amount, card ID).
   
### 3. Ledger Service

- **Purpose**: Maintains a financial ledger that records all transaction entries, ensuring an accurate and up-to-date balance sheet for each card.
- **Implementation**:
  - Subscribes to `transaction.created` events on NATS, recording each transaction as a new ledger entry.
  - Publishes a `ledger.entry_created` event on NATS, signaling that a transaction has been added to the ledger.
  - The ledger service ensures that each transaction is accounted for, making it a crucial part of the financial reporting system.
- **Tools**: `gRPC`, `NATS`, `Docker`, `Kubernetes`.

#### Example Flow

1. Subscribes to `transaction.created` on NATS to capture new transactions.
2. Records a ledger entry for each transaction, storing details such as date, amount, and card ID.
3. Publishes a `ledger.entry_created` event on NATS, enabling other services (such as Notification Service) to process the ledger entry.

### 4. Notification Service

- **Purpose**: Sends notifications related to account activities, informing users about recent transactions or account changes.
- **Implementation**:
  - Subscribes to `transaction.created` and `ledger.entry_created` events on NATS.
  - Sends alerts or updates based on the type of event received, enhancing the user experience by keeping users informed of financial activity.
  - The notification service ensures that users are aware of important actions in real time, adding transparency to the financial ledger system.
- **Tools**: `NATS`, `Node.js`, `Docker`, `Kubernetes`.

#### Example Flow

1. Subscribes to `transaction.created` and `ledger.entry_created` events on NATS.
2. Logs or sends notifications for each event, alerting users about new transactions or ledger updates.

---

# Docker Setup

## Docker Setup for Postgres

### Steps 1 : go to postgres-k8s folder
```bash
cd postgres-k8s
```

### Steps 2 : Make docker image
```bash
docker build -t custom-postgres-image .
```

### Steps 3 : Run kubernetes yaml files
```bash
kubectl apply -f kubernetes/postgres-configmap.yaml
kubectl apply -f kubernetes/postgres-secret.yaml
kubectl apply -f kubernetes/postgres-storage.yaml
kubectl apply -f kubernetes/postgres-deployment.yaml
kubectl apply -f kubernetes/postgres-service.yaml
```

### Step 4: Restore Database from backup.sql file
#### step 1: get podname for postgres
```bash
kubectl get pods
```

#### step 2: copy the backup file into the pod using kubectl cp
```bash
kubectl cp backup.sql <postgres-pod-name>:/tmp/backup.sql
```
#### step 3: Execute the restore command:
```bash
kubectl exec -it <postgres-pod-name> -- psql -U postgres -d Financial_ledger_db -f /tmp/backup.sql
```
#### step 4: Verify the Data(Optional)
```bash
kubectl exec -it <postgres-pod-name> -- psql -U postgres -d Financial_ledger_db
```
```sql
Run \dt
```


## Docker Setup for Services

Each service is packaged as a Docker container. To build the images for deployment, use:

```bash
docker build -t card-service -f card-service/Dockerfile .
docker build -t transaction-service -f transaction-service/Dockerfile .
docker build -t ledger-service -f ledger-service/Dockerfile .
docker build -t notification-service -f notification-service/Dockerfile .
```


# Kubernetes Setup
The Kubernetes configurations (YAML files) for each service should be deployed in your cluster. Apply the configurations:

## Running prometheus and grafana

### Step 1:Create namespace monitoring
```bash
kubectl create namespace monitoring
```

### Step 2:Download crds
```bash
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/bundle.yaml
```

### Step 3:Apply yaml files
```bash
kubectl apply -f ./kubernetes/card-service.yaml
kubectl apply -f ./kubernetes/transaction-service.yaml
kubectl apply -f ./kubernetes/ledger-service.yaml
kubectl apply -f ./kubernetes/notification-service.yaml
kubectl apply -f ./kubernetes/nats-server.yaml
kubectl apply -f ./kubernetes/configmaps/envoy-config.yaml
kubectl apply -f ./kubernetes/envoy-deployment.yaml
kubectl apply -f ./kubernetes/benchmark-service-deployment.yaml
kubectl apply -f ./kubernetes/benchmark-service.yaml
kubectl apply -f ./kubernetes/prometheus-configmap.yaml -n monitoring
kubectl apply -f ./kubernetes/node-exporter.yaml -n monitoring
kubectl apply -f ./kubernetes/node-exporter-services.yaml -n monitoring
kubectl apply -f ./kubernetes/node-exporter-deployment.yaml -n monitoring
kubectl apply -f ./kubernetes/prometheus-deployment.yaml -n monitoring
kubectl apply -f ./kubernetes/prometheus.yaml -n monitoring
kubectl apply -f ./kubernetes/grafana.yaml -n monitoring
kubectl apply -f ./kubernetes/service-monitors.yaml -n monitoring
```

### Step 4:port forwarding for prometheus
```bash
kubectl port-forward svc/prometheus -n monitoring 9090:9090
```
### Step 5:port forwarding for grafana
```bash
kubectl port-forward svc/grafana 3000:3000 -n monitoring
```
### Step 6:port forwarding for nats
```bash
kubectl port-forward svc/nats-server 4222:4222
```


# Running the Project

## Steps
1. Build Docker images:

2. Deploy to Kubernetes: Apply each service’s deployment and service YAML files to set up networking and  
scaling.

# Running Benchmark Testing

After setting up the project, run benchmark testing by executing the following command:

```bash
go run benchmark-setup-v1.go
```
This command initiates benchmark testing to evaluate the performance metrics of the system, providing insights into throughput and latency for both gRPC and NATS-based interactions.

 <img alt="backend-architecture" src="https://res.cloudinary.com/dxf1kplcx/image/upload/v1731337255/FVF_1_w1fr6s.png">