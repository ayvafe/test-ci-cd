#!/bin/bash

# Set the Docker image name and version
IMAGE_TAG=$(git rev-parse --short HEAD)
IMAGE_NAME="test-ci-cd"
DOCKER_USERNAME="$DOCKER_USERNAME"
DOCKER_PASSWORD="$DOCKER_PASSWORD"
IMAGE_TAG=$(git rev-parse --short HEAD)

# Build the Docker image
docker-compose build --tag $IMAGE_NAME:$IMAGE_TAG

# Tag the Docker image for the ECR repository
cat "$DOCKER_TOKEN" | docker login --username foo --password-stdin |
docker login --username develemento --password dojo1234$
docker tag $IMAGE_NAME:$IMAGE_TAG $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG

# Push the Docker image to the ECR repository
docker push $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG

# Apply the Kubernetes configuration
kubectl apply -f kubernetes/deployment.yaml kubernetes/service.yaml
