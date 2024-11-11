#!/bin/bash

# Exit if any command fails
set -e

echo "Starting deployment process..."

# Step 1: Build Docker images (with check)
echo "Building Docker images..."
docker images | grep -q "custom-postgres-image" || docker build -t custom-postgres-image ./postgres-k8s
docker images | grep -q "card-service" || docker build -t card-service ./card-service
docker images | grep -q "transaction-service" || docker build -t transaction-service ./transaction-service
docker images | grep -q "ledger-service" || docker build -t ledger-service ./ledger-service
docker images | grep -q "notification-service" || docker build -t notification-service ./notification-service

# Step 2: Apply Kubernetes configurations
echo "Applying Kubernetes configurations..."

# Use kubectl apply to update or create resources
kubectl apply -f kubernetes/postgres-configmap.yaml
kubectl apply -f kubernetes/postgres-secret.yaml
kubectl apply -f kubernetes/postgres-storage.yaml
kubectl apply -f kubernetes/postgres-deployment.yaml
kubectl apply -f kubernetes/postgres-service.yaml

kubectl apply -f ./kubernetes/card-service.yaml
kubectl apply -f ./kubernetes/transaction-service.yaml
kubectl apply -f ./kubernetes/ledger-service.yaml
kubectl apply -f ./kubernetes/notification-service.yaml
kubectl apply -f ./kubernetes/nats-server.yaml
kubectl apply -f ./kubernetes/configmaps/envoy-config.yaml
kubectl apply -f ./kubernetes/envoy-deployment.yaml

echo "Waiting for all pods to be ready..."
kubectl wait --for=condition=ready pod --all --timeout=300s

echo "Deployment successful!"

# Database Restore (Optional, with check)
read -p "Do you want to restore the database from a backup.sql file? (y/n) " -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Check if the database has already been restored
    POSTGRES_POD=$(kubectl get pods --selector=app=postgres -o jsonpath='{.items[0].metadata.name}')
    echo "Checking if database is already restored..."

    # Check for an existing table as a restoration marker (replace 'some_table' with an actual table name)
    if kubectl exec -it $POSTGRES_POD -- psql -U postgres -d Financial_ledger_db -c '\dt' | grep -q 'some_table'; then
        echo "Database already restored. Skipping restore."
    else
        echo "Restoring database..."
        kubectl cp backup.sql $POSTGRES_POD:/tmp/backup.sql
        kubectl exec -it $POSTGRES_POD -- psql -U postgres -d Financial_ledger_db -f /tmp/backup.sql
        echo "Database restored successfully!"
    fi
fi

echo "All done!"