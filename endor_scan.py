#!/usr/bin/env python3
"""
Endor Labs Scanner Integration Script

This script demonstrates how to use the Endor Labs MCP server scan tool
to perform security scans on the app-java-demo repository.
"""

import json
import sys
from typing import List, Dict, Any


class EndorLabsScanner:
    """
    Wrapper class for the Endor Labs MCP server scan tool.
    """
    
    def __init__(self, repository_path: str):
        """
        Initialize the scanner with the repository path.
        
        Args:
            repository_path: Absolute path to the repository to scan
        """
        self.repository_path = repository_path
        self.scan_results = {}
    
    def scan(self, scan_types: List[str]) -> Dict[str, Any]:
        """
        Execute a scan with the specified scan types.
        
        Args:
            scan_types: List of scan types to execute.
                       Valid values: 'vulnerabilities', 'secrets', 'dependencies'
        
        Returns:
            Dictionary containing scan results with UUIDs and findings
        """
        print(f"Initiating Endor Labs scan...")
        print(f"Repository: {self.repository_path}")
        print(f"Scan types: {', '.join(scan_types)}")
        print("-" * 60)
        
        # This would invoke the actual MCP server tool:
        # endor-labs-scan with parameters:
        #   - path: self.repository_path
        #   - scan_types: scan_types
        
        scan_config = {
            "tool": "endor-labs-scan",
            "parameters": {
                "path": self.repository_path,
                "scan_types": scan_types
            }
        }
        
        print("\nScan Configuration:")
        print(json.dumps(scan_config, indent=2))
        
        # Note: The actual execution would be done via the MCP server
        # For demonstration purposes, we're showing the expected configuration
        
        return scan_config
    
    def scan_all(self) -> Dict[str, Any]:
        """
        Execute all available scan types.
        
        Returns:
            Dictionary containing scan results
        """
        return self.scan(['vulnerabilities', 'secrets', 'dependencies'])
    
    def scan_vulnerabilities(self) -> Dict[str, Any]:
        """Scan for code vulnerabilities only."""
        return self.scan(['vulnerabilities'])
    
    def scan_secrets(self) -> Dict[str, Any]:
        """Scan for leaked secrets only."""
        return self.scan(['secrets'])
    
    def scan_dependencies(self) -> Dict[str, Any]:
        """Scan dependencies for security issues only."""
        return self.scan(['dependencies'])
    
    def format_results(self, results: Dict[str, Any]) -> str:
        """
        Format scan results for display.
        
        Args:
            results: Raw scan results
            
        Returns:
            Formatted string representation
        """
        output = []
        output.append("\n" + "=" * 60)
        output.append("SCAN RESULTS SUMMARY")
        output.append("=" * 60)
        
        if 'findings' in results:
            findings = results['findings']
            output.append(f"\nTotal Findings: {len(findings)}")
            
            for finding in findings:
                output.append(f"\n  UUID: {finding.get('uuid', 'N/A')}")
                output.append(f"  Type: {finding.get('type', 'N/A')}")
                output.append(f"  Severity: {finding.get('severity', 'N/A')}")
                output.append(f"  Description: {finding.get('description', 'N/A')}")
        else:
            output.append("\nNote: This is a configuration demonstration.")
            output.append("Actual results would contain finding UUIDs and details.")
        
        output.append("\n" + "=" * 60)
        return "\n".join(output)


def main():
    """Main execution function."""
    # Repository path
    repo_path = "/home/runner/work/app-java-demo/app-java-demo"
    
    # Create scanner instance
    scanner = EndorLabsScanner(repo_path)
    
    # Determine scan type from command line arguments
    if len(sys.argv) > 1:
        scan_type = sys.argv[1].lower()
        
        if scan_type == "--vulnerabilities":
            results = scanner.scan_vulnerabilities()
        elif scan_type == "--secrets":
            results = scanner.scan_secrets()
        elif scan_type == "--dependencies":
            results = scanner.scan_dependencies()
        elif scan_type == "--all":
            results = scanner.scan_all()
        elif scan_type == "--help":
            print_usage()
            return 0
        else:
            print(f"Error: Unknown option '{scan_type}'")
            print_usage()
            return 1
    else:
        # Default: run all scans
        results = scanner.scan_all()
    
    # Display results
    print(scanner.format_results(results))
    
    print("\nNOTE: This script demonstrates the Endor Labs scan configuration.")
    print("The actual scan is executed via the Endor Labs MCP server tool.")
    print("\nTo retrieve detailed findings, use the following tools:")
    print("  - endor-labs-get_resource (to get finding details by UUID)")
    print("  - endor-labs-get_endor_vulnerability (to get vulnerability details)")
    print("  - endor-labs-check_dependency_for_vulnerabilities (to check specific dependencies)")
    
    return 0


def print_usage():
    """Print usage information."""
    print("Usage: python3 endor_scan.py [OPTIONS]")
    print()
    print("Options:")
    print("  --all               Run all scan types (default)")
    print("  --vulnerabilities   Scan for code vulnerabilities only")
    print("  --secrets          Scan for leaked secrets only")
    print("  --dependencies     Scan dependencies only")
    print("  --help             Display this help message")
    print()
    print("Examples:")
    print("  python3 endor_scan.py")
    print("  python3 endor_scan.py --all")
    print("  python3 endor_scan.py --vulnerabilities")
    print("  python3 endor_scan.py --secrets")


if __name__ == "__main__":
    sys.exit(main())
