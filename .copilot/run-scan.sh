#!/bin/bash
# Script to run Endor Labs security scan
# This script provides a workaround for MCP timeout issues

set -e

REPO_PATH="${1:-.}"
NAMESPACE="${COPILOT_MCP_ENDOR_NAMESPACE:-}"

echo "==================================="
echo "Endor Labs Security Scan"
echo "==================================="
echo "Repository: $REPO_PATH"
echo "Namespace: ${NAMESPACE:-NOT_SET}"
echo ""

if [ -z "$NAMESPACE" ]; then
    echo "ERROR: NAMESPACE not set."
    echo "Please set COPILOT_MCP_ENDOR_NAMESPACE environment variable"
    echo "or provide namespace via --namespace flag"
    echo ""
    echo "Usage: $0 [path] [--namespace YOUR_NAMESPACE]"
    exit 1
fi

# Parse additional arguments
EXTRA_ARGS=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        --*)
            EXTRA_ARGS="$EXTRA_ARGS $1"
            shift
            ;;
        *)
            shift
            ;;
    esac
done

echo "Running Endor Labs scan..."
echo "Command: endorctl scan --namespace $NAMESPACE --path $REPO_PATH --dependencies --secrets $EXTRA_ARGS"
echo ""

# Run the scan
endorctl scan \
    --namespace "$NAMESPACE" \
    --path "$REPO_PATH" \
    --dependencies \
    --secrets \
    --output-type table \
    $EXTRA_ARGS

echo ""
echo "Scan completed successfully!"
