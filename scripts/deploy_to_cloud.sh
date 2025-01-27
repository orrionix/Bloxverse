#!/bin/bash

# Script to deploy the project to the cloud

# Exit on any error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Functions for logging
log_info() {
  echo -e "${GREEN}[INFO] $1${NC}"
}

log_error() {
  echo -e "${RED}[ERROR] $1${NC}"
}

# Paths and Configurations
BUILD_DIR="build"
DEPLOY_CONFIG_FILE="config/deploy_config.env"
CLOUD_PROVIDER="AWS" # Change to GCP, Azure, etc., as needed
DEPLOYMENT_SCRIPT="$BUILD_DIR/deploy.sh"

# Step 1: Load Deployment Configuration
log_info "Loading deployment configuration..."
if [ -f "$DEPLOY_CONFIG_FILE" ]; then
  set -o allexport
  source "$DEPLOY_CONFIG_FILE"
  set +o allexport
  log_info "Deployment configuration loaded successfully."
else
  log_error "Deployment configuration file not found: $DEPLOY_CONFIG_FILE"
  exit 1
fi

# Step 2: Verify Cloud Credentials
log_info "Verifying cloud credentials..."
if [ -z "$CLOUD_ACCESS_KEY" ] || [ -z "$CLOUD_SECRET_KEY" ]; then
  log_error "Cloud credentials are not set. Please check your $DEPLOY_CONFIG_FILE."
  exit 1
fi
log_info "Cloud credentials are set."

# Step 3: Build the Project
log_info "Building the project for deployment..."
if [ -d "$BUILD_DIR" ]; then
  log_info "Build directory already exists. Skipping build step."
else
  ./build.sh
fi

# Step 4: Deploy to Cloud
log_info "Deploying the project to the $CLOUD_PROVIDER..."
if [ -f "$DEPLOYMENT_SCRIPT" ]; then
  bash "$DEPLOYMENT_SCRIPT"
else
  log_error "Deployment script not found: $DEPLOYMENT_SCRIPT."
  exit 1
fi

# Step 5: Post-Deployment Tasks
log_info "Running post-deployment tasks..."
# Example: Running a health check
HEALTH_CHECK_URL="${DEPLOYMENT_URL}/health"
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" "$HEALTH_CHECK_URL")

if [ "$HTTP_STATUS" -eq 200 ]; then
  log_info "Health check passed! Deployment was successful."
else
  log_error "Health check failed with status code $HTTP_STATUS."
  exit 1
fi

log_info "Deployment to the cloud is complete!"
