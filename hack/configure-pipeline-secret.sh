#!/bin/bash

# Prompt for Docker registry credentials
read -p "Enter Docker Registry Server: " REGISTRY_SERVER
read -p "Enter Docker Registry Username: " REGISTRY_USERNAME
read -sp "Enter Docker Registry Password: " REGISTRY_PASSWORD
echo
read -p "Enter Docker Registry Email: " EMAIL_ADDRESS

# Define constants
NAMESPACE="rhde-dev-instance"
SERVICE_ACCOUNT="pipeline"
SECRET_NAME="registry-pull-secret"

# Create Docker registry secret
oc create secret docker-registry $SECRET_NAME \
  --docker-server=$REGISTRY_SERVER \
  --docker-username=$REGISTRY_USERNAME \
  --docker-password=$REGISTRY_PASSWORD \
  --docker-email=$EMAIL_ADDRESS \
  --namespace=$NAMESPACE

# Patch the service account to include the secret
oc patch serviceaccount $SERVICE_ACCOUNT \
  -p "{\"secrets\": [{\"name\": \"$SECRET_NAME\"}]}" \
  --namespace=$NAMESPACE

echo "Secret attached to the service account successfully."
