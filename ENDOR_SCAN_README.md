# Running Endor Labs Scans

This guide provides instructions on how to run security scans on the app-java-demo repository using the Endor Labs MCP server.

## Quick Start

### Using the Shell Script
The easiest way to run a scan is using the provided shell script:

```bash
# Run all scan types (vulnerabilities, secrets, and dependencies)
./run-endor-scan.sh --all

# Run specific scan types
./run-endor-scan.sh --vulnerabilities
./run-endor-scan.sh --secrets
./run-endor-scan.sh --dependencies

# Combine multiple scan types
./run-endor-scan.sh --vulnerabilities --dependencies
```

### Direct Tool Invocation
The Endor Labs MCP server provides a scan tool that can be invoked directly:

**Tool Name:** `endor-labs-scan`

**Parameters:**
- `path` (required): Fully qualified path to the code repository
- `scan_types` (required): Array of scan types to run

**Scan Types Available:**
1. `vulnerabilities` - Scans code for security vulnerabilities
2. `secrets` - Scans for leaked secrets (API keys, passwords, tokens)
3. `dependencies` - Scans dependencies for known security issues

## Example Invocations

### Scan for All Issues
```
Tool: endor-labs-scan
Parameters:
  path: /home/runner/work/app-java-demo/app-java-demo
  scan_types: ["vulnerabilities", "secrets", "dependencies"]
```

### Scan for Vulnerabilities Only
```
Tool: endor-labs-scan
Parameters:
  path: /home/runner/work/app-java-demo/app-java-demo
  scan_types: ["vulnerabilities"]
```

### Scan for Secrets Only
```
Tool: endor-labs-scan
Parameters:
  path: /home/runner/work/app-java-demo/app-java-demo
  scan_types: ["secrets"]
```

### Scan Dependencies Only
```
Tool: endor-labs-scan
Parameters:
  path: /home/runner/work/app-java-demo/app-java-demo
  scan_types: ["dependencies"]
```

## Understanding Scan Results

### Output Format
The scan tool returns:
- **UUIDs** of findings
- **Key attributes** of each finding including:
  - Severity level
  - Description
  - Location in code
  - Remediation suggestions

### Retrieving Detailed Findings
After the scan completes, you can retrieve detailed information about specific findings using their UUIDs with the `get_resource` tool:

```
Tool: endor-labs-get_resource
Parameters:
  resource_type: "Finding"
  uuid: "<finding-uuid-from-scan-results>"
```

## Known Dependencies to be Scanned

This Java Maven project includes several dependencies that will be analyzed:

### Core Dependencies
- `javax.servlet:javax.servlet-api:3.1.0`
- `org.apache.commons:commons-text:1.9`
- `mysql:mysql-connector-java:5.1.42`
- `com.mchange:c3p0:0.9.5.2`

### Framework Dependencies
- `org.jboss.weld:weld-core:1.1.33.Final`
- `org.apache.logging.log4j:log4j-core:2.3`

### Build & Test Dependencies
- `org.jboss.arquillian.*` (various versions)
- `org.mockito:mockito-core:2.28.2`
- `com.google.errorprone:error_prone_annotations:2.7.1`

See `pom.xml` for the complete list of dependencies.

## Scan Performance Notes

- **Duration**: Scans may take several minutes depending on:
  - Repository size
  - Number of files
  - Number of dependencies
  - Scan types selected

- **Resource Usage**: The scan analyzes:
  - Source code in `src/main/java/`
  - Dependencies defined in `pom.xml`
  - Configuration files
  - Web resources

## Security Considerations

### Expected Findings
Given the dependencies and Java code in this project, scans may identify:

1. **Dependency Vulnerabilities**: Several dependencies use older versions with known CVEs:
   - `mysql-connector-java:5.1.42` (older version, may have vulnerabilities)
   - `log4j-core:2.3` (very old version, may have critical vulnerabilities)
   - `commons-text:1.9` (may have known issues)

2. **Code Vulnerabilities**: The Java servlets may contain:
   - SQL injection risks
   - XSS vulnerabilities
   - Path traversal issues
   - Insecure deserialization

3. **Secrets**: May find:
   - Hardcoded credentials
   - API keys
   - Database connection strings

### Remediation Priority
When findings are returned, prioritize based on:
1. **Critical** severity findings first
2. **High** severity findings
3. **Medium** and **Low** severity findings

## Additional Tools

### Check Individual Dependencies
To check a specific dependency for vulnerabilities:

```
Tool: endor-labs-check_dependency_for_vulnerabilities
Parameters:
  ecosystem: "maven"
  dependency_name: "mysql:mysql-connector-java"
  version: "5.1.42"
```

### Get Vulnerability Details
To get details about a specific vulnerability:

```
Tool: endor-labs-get_endor_vulnerability
Parameters:
  vuln_id: "CVE-2021-44228" (example)
```

## Troubleshooting

### Scan Timeout
If the scan times out:
- Run individual scan types separately instead of all at once
- Check network connectivity
- Ensure the repository path is correct and accessible

### No Results
If no results are returned:
- Verify the path parameter is correct
- Ensure the repository has been cloned properly
- Check that scan_types array is properly formatted

## Files Included

- `run-endor-scan.sh` - Shell script for running scans
- `endor-scan.md` - Additional documentation
- `ENDOR_SCAN_README.md` - This file

## Support

For issues or questions about the Endor Labs scanner, refer to the Endor Labs documentation or contact support.
