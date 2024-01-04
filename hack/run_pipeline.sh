#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 registry-quay-quay.apps.lab.example.com/admin/redhat-edge-ai-industrial-demo"
  exit 1
fi

# Define your parameters
GIT_URL="https://github.com/tosin2013/redhat-edge-ai-industrial-demo.git"
IMAGE="image-registry.openshift-image-registry.svc:5000/rhde-dev-instance/redhat-edge-ai-industrial-demo:latest"
BUILDAH_PLATFORMS="linux/amd64,linux/arm64/v8"
OUTPUT_CONTAINER_IMAGE="$1"
BUILD_DIR="container-development"
TLS_VERIFY="false"
WORKSPACE_NAME="scratch"
PVC_NAME="pipelines-test"

# Function to start the pipeline
start_pipeline() {
  oc delete pvc $PVC_NAME -n rhde-dev-instance --wait=true
  sleep 10s

  # Start the pipeline with predefined parameters
  tkn pipeline start build-and-deploy \
    -n rhde-dev-instance \
    -p git-url="$GIT_URL" \
    -p IMAGE="$IMAGE" \
    -p buildahPlatforms="$BUILDAH_PLATFORMS" \
    -p outputContainerImage="$OUTPUT_CONTAINER_IMAGE" \
    -p BUILD_DIR="$BUILD_DIR" \
    -p tlsVerify="$TLS_VERIFY" \
    --pipeline-timeout "6h" \
    -w name="$WORKSPACE_NAME",claimName="$PVC_NAME"

  echo "Pipeline started successfully."
}


oc delete pvc $PVC_NAME -n rhde-dev-instance --wait=true
sleep 10s

# Start the pipeline with predefined parameters
tkn pipeline start build-and-deploy \
  -n rhde-dev-instance \
  -p git-url="$GIT_URL" \
  -p IMAGE="$IMAGE" \
  -p buildahPlatforms="$BUILDAH_PLATFORMS" \
  -p outputContainerImage="$OUTPUT_CONTAINER_IMAGE" \
  -p BUILD_DIR="$BUILD_DIR" \
  -p tlsVerify="$TLS_VERIFY" \
  --pipeline-timeout "6h" \
  -w name="$WORKSPACE_NAME",claimName="$PVC_NAME"

echo "Pipeline started successfully."

# Get the name and status of the pipeline run
pipeline_run=$(tkn pipelinerun list | grep build-and-deploy-run | awk '{print $1,$4}')

# Extract the name and status
name=$(echo $pipeline_run | cut -d' ' -f1)
status=$(echo $pipeline_run | cut -d' ' -f2)

# Check the status of the pipeline run
if [ "$status" == "Running" ]; then
    # Tail the logs if it's running
    tkn pipelinerun logs -f $name
elif [ "$status" == "Failed" ]; then
    # Delete the pipeline run if it failed
    tkn pipelinerun delete $name
    start_pipeline
else
    # Start the pipeline run if it does not exist or has been deleted
    start_pipeline
fi
