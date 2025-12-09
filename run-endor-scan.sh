#!/bin/bash
#
# Endor Labs Security Scanner Script
# This script runs security scans using the Endor Labs MCP server
#

# Repository path
REPO_PATH="/home/runner/work/app-java-demo/app-java-demo"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "======================================"
echo "Endor Labs Security Scanner"
echo "======================================"
echo ""
echo "Repository: $REPO_PATH"
echo "Timestamp: $(date)"
echo ""

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all               Run all scan types (vulnerabilities, secrets, dependencies)"
    echo "  --vulnerabilities   Scan for code vulnerabilities only"
    echo "  --secrets          Scan for leaked secrets only"
    echo "  --dependencies     Scan dependencies only"
    echo "  --help             Display this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --all"
    echo "  $0 --vulnerabilities"
    echo "  $0 --secrets --dependencies"
    exit 1
}

# Parse command line arguments
SCAN_TYPES=""
if [ $# -eq 0 ]; then
    # Default: run all scans
    SCAN_TYPES="vulnerabilities,secrets,dependencies"
else
    while [[ $# -gt 0 ]]; do
        case $1 in
            --all)
                SCAN_TYPES="vulnerabilities,secrets,dependencies"
                shift
                ;;
            --vulnerabilities)
                SCAN_TYPES="${SCAN_TYPES}vulnerabilities,"
                shift
                ;;
            --secrets)
                SCAN_TYPES="${SCAN_TYPES}secrets,"
                shift
                ;;
            --dependencies)
                SCAN_TYPES="${SCAN_TYPES}dependencies,"
                shift
                ;;
            --help)
                usage
                ;;
            *)
                echo -e "${RED}Error: Unknown option $1${NC}"
                usage
                ;;
        esac
    done
fi

# Remove trailing comma
SCAN_TYPES=${SCAN_TYPES%,}

if [ -z "$SCAN_TYPES" ]; then
    echo -e "${RED}Error: No scan types specified${NC}"
    usage
fi

echo -e "${YELLOW}Scan Types: $SCAN_TYPES${NC}"
echo ""

# Run the scan using endor-labs MCP server
echo -e "${GREEN}Starting scan...${NC}"
echo ""

# This would be invoked via the MCP server tool
# For now, we're documenting the expected invocation
echo "The following scan would be executed via the Endor Labs MCP server:"
echo "  Tool: endor-labs-scan"
echo "  Path: $REPO_PATH"
echo "  Scan Types: $SCAN_TYPES"
echo ""

# Note: The actual scan is performed via the MCP server tool:
# endor-labs-scan with parameters:
#   - path: $REPO_PATH
#   - scan_types: array of selected scan types

echo -e "${YELLOW}Note: This script documents the scan configuration.${NC}"
echo -e "${YELLOW}The actual scan is performed via the Endor Labs MCP server tool.${NC}"
echo ""
echo "======================================"
echo "Scan Configuration Complete"
echo "======================================"
