#!/bin/bash

# Prompt for Docker registry credentials
read -p "Enter Docker Registry Server: " REGISTRY_SERVER
read -p "Enter Docker Registry Username: " REGISTRY_USERNAME
read -sp "Enter Docker Registry Password: " REGISTRY_PASSWORD
echo
read -p "Enter Docker Registry Email: " EMAIL_ADDRESS

# Encode the Docker configuration as a base64 string
DOCKER_CONFIG_JSON=$(echo -n "{\"auths\":{\"$REGISTRY_SERVER\":{\"username\":\"$REGISTRY_USERNAME\",\"password\":\"$REGISTRY_PASSWORD\",\"email\":\"$EMAIL_ADDRESS\"}}}" | base64 -w 0)

# Define constants
NAMESPACE="rhde-dev-instance"
SERVICE_ACCOUNT="pipeline"
SECRET_NAME="registry-pull-secret"

# Create Docker registry secret YAML
cat <<EOF > $SECRET_NAME.yaml
apiVersion: v1
kind: Secret
metadata:
  name: $SECRET_NAME
data:
  .dockerconfigjson: $DOCKER_CONFIG_JSON
type: kubernetes.io/dockerconfigjson
EOF

echo "Secret YAML file created: $SECRET_NAME.yaml"


oc create -f $SECRET_NAME.yaml --namespace=$NAMESPACE

# Patch the service account to include the secret
oc patch serviceaccount $SERVICE_ACCOUNT \
  -p "{\"secrets\": [{\"name\": \"$SECRET_NAME\"}]}" \
  --namespace=$NAMESPACE

echo "Secret attached to the service account successfully."
