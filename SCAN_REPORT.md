# Vulnerability Scan Report

## Scan Request
Date: December 10, 2025
Repository: endorlabs/app-java-demo
Path: /home/runner/work/app-java-demo/app-java-demo

## Scan Tool Configuration
- **Tool**: Endor Labs MCP Server (`endor-labs-scan`)
- **endorctl Version**: v1.7.711
- **MCP Server Process**: Running (PID 2372)
- **MCP Server Command**: `endorctl ai-tools mcp-server`

## Scan Types Requested
- Vulnerabilities in code
- Dependencies with security issues
- Leaked secrets

## Scan Status
⚠️ **TIMEOUT ERROR**

Multiple scan attempts failed with MCP timeout errors:
- Full scan (vulnerabilities, secrets, dependencies): Request timed out
- Dependencies only scan: Request timed out  
- Secrets only scan: Request timed out

## MCP Server Status
The endorctl MCP server is running correctly:
- **Process ID**: 2372
- **Command**: `endorctl ai-tools mcp-server`
- **Configuration file**: `/home/runner/work/_temp/mcp-server/mcp-config.json`
- **Network Ports**: Listening on 127.0.0.1:39075 and 127.0.0.1:30000
- **Server logs**: Service is active and responding to requests

## Issue Analysis
The timeout errors suggest that:
1. **MCP Request Timeout**: The scan operation takes longer than the MCP request timeout allows (likely 30-60 seconds)
2. **Repository Complexity**: The Java Maven project with 40+ source files and multiple third-party dependencies requires extended scan time
3. **Scan Operations**: All three scan types (vulnerabilities, secrets, dependencies) timeout individually, indicating each requires significant processing time
4. **Network/API**: Possible latency when communicating with Endor Labs API endpoints

## Recommendations
1. Increase the MCP request timeout threshold
2. Run the scan directly using `endorctl scan` command with appropriate flags
3. Consider scanning specific components separately
4. Check Endor Labs API connectivity and response times

## Repository Information
- **Language**: Java (Maven project)
- **Build Tool**: Apache Maven
- **Dependencies**: Multiple third-party libraries including:
  - javax.servlet-api 3.1.0
  - commons-text 1.9
  - mysql-connector-java 5.1.42
  - log4j-core 2.3
  - And others (see pom.xml)

## Next Steps
To complete the vulnerability scan, consider:
1. Running endorctl directly from command line
2. Adjusting MCP server timeout settings
3. Splitting the scan into smaller components
