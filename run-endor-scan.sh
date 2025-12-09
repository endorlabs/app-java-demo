#!/bin/bash

# Endor Labs Vulnerability Scan Script
# This script runs a comprehensive security scan using Endor Labs

set -e

# Configuration for endorctl download
ENDORCTL_VERSION="${ENDORCTL_VERSION:-v1.7.688}"
ENDORCTL_URL="https://api.staging.endorlabs.com/download/endorlabs/${ENDORCTL_VERSION}/binaries/endorctl_${ENDORCTL_VERSION}_linux_amd64"
ENDORCTL_SHA256="2dd5e32c21afc893d1229a1c6e9864ad82ce2d1bc2f8e6cbfe9f5acba7f461a9"

# Check if endorctl is available, download if not
if [ ! -f "./endorctl" ]; then
    echo "endorctl not found. Downloading version ${ENDORCTL_VERSION}..."
    curl -L "$ENDORCTL_URL" -o endorctl
    
    # Verify checksum
    echo "${ENDORCTL_SHA256} endorctl" | sha256sum --check
    
    # Make executable
    chmod +x ./endorctl
    echo "endorctl downloaded and verified successfully"
else
    # Ensure endorctl is executable
    chmod +x ./endorctl
fi

# Configuration
SCAN_PATH="${SCAN_PATH:-.}"
NAMESPACE="${ENDOR_NAMESPACE:-}"
API_KEY="${ENDOR_API_KEY:-}"
API_SECRET="${ENDOR_API_SECRET:-}"

# Check for required credentials
if [ -z "$NAMESPACE" ] || [ -z "$API_KEY" ] || [ -z "$API_SECRET" ]; then
    echo "Error: Required environment variables not set"
    echo "Please set the following environment variables:"
    echo "  - ENDOR_NAMESPACE: Your Endor Labs namespace"
    echo "  - ENDOR_API_KEY: Your Endor Labs API key"
    echo "  - ENDOR_API_SECRET: Your Endor Labs API secret"
    exit 1
fi

echo "Starting Endor Labs vulnerability scan..."
echo "Scan path: $SCAN_PATH"
echo "Namespace: $NAMESPACE"
echo ""

# Run the scan with multiple security checks
# - dependencies: Scan for vulnerable dependencies
# - secrets: Scan for leaked secrets
./endorctl scan \
    --path="$SCAN_PATH" \
    --namespace="$NAMESPACE" \
    --api-key="$API_KEY" \
    --api-secret="$API_SECRET" \
    --dependencies \
    --secrets \
    --verbose

echo ""
echo "Scan completed successfully!"
