# Endor Labs Scan Documentation

## Overview
This document describes how to run security scans on this repository using the Endor Labs MCP server scan tool.

## Scan Types
The Endor Labs scanner supports three types of scans:
1. **Vulnerabilities**: Scans for security vulnerabilities in the code
2. **Secrets**: Scans for leaked secrets (API keys, passwords, tokens, etc.)
3. **Dependencies**: Scans dependencies for known security issues

## Running a Scan

### Full Scan (All Types)
To run a comprehensive scan that checks for vulnerabilities, secrets, and dependency issues:

```bash
# Scan all types
endor-labs-scan --path /home/runner/work/app-java-demo/app-java-demo --scan-types vulnerabilities,secrets,dependencies
```

### Individual Scans

#### Vulnerability Scan Only
```bash
endor-labs-scan --path /home/runner/work/app-java-demo/app-java-demo --scan-types vulnerabilities
```

#### Secrets Scan Only
```bash
endor-labs-scan --path /home/runner/work/app-java-demo/app-java-demo --scan-types secrets
```

#### Dependencies Scan Only
```bash
endor-labs-scan --path /home/runner/work/app-java-demo/app-java-demo --scan-types dependencies
```

## Repository Details
- **Path**: `/home/runner/work/app-java-demo/app-java-demo`
- **Type**: Java Maven Project
- **Build Tool**: Maven
- **JDK Version**: 1.8

## Dependencies Scanned
This project includes the following dependencies that will be scanned:
- javax.servlet:javax.servlet-api:3.1.0
- org.apache.commons:commons-text:1.9
- mysql:mysql-connector-java:5.1.42
- com.mchange:c3p0:0.9.5.2
- org.jboss.weld:weld-core:1.1.33.Final
- org.apache.logging.log4j:log4j-core:2.3
- And many more (see pom.xml)

## Expected Output
The scan will return:
- UUIDs of findings
- Key attributes of each finding
- Severity levels
- Remediation suggestions

## Notes
- Scans may take several minutes depending on repository size
- Results include both direct and transitive dependencies
- Some older dependencies may have known vulnerabilities that should be reviewed
