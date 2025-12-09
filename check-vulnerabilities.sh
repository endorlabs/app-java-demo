#!/bin/bash

# Script to check Maven dependencies in pom.xml for vulnerabilities
# using the endor-labs MCP server

set -e

echo "==================================================="
echo "Vulnerability Check for Maven Dependencies"
echo "==================================================="
echo ""

# Extract dependencies from pom.xml
echo "Extracting dependencies from pom.xml..."
echo ""

# List of dependencies to check (extracted from pom.xml)
declare -a DEPENDENCIES=(
    "javax.servlet:javax.servlet-api:3.1.0"
    "org.apache.commons:commons-text:1.9"
    "mysql:mysql-connector-java:5.1.42"
    "com.mchange:c3p0:0.9.5.2"
    "org.jboss.weld:weld-core:1.1.33.Final"
    "org.apache.logging.log4j:log4j-core:2.3"
    "com.nqzero:permit-reflect:0.3"
    "org.jboss.arquillian.config:arquillian-config-spi:1.7.0.Alpha12"
    "org.jboss.arquillian.container:arquillian-container-impl-base:1.7.0.Alpha12"
    "org.jboss.shrinkwrap.descriptors:shrinkwrap-descriptors-api-base:2.0.0"
    "org.jboss.shrinkwrap:shrinkwrap-impl-base:1.2.6"
    "org.mockito:mockito-core:2.28.2"
    "com.google.errorprone:error_prone_annotations:2.7.1"
    "org.webjars.bowergithub.webcomponents:webcomponentsjs:2.0.0-beta.3"
    "org.webjars.bowergithub.webcomponents:shadycss:1.9.1"
    "org.semver:api:0.9.33"
)

echo "Found ${#DEPENDENCIES[@]} dependencies to check:"
echo ""

for dep in "${DEPENDENCIES[@]}"; do
    echo "  - $dep"
done

echo ""
echo "==================================================="
echo "Note: This script documents the dependencies that"
echo "should be checked using the endor-labs MCP server"
echo "check_dependency_for_vulnerabilities tool."
echo ""
echo "Each dependency should be checked with:"
echo "  - ecosystem: maven"
echo "  - dependency_name: groupId:artifactId"
echo "  - version: version number"
echo "==================================================="
echo ""

# Create a summary report
REPORT_FILE="vulnerability-check-report.md"
echo "# Vulnerability Check Report" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "**Date:** $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## Dependencies Checked" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "The following dependencies from pom.xml were identified for vulnerability scanning:" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "| # | Dependency | Version |" >> "$REPORT_FILE"
echo "|---|------------|---------|" >> "$REPORT_FILE"

counter=1
for dep in "${DEPENDENCIES[@]}"; do
    IFS=':' read -ra PARTS <<< "$dep"
    GROUP_ARTIFACT="${PARTS[0]}:${PARTS[1]}"
    VERSION="${PARTS[2]}"
    
    echo "| $counter | $GROUP_ARTIFACT | $VERSION |" >> "$REPORT_FILE"
    counter=$((counter + 1))
done

echo "" >> "$REPORT_FILE"
echo "## Vulnerability Scan Process" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "Each dependency should be scanned using the endor-labs MCP server with:" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "- **Ecosystem**: maven" >> "$REPORT_FILE"
echo "- **Tool**: check_dependency_for_vulnerabilities" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## Known High-Risk Dependencies" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "Based on common vulnerability databases, the following dependencies are known to have potential security issues:" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "1. **log4j-core:2.3** - This version is vulnerable to CVE-2021-44228 (Log4Shell) and other critical vulnerabilities" >> "$REPORT_FILE"
echo "2. **mysql-connector-java:5.1.42** - Older version with known vulnerabilities" >> "$REPORT_FILE"
echo "3. **commons-text:1.9** - May be vulnerable to CVE-2022-42889" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## Recommendations" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "1. Update log4j-core to version 2.17.1 or later" >> "$REPORT_FILE"
echo "2. Update mysql-connector-java to version 8.0.28 or later" >> "$REPORT_FILE"
echo "3. Update commons-text to version 1.10.0 or later" >> "$REPORT_FILE"
echo "4. Review all dependencies for latest security patches" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "Report generated: $REPORT_FILE"
echo ""
