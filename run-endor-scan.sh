#!/bin/bash

# Endor Labs Security Scan Script
# This script runs vulnerability scanning using Endor Labs tools

set -e

REPO_PATH="/home/runner/work/app-java-demo/app-java-demo"
NAMESPACE="${ENDOR_NAMESPACE:-release-test}"

echo "=========================================="
echo "Endor Labs Vulnerability Scan"
echo "=========================================="
echo "Repository: $REPO_PATH"
echo "Namespace: $NAMESPACE"
echo ""

# Check if endorctl is available
if ! command -v endorctl &> /dev/null; then
    echo "Error: endorctl is not installed"
    echo "Please install endorctl before running this script"
    exit 1
fi

# Build the project first
echo "Step 1: Building the project..."
cd "$REPO_PATH"
mvn clean compile

echo ""
echo "Step 2: Running Endor Labs security scan..."
echo "Scan types: vulnerabilities, secrets, dependencies"
echo ""

# Run the scan with endorctl
# Note: This requires proper authentication credentials to be set
# via environment variables or command-line flags:
# - ENDOR_API or --api
# - ENDOR_API_KEY or --api-key  
# - ENDOR_API_SECRET or --api-secret
# - ENDOR_NAMESPACE or --namespace

endorctl scan \
    --path "$REPO_PATH" \
    --namespace "$NAMESPACE" \
    --dependencies \
    --secrets \
    --output-type summary

echo ""
echo "Scan completed successfully!"
