#!/bin/bash

# Exit script if any command fails
set -e

echo "Starting cleanup process..."

# Define a function to delete a resource if it exists
delete_resource() {
    RESOURCE_TYPE=$1
    RESOURCE_NAME=$2
    NAMESPACE=${3:-default}

    if kubectl get "$RESOURCE_TYPE" "$RESOURCE_NAME" -n "$NAMESPACE" >/dev/null 2>&1; then
        echo "Deleting $RESOURCE_TYPE $RESOURCE_NAME in namespace $NAMESPACE..."
        kubectl delete "$RESOURCE_TYPE" "$RESOURCE_NAME" -n "$NAMESPACE"
    else
        echo "$RESOURCE_TYPE $RESOURCE_NAME does not exist in namespace $NAMESPACE. Skipping deletion."
    fi
}

# Step 1: Delete Deployments
echo "Deleting deployments..."
delete_resource deployment card-service
delete_resource deployment transaction-service
delete_resource deployment ledger-service
delete_resource deployment notification-service
delete_resource deployment nats-server
delete_resource deployment envoy
delete_resource deployment postgres

# Step 2: Delete Services
echo "Deleting services..."
delete_resource service card-service
delete_resource service transaction-service
delete_resource service ledger-service
delete_resource service notification-service
delete_resource service nats-server
delete_resource service postgres-service

# Step 3: Delete ConfigMaps and Secrets
echo "Deleting ConfigMaps and Secrets..."
delete_resource configmap postgres-configmap
delete_resource configmap envoy-config
delete_resource secret postgres-secret

# Step 4: Delete Persistent Volume Claims and Storage
echo "Deleting Persistent Volume Claims and Persistent Volumes..."
delete_resource pvc postgres-pvc
delete_resource pv postgres-pv

# Step 5: Confirm deletion of all pods in the namespace (optional)
echo "Deleting all remaining pods (optional)..."
kubectl delete pod --all -n default

# Final Check
echo "Waiting for all resources to be terminated..."
kubectl wait --for=delete pod --all --timeout=300s -n default

echo "Cleanup complete!"