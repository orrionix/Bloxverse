#!/bin/bash

# Script to run the project locally

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

# Paths
BUILD_DIR="build"
CONFIG_FILE="config/local_config.env"
START_SCRIPT="$BUILD_DIR/start.sh"

# Step 1: Check if the project is built
log_info "Checking if the project is built..."
if [ ! -d "$BUILD_DIR" ]; then
  log_error "Build directory not found. Please run ./build.sh first."
  exit 1
fi

# Step 2: Load environment variables
log_info "Loading local environment variables..."
if [ -f "$CONFIG_FILE" ]; then
  set -o allexport
  source "$CONFIG_FILE"
  set +o allexport
  log_info "Environment variables loaded successfully."
else
  log_error "Local configuration file not found: $CONFIG_FILE"
  exit 1
fi

# Step 3: Start the project locally
log_info "Starting the project locally..."
if [ -f "$START_SCRIPT" ]; then
  bash "$START_SCRIPT"
else
  log_error "Start script not found in $START_SCRIPT."
  exit 1
fi

# Step 4: Running completion message
log_info "The project is running locally. Press Ctrl+C to stop."
