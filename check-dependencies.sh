#!/bin/bash

# Script to check Maven dependencies for vulnerabilities
# This script documents the dependencies that should be checked using Endor Labs

echo "========================================"
echo "Maven Dependency Vulnerability Check"
echo "========================================"
echo ""

# Extract dependencies from pom.xml
echo "Dependencies to check:"
echo ""

# List of dependencies with their coordinates and versions
dependencies=(
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

# Display each dependency
counter=1
for dep in "${dependencies[@]}"; do
    echo "$counter. $dep"
    counter=$((counter + 1))
done

echo ""
echo "Total dependencies: ${#dependencies[@]}"
echo ""
echo "NOTE: Use Endor Labs MCP server check_dependency_for_vulnerabilities tool"
echo "      to check each dependency for known security vulnerabilities."
echo ""
echo "Critical dependencies to prioritize:"
echo "  - log4j-core:2.3 (known Log4Shell vulnerabilities)"
echo "  - commons-text:1.9 (known Text4Shell vulnerability)"
echo "  - mysql-connector-java:5.1.42 (outdated version)"
echo ""
echo "========================================"
