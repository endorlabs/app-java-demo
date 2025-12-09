# Endor Labs Vulnerability Scan Report

## Scan Details

- **Repository**: endorlabs/app-java-demo
- **Scan Date**: 2025-12-09
- **Scan Tool**: Endor Labs MCP / endorctl CLI
- **Scan Types**: Vulnerabilities, Secrets, Dependencies

## Scan Execution

### Scan Attempts

Multiple attempts were made to run the scan using:

1. **Endor Labs MCP server tools** (`endor-labs-scan`)
   - Status: ❌ Request timed out
   - Attempted scan types: vulnerabilities, secrets, dependencies
   - Note: MCP server experiencing timeout issues

2. **endorctl CLI**
   - Status: ⚠️ Requires authentication credentials
   - Available at: `/usr/local/bin/endorctl`
   - Requires: API key, API secret, and namespace

### Scan Script

A scan script has been created at `run-endor-scan.sh` that can be executed when authentication credentials are available:

```bash
./run-endor-scan.sh
```

Or using endorctl directly:

```bash
endorctl scan \
    --path /home/runner/work/app-java-demo/app-java-demo \
    --namespace release-test \
    --dependencies \
    --secrets \
    --output-type summary
```

## Dependencies Scanned

The following dependencies from `pom.xml` are included in the scan:

### Potentially Vulnerable Dependencies

1. **org.apache.commons:commons-text:1.9**
   - Ecosystem: maven
   - Known issues: May have vulnerabilities in older versions

2. **mysql:mysql-connector-java:5.1.42**
   - Ecosystem: maven
   - Known issues: Older version, check for CVEs

3. **org.apache.logging.log4j:log4j-core:2.3**
   - Ecosystem: maven
   - **CRITICAL**: Very old version, likely affected by Log4Shell (CVE-2021-44228, CVE-2021-45046, CVE-2021-45105, CVE-2021-44832)
   - Recommendation: Upgrade to 2.17.1 or later

4. **org.jboss.weld:weld-core:1.1.33.Final**
   - Ecosystem: maven
   - Very old version from 2014

5. **com.mchange:c3p0:0.9.5.2**
   - Ecosystem: maven
   - Check for known vulnerabilities

6. **org.mockito:mockito-core:2.28.2**
   - Ecosystem: maven
   - Relatively old version

## Recommendations

1. **Immediate Action**: Upgrade log4j-core from 2.3 to 2.17.1 or later to address Log4Shell vulnerabilities
2. **Review**: Check all other dependencies for known CVEs
3. **Regular Scans**: Set up automated scanning in CI/CD pipeline
4. **Secrets**: Scan git history for accidentally committed secrets
5. **SAST**: Consider enabling SAST scanning for code vulnerabilities

## Next Steps

1. Run the scan with proper authentication credentials
2. Review detailed findings
3. Create tickets to address vulnerabilities
4. Implement dependency updates
5. Set up continuous vulnerability monitoring
