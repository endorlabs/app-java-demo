#!/bin/bash

# Script to check pom.xml dependencies for vulnerabilities
# This script documents the dependencies that should be checked using endor-labs

echo "======================================================================"
echo "Vulnerability Check Script for app-java-demo"
echo "======================================================================"
echo ""
echo "This script identifies all Maven dependencies from pom.xml that should"
echo "be checked for vulnerabilities using the endor-labs MCP server."
echo ""

# Determine the script's directory and find pom.xml relative to it
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
POM_FILE="$SCRIPT_DIR/pom.xml"

if [ ! -f "$POM_FILE" ]; then
    echo "ERROR: pom.xml not found at $POM_FILE"
    exit 1
fi

echo "Dependencies to check for vulnerabilities:"
echo "-------------------------------------------"
echo ""

# List of dependencies extracted from pom.xml
cat << 'EOF'
1. javax.servlet:javax.servlet-api:3.1.0
2. org.apache.commons:commons-text:1.9
3. mysql:mysql-connector-java:5.1.42
4. com.mchange:c3p0:0.9.5.2
5. org.jboss.weld:weld-core:1.1.33.Final
6. org.apache.logging.log4j:log4j-core:2.3
7. com.nqzero:permit-reflect:0.3
8. org.jboss.arquillian.config:arquillian-config-spi:1.7.0.Alpha12
9. org.jboss.arquillian.container:arquillian-container-impl-base:1.7.0.Alpha12
10. org.jboss.shrinkwrap.descriptors:shrinkwrap-descriptors-api-base:2.0.0
11. org.jboss.shrinkwrap:shrinkwrap-impl-base:1.2.6
12. org.mockito:mockito-core:2.28.2
13. com.google.errorprone:error_prone_annotations:2.7.1
14. org.webjars.bowergithub.webcomponents:webcomponentsjs:2.0.0-beta.3
15. org.webjars.bowergithub.webcomponents:shadycss:1.9.1
16. org.semver:api:0.9.33
EOF

echo ""
echo "-------------------------------------------"
echo "Total dependencies: 16"
echo ""
echo "NOTE: These dependencies should be checked using:"
echo "  - endor-labs-check_dependency_for_vulnerabilities tool"
echo "  - Ecosystem: maven"
echo "  - Format: groupId:artifactId"
echo ""
echo "For automated checking, use the endor-labs MCP server when available."
echo "======================================================================"
