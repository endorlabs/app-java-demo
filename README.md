# Java Web Application Demo - Security Scanning

This is a demo Java web application configured with Endor Labs security vulnerability scanning.

## Quick Start - Security Scanning

This repository is configured to run comprehensive security scans using Endor Labs. The scans identify:

- 🔍 **Vulnerabilities in dependencies** (CVEs, security issues)
- 🔐 **Leaked secrets** (API keys, passwords, tokens)
- 📦 **Supply chain risks** (malicious packages, unmaintained dependencies)

### Running a Scan

1. **Set up your credentials:**
   ```bash
   export ENDOR_NAMESPACE="your-namespace"
   export ENDOR_API_KEY="your-api-key"
   export ENDOR_API_SECRET="your-api-secret"
   ```

2. **Run the scan:**
   ```bash
   ./run-endor-scan.sh
   ```

The script will automatically download the `endorctl` binary if needed and execute a comprehensive security scan.

### Documentation

For detailed information about vulnerability scanning, see [VULNERABILITY_SCAN.md](VULNERABILITY_SCAN.md)

## Project Structure

```
.
├── run-endor-scan.sh       # Script to run Endor Labs security scan
├── VULNERABILITY_SCAN.md   # Detailed scanning documentation
├── pom.xml                 # Maven project configuration
├── src/                    # Source code
└── .github/workflows/      # GitHub Actions workflows
```

## GitHub Actions Integration

The repository includes a workflow that can run automated scans on pull requests and commits. See `.github/workflows/main.yml` for configuration.

## Dependencies

This Maven project includes several dependencies. Some may have known security vulnerabilities:

- `org.apache.logging.log4j:log4j-core:2.3`
- `mysql:mysql-connector-java:5.1.42`
- `org.apache.commons:commons-text:1.9`
- And others...

**Run a security scan to get detailed vulnerability reports and remediation advice.**

## Building the Project

```bash
mvn clean install
```

## More Information

- 📚 [Vulnerability Scanning Guide](VULNERABILITY_SCAN.md)
- 🔗 [Endor Labs Documentation](https://docs.endorlabs.com)
- 🏢 [Endor Labs](https://endorlabs.com)
