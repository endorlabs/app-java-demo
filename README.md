# Endor Java Demo Application

A sample Java web application demonstrating various security scanning capabilities with Endor Labs.

## Project Overview

This is a Maven-based Java application (version 4.0-SNAPSHOT) built with:
- Java 8 (source and target)
- Maven 3.x
- Various servlet and security-related dependencies

## Building the Application

```bash
# Clean and build
mvn clean install

# Run tests
mvn test

# Package as JAR
mvn package
```

## Running with Docker

```bash
# Build the Docker image
docker build -t endor-java-webapp-demo .

# Run the container
docker run -p 443:443 endor-java-webapp-demo
```

## Security Scanning with Endor Labs

This repository is configured to run comprehensive security scans using Endor Labs to detect:
- Vulnerabilities in dependencies
- Secrets and credentials in code  
- Security issues in the dependency chain

### Quick Start

1. **Set up credentials:**
   ```bash
   export ENDOR_API_KEY="your-api-key"
   export ENDOR_API_SECRET="your-api-secret"
   export ENDOR_NAMESPACE="your-namespace"
   ```

2. **Run the scan:**
   ```bash
   ./run-vulnerability-scan.sh
   ```

For detailed instructions, see [VULNERABILITY_SCAN.md](VULNERABILITY_SCAN.md).

## GitHub Actions Integration

The repository includes automated security scanning via GitHub Actions:
- Workflow: `.github/workflows/main.yml`
- Trigger: Manual dispatch or on configured events
- Requires: Repository secrets for Endor Labs API credentials

## Project Structure

```
.
├── src/                    # Source code
├── lib/                    # External libraries
├── target/                 # Build output (gitignored)
├── pom.xml                # Maven configuration
├── Dockerfile             # Docker configuration
├── run-vulnerability-scan.sh  # Security scan script
└── VULNERABILITY_SCAN.md  # Detailed scan documentation
```

## Dependencies

Key dependencies include:
- javax.servlet-api (3.1.0)
- commons-text (1.9)
- mysql-connector-java (5.1.42)
- log4j-core (2.3)
- Various Arquillian and testing libraries

See `pom.xml` for the complete list.

## License

This is a demo application for security testing purposes.
