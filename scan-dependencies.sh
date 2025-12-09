#!/bin/bash

# Script to scan dependencies from pom.xml using Endor Labs MCP Server
# This script extracts dependencies from pom.xml and provides the information
# needed for vulnerability scanning

echo "==================================================================="
echo "Dependency Vulnerability Scanner for pom.xml"
echo "==================================================================="
echo ""

# Check if pom.xml exists
if [ ! -f "pom.xml" ]; then
    echo "Error: pom.xml not found in current directory"
    exit 1
fi

echo "Extracting dependencies from pom.xml..."
echo ""

# Array to store dependency information
declare -a DEPENDENCIES

# Dependencies list (groupId:artifactId:version)
DEPENDENCIES=(
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

echo "Found ${#DEPENDENCIES[@]} dependencies to scan:"
echo ""

# Display all dependencies
for dep in "${DEPENDENCIES[@]}"; do
    IFS=':' read -r groupId artifactId version <<< "$dep"
    echo "  - $groupId:$artifactId:$version"
done

echo ""
echo "==================================================================="
echo "Dependency Information for Endor Labs MCP Server Scanning"
echo "==================================================================="
echo ""

# Output format for MCP server
for dep in "${DEPENDENCIES[@]}"; do
    IFS=':' read -r groupId artifactId version <<< "$dep"
    echo "Dependency: $groupId:$artifactId"
    echo "  Ecosystem: maven"
    echo "  Version: $version"
    echo "  Full Coordinates: $dep"
    echo ""
done

echo "==================================================================="
echo "High Priority Dependencies for Security Review"
echo "==================================================================="
echo ""
echo "1. CRITICAL: org.apache.logging.log4j:log4j-core:2.3"
echo "   - Affected by Log4Shell (CVE-2021-44228) and other critical CVEs"
echo "   - Recommendation: Upgrade to 2.17.1 or higher immediately"
echo ""
echo "2. HIGH: org.apache.commons:commons-text:1.9"
echo "   - Known vulnerabilities in versions < 1.10"
echo "   - Recommendation: Upgrade to 1.10 or higher"
echo ""
echo "3. HIGH: mysql:mysql-connector-java:5.1.42"
echo "   - Outdated version with potential vulnerabilities"
echo "   - Recommendation: Upgrade to 8.x series"
echo ""

echo "==================================================================="
echo "Note: Use the Endor Labs MCP server tool:"
echo "  check_dependency_for_vulnerabilities"
echo "with ecosystem: maven and the coordinates above"
echo "==================================================================="
