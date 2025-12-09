#!/usr/bin/env python3
"""
Script to check Maven dependencies for vulnerabilities using endor-labs MCP server.
This script parses pom.xml and checks each dependency for known vulnerabilities.
"""

import xml.etree.ElementTree as ET
import sys
import os

def parse_pom_dependencies(pom_file):
    """Parse pom.xml and extract all dependencies."""
    try:
        tree = ET.parse(pom_file)
        root = tree.getroot()
        
        # Handle XML namespace
        namespace = {'maven': 'http://maven.apache.org/POM/4.0.0'}
        
        dependencies = []
        for dependency in root.findall('.//maven:dependency', namespace):
            group_id = dependency.find('maven:groupId', namespace)
            artifact_id = dependency.find('maven:artifactId', namespace)
            version = dependency.find('maven:version', namespace)
            
            if group_id is not None and artifact_id is not None and version is not None:
                dependencies.append({
                    'groupId': group_id.text,
                    'artifactId': artifact_id.text,
                    'version': version.text,
                    'name': f"{group_id.text}:{artifact_id.text}",
                    'ecosystem': 'maven'
                })
        
        return dependencies
    except Exception as e:
        print(f"Error parsing pom.xml: {e}")
        return []

def main():
    """Main function to check dependencies."""
    pom_file = 'pom.xml'
    
    if not os.path.exists(pom_file):
        print(f"Error: {pom_file} not found!")
        sys.exit(1)
    
    print("=" * 60)
    print("Maven Dependency Vulnerability Check")
    print("=" * 60)
    print()
    
    dependencies = parse_pom_dependencies(pom_file)
    
    if not dependencies:
        print("No dependencies found in pom.xml")
        sys.exit(1)
    
    print(f"Found {len(dependencies)} dependencies to check:")
    print()
    
    for dep in dependencies:
        print(f"  - {dep['name']}:{dep['version']}")
    
    print()
    print("=" * 60)
    print("Dependencies to Check with endor-labs MCP Server:")
    print("=" * 60)
    print()
    
    for dep in dependencies:
        print(f"Dependency: {dep['name']}")
        print(f"  Ecosystem: {dep['ecosystem']}")
        print(f"  Version: {dep['version']}")
        print(f"  Command: check_dependency_for_vulnerabilities(")
        print(f"    dependency_name='{dep['name']}',")
        print(f"    ecosystem='{dep['ecosystem']}',")
        print(f"    version='{dep['version']}'")
        print(f"  )")
        print()
    
    # Generate a JSON output file for automation
    import json
    output_file = 'dependencies-to-check.json'
    with open(output_file, 'w') as f:
        json.dump(dependencies, f, indent=2)
    
    print(f"Dependencies exported to: {output_file}")
    print()
    
    # Generate detailed report
    with open('dependency-list.md', 'w') as f:
        f.write("# Maven Dependencies for Vulnerability Scanning\n\n")
        f.write(f"**Total Dependencies:** {len(dependencies)}\n\n")
        f.write("## Dependencies List\n\n")
        f.write("| # | Group ID | Artifact ID | Version |\n")
        f.write("|---|----------|-------------|----------|\n")
        
        for i, dep in enumerate(dependencies, 1):
            f.write(f"| {i} | {dep['groupId']} | {dep['artifactId']} | {dep['version']} |\n")
        
        f.write("\n## Usage with endor-labs MCP Server\n\n")
        f.write("Each dependency should be checked using:\n\n")
        f.write("```\n")
        f.write("check_dependency_for_vulnerabilities(\n")
        f.write("  dependency_name='groupId:artifactId',\n")
        f.write("  ecosystem='maven',\n")
        f.write("  version='x.y.z'\n")
        f.write(")\n")
        f.write("```\n")
    
    print("Detailed report generated: dependency-list.md")
    print()

if __name__ == '__main__':
    main()
