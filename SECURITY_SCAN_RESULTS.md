# Security Scan Results

This document contains the security scan results for the app-java-demo repository.

## Scan Date
2025-12-04

## Scans Performed
- ✅ Endor Labs Dependency Vulnerability Scan
- ⚠️ CodeQL Security Analysis (requires code changes to trigger)

## Summary
The security scans identified **10 total vulnerabilities** across 3 dependencies.

## Vulnerabilities Found

### Critical Severity

#### 1. Apache Commons Text - Text4Shell (CVE-2022-42889)
- **Package**: org.apache.commons:commons-text
- **Current Version**: 1.9
- **Vulnerability**: GHSA-599f-7c49-w659
- **Severity**: CRITICAL (CVSS 9.8)
- **Description**: Arbitrary code execution through variable interpolation. The vulnerability allows remote code execution via JNDI lookups through script, dns, and url interpolators.
- **Recommended Version**: 1.14.0
- **Fix**: Upgrade to version 1.10.0 or later (1.14.0 is latest)

#### 2. Apache Log4j Core - Log4Shell (CVE-2021-44228)
- **Package**: org.apache.logging.log4j:log4j-core
- **Current Version**: 2.3
- **Vulnerabilities**: 7 total including:
  - GHSA-jfh8-c2jp-5v3q (Log4Shell - CVE-2021-44228) - CRITICAL (CVSS 10.0)
  - GHSA-vwqq-5vrc-xw9h (CVE-2020-9488) - LOW (CVSS 3.7)
  - And 5 additional vulnerabilities
- **Description**: Remote code execution via JNDI LDAP lookups in log messages. This is the famous Log4Shell vulnerability.
- **Recommended Version**: 2.25.2
- **Fix**: Upgrade to version 2.16.0 or later (2.25.2 is latest)

### Medium/Low Severity

#### 3. MySQL Connector Java
- **Package**: mysql:mysql-connector-java
- **Current Version**: 5.1.42
- **Vulnerabilities**: 2 total
  - GHSA-w6f2-8wx4-47r5
  - GHSA-jcq3-cprp-m333
- **Recommended Version**: 8.0.33
- **Fix**: Upgrade to version 8.0.33

## Dependency Analysis

| Dependency | Current Version | Latest Version | Vulnerabilities | Severity |
|------------|----------------|----------------|-----------------|----------|
| log4j-core | 2.3 | 2.25.2 | 7 | CRITICAL |
| commons-text | 1.9 | 1.14.0 | 1 | CRITICAL |
| mysql-connector-java | 5.1.42 | 8.0.33 | 2 | MEDIUM |

## Recommendations

1. **IMMEDIATE ACTION REQUIRED**: Upgrade log4j-core to 2.25.2 to fix Log4Shell and related vulnerabilities
2. **IMMEDIATE ACTION REQUIRED**: Upgrade commons-text to 1.14.0 to fix Text4Shell vulnerability
3. **HIGH PRIORITY**: Upgrade mysql-connector-java to 8.0.33

### Suggested pom.xml Changes

```xml
<!-- Partial pom.xml snippet - update these dependencies in your existing pom.xml -->
<dependencies>
    <!-- Update from 2.3 to 2.25.2 -->
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-core</artifactId>
        <version>2.25.2</version>
    </dependency>
    
    <!-- Update from 1.9 to 1.14.0 -->
    <dependency>
        <groupId>org.apache.commons</groupId>
        <artifactId>commons-text</artifactId>
        <version>1.14.0</version>
    </dependency>
    
    <!-- Update from 5.1.42 to 8.0.33 -->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.33</version>
    </dependency>
</dependencies>
```

## Additional Notes

- The application code contains several intentional security vulnerabilities for demonstration purposes (SQL injection, XXE, command injection, etc.)
- These code-level vulnerabilities were observed during code review but not flagged by CodeQL as it requires code changes to trigger analysis
- For a production environment, both dependency vulnerabilities AND code-level vulnerabilities should be addressed

## Tools Used

- **Endor Labs**: Used for dependency vulnerability scanning via the Endor Labs security platform
- **GitHub Advisory Database**: Cross-referenced for vulnerability information
- **CodeQL**: GitHub's semantic code analysis engine (requires code changes to perform analysis)

## Next Steps

1. Update dependencies to recommended versions
2. Test application functionality after updates
3. Perform CodeQL scan after making code changes
4. Address code-level security issues in servlets (SQL injection, command injection, XXE, etc.)
