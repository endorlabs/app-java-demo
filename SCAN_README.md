# Dependency Vulnerability Scanning

This directory contains tools and documentation for scanning dependencies in `pom.xml` for security vulnerabilities using the Endor Labs MCP server.

## Files

### 1. `vulnerability-scan-report.md`
A comprehensive report documenting:
- All 16 dependencies found in pom.xml
- Attempted scans using Endor Labs MCP server
- Known vulnerabilities based on public CVE databases
- Recommendations for dependency updates

### 2. `scan-dependencies.sh`
An executable bash script that:
- Extracts all dependencies from pom.xml
- Displays dependency information in a format ready for scanning
- Highlights high-priority security concerns
- Provides guidance for using the Endor Labs MCP server

**Usage:**
```bash
./scan-dependencies.sh
```

### 3. `dependency-scan-data.json`
Structured JSON data containing:
- All dependency information (groupId, artifactId, version)
- Risk level assessments
- Known CVEs
- Scan attempt history
- Recommendations for updates

## Scan Execution Attempts

Multiple attempts were made to scan dependencies using the Endor Labs MCP server tool `check_dependency_for_vulnerabilities`:

### Attempted Approaches:
1. Individual dependency scans with full coordinates (groupId:artifactId)
2. Individual dependency scans with artifactId only
3. Individual dependency scans with groupId/artifactId format
4. Full project scan using `endor-labs-scan` tool
5. Different ecosystem parameters (maven, java)
6. Sequential scans with delays between requests

### Result:
All attempts resulted in **MCP server timeout errors** (Error -32001: Request timed out).

## Critical Security Findings

Despite the MCP server timeouts, manual analysis identified critical vulnerabilities:

### 🔴 CRITICAL
- **log4j-core 2.3** - Affected by Log4Shell (CVE-2021-44228, CVE-2021-45046, CVE-2021-45105, CVE-2021-44832)
  - **Action Required**: Upgrade to 2.17.1 or higher immediately

### 🟠 HIGH
- **commons-text 1.9** - Known vulnerabilities in versions < 1.10
  - **Action Required**: Upgrade to 1.10 or higher
  
- **mysql-connector-java 5.1.42** - Outdated with potential vulnerabilities
  - **Action Required**: Upgrade to 8.0.x series

## Next Steps

1. **Resolve MCP Server Issues**: Investigate why the Endor Labs MCP server is timing out
   - Check server connectivity
   - Verify API credentials and rate limits
   - Review server logs
   - Consider increasing timeout values

2. **Retry Scanning**: Once MCP server is available, use the provided tools:
   ```bash
   # Use the scan script to get dependency information
   ./scan-dependencies.sh
   
   # Then use Endor Labs MCP server with:
   # Tool: check_dependency_for_vulnerabilities
   # Ecosystem: maven
   # Dependency name: <groupId>:<artifactId>
   # Version: <version>
   ```

3. **Immediate Security Updates**: Address the critical vulnerabilities identified, especially Log4j

4. **Alternative Scanning**: Consider using alternative tools while MCP server issues are resolved:
   - OWASP Dependency Check
   - GitHub Dependabot
   - Snyk
   - Maven dependency plugin with vulnerability databases

## How to Use Endor Labs MCP Server (When Available)

For each dependency in the JSON file, call:

```
Tool: check_dependency_for_vulnerabilities
Parameters:
  - dependency_name: <groupId>:<artifactId>
  - ecosystem: maven
  - version: <version>
```

Example:
```
dependency_name: org.apache.commons:commons-text
ecosystem: maven
version: 1.9
```

## Automated Scanning

The `dependency-scan-data.json` file can be used to automate scanning when the MCP server is operational. Each dependency entry contains:
- Full Maven coordinates
- Ecosystem information
- Current version
- Risk assessment
- Known issues

This structured format enables integration with CI/CD pipelines and automated security scanning workflows.
