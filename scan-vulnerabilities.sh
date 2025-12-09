#!/bin/bash
# Endor Labs Vulnerability Scan Script
# This script performs a comprehensive vulnerability scan using endorctl

set -e

echo "Starting Endor Labs vulnerability scan..."
echo "Repository: app-java-demo"
echo "Scan types: vulnerabilities, secrets, dependencies"
echo ""

# Run endorctl scan with multiple scan types
./endorctl scan \
  --path=. \
  --dependencies \
  --secrets \
  --languages=java \
  --output-type=summary \
  ${ENDOR_NAMESPACE:+--namespace=$ENDOR_NAMESPACE} \
  ${ENDOR_API_KEY:+--api-key=$ENDOR_API_KEY} \
  ${ENDOR_API_SECRET:+--api-secret=$ENDOR_API_SECRET}

echo ""
echo "Scan completed successfully!"
