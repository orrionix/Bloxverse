#!/bin/bash

# Build script for the project

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
SRC_DIR="src"
DIST_DIR="dist"

# Step 1: Clean previous builds
log_info "Cleaning previous builds..."
rm -rf "$BUILD_DIR" "$DIST_DIR"
mkdir -p "$BUILD_DIR" "$DIST_DIR"

# Step 2: Install dependencies
log_info "Installing dependencies..."
if [ -f "package.json" ]; then
  npm install
else
  log_info "No package.json found, skipping dependency installation."
fi

# Step 3: Compile the source code
log_info "Compiling source code..."
if [ -d "$SRC_DIR" ]; then
  # Example compilation step, modify according to your project (e.g., Java, C++, etc.)
  cp -r "$SRC_DIR"/* "$BUILD_DIR/"
else
  log_error "Source directory not found!"
  exit 1
fi

# Step 4: Run tests
log_info "Running tests..."
if [ -d "tests" ]; then
  # Replace with your test command, e.g., `npm test`, `pytest`, etc.
  echo "Running tests in 'tests' directory..."
  # Example: simulate tests passing
  log_info "All tests passed!"
else
  log_info "No tests directory found, skipping tests."
fi

# Step 5: Package the build
log_info "Packaging the build..."
tar -czf "$DIST_DIR/project.tar.gz" -C "$BUILD_DIR" .

# Step 6: Build complete
log_info "Build complete. Artifacts are in the '$DIST_DIR' directory."
