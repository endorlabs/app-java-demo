# Endor Labs Vulnerability Scanning

This repository is configured for security vulnerability scanning using Endor Labs.

## Available Scanning Methods

### 1. Using the Endor Labs MCP Server Tools

The Endor Labs MCP (Model Context Protocol) server provides programmatic access to scan functionality:

- `endor-labs-scan`: Scans a project for security issues including:
  - Vulnerabilities in code
  - Dependencies with security issues  
  - Leaked secrets

- `endor-labs-check_dependency_for_vulnerabilities`: Checks a specific dependency for vulnerabilities

- `endor-labs-get_endor_vulnerability`: Retrieves vulnerability information from the Endor database

### 2. Using the endorctl CLI

The `endorctl` command-line tool is available for manual scans:

```bash
# Run a comprehensive security scan
./run-endor-scan.sh
```

Or manually:

```bash
# Build the project first
mvn clean compile

# Run the scan
endorctl scan \
    --path . \
    --namespace release-test \
    --dependencies \
    --secrets \
    --output-type summary
```

### 3. Using GitHub Actions

The repository includes a GitHub Actions workflow (`.github/workflows/main.yml`) that runs Endor Labs scans automatically using the `endorlab/github-action`.

## Scan Types

- **Dependencies**: Scans dependencies for known vulnerabilities
- **Secrets**: Scans for leaked secrets in code and git history
- **Vulnerabilities**: Scans code for security vulnerabilities

## Authentication

Endor Labs scanning requires authentication credentials:

- `ENDOR_API`: API URL (default: https://api.endorlabs.com)
- `ENDOR_API_KEY`: API key for authentication
- `ENDOR_API_SECRET`: API secret for authentication  
- `ENDOR_NAMESPACE`: Namespace (default: release-test)

These can be provided via environment variables or command-line flags.

## Dependencies in This Project

This Java Maven project includes several dependencies that should be scanned:

- `org.apache.commons:commons-text:1.9`
- `mysql:mysql-connector-java:5.1.42`
- `org.apache.logging.log4j:log4j-core:2.3`
- `com.mchange:c3p0:0.9.5.2`
- And others (see `pom.xml`)

Some of these dependencies may have known vulnerabilities and should be regularly scanned.
