#!/bin/bash
# Endor Labs Vulnerability Scan Script
# This script performs a comprehensive vulnerability scan using endorctl

set -e

echo "Starting Endor Labs vulnerability scan..."
echo "Repository: app-java-demo"
echo "Scan types: vulnerabilities, secrets, dependencies"
echo ""

# Check if namespace is set and validate it
if [ -z "$ENDOR_NAMESPACE" ]; then
  echo "Error: ENDOR_NAMESPACE environment variable is required"
  echo "Please set it before running this script:"
  echo "  export ENDOR_NAMESPACE=your-namespace"
  exit 1
fi

# Validate namespace contains only safe characters (alphanumeric, dash, underscore)
if ! [[ "$ENDOR_NAMESPACE" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Error: ENDOR_NAMESPACE contains invalid characters"
  echo "Only alphanumeric characters, dashes, and underscores are allowed"
  exit 1
fi

# Run endorctl scan with multiple scan types
./endorctl scan \
  --path=. \
  --dependencies \
  --secrets \
  --languages=java \
  --output-type=summary \
  --namespace="$ENDOR_NAMESPACE" \
  ${ENDOR_API_KEY:+--api-key="$ENDOR_API_KEY"} \
  ${ENDOR_API_SECRET:+--api-secret="$ENDOR_API_SECRET"}

echo ""
echo "Scan completed successfully!"
