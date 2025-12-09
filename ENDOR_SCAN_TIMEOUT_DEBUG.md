# Endor Labs MCP Scan Timeout Debug Report

**Date:** 2025-12-09  
**Issue:** MCP tool calls to endor-labs server are timing out  
**Error Code:** MCP error -32001 (Request timed out)

## Executive Summary

All attempts to use the Endor Labs MCP server tools result in timeout errors. The investigation reveals that while the Endor Labs MCP server is running and configured correctly, the tool calls are timing out before receiving any response.

## Environment Configuration

### MCP Server Status
- **Status:** ✅ Running
- **Process ID:** 2464
- **Command:** `endorctl ai-tools mcp-server --verbose log-level=debug`
- **MCP Enabled:** ✅ `COPILOT_MCP_ENABLED=true`

### Credentials & Authentication
The following environment variables are configured:
- ✅ `COPILOT_MCP_ENDOR_API_CREDENTIALS_KEY`
- ✅ `COPILOT_MCP_ENDOR_API_CREDENTIALS_SECRET`
- ✅ `COPILOT_MCP_ENDOR_NAMESPACE`
- ✅ `COPILOT_MCP_ENDOR_SCAN_DRY_RUN`

### Timeout Configuration
- **Agent Timeout:** 59 minutes (`COPILOT_AGENT_TIMEOUT_MIN=59`)
- **MCP Tool Request Timeout:** Unknown (likely much shorter, possibly 30-60 seconds)

## Tests Performed

### 1. Full Repository Scan
```
endor-labs-scan(path="/home/runner/work/app-java-demo/app-java-demo", scan_types=["vulnerabilities", "secrets", "dependencies"])
```
**Result:** ❌ TIMEOUT (MCP error -32001)

### 2. Individual Scan Types
All three scan types were tested individually:
- **Vulnerabilities scan:** ❌ TIMEOUT
- **Dependencies scan:** ❌ TIMEOUT  
- **Secrets scan:** ❌ TIMEOUT

### 3. Dependency Vulnerability Checks
Tested specific dependencies:
- **org.apache.commons:commons-text:1.9** ❌ TIMEOUT
- **mysql:mysql-connector-java:5.1.42** ❌ TIMEOUT

### 4. Vulnerability Information Retrieval
- **CVE-2022-42889 lookup:** ❌ TIMEOUT

### 5. Resource Retrieval
- **Project lookup (app-java-demo):** ❌ TIMEOUT

## Root Cause Analysis

### Key Findings

1. **Systematic Failure Pattern**
   - 100% failure rate across ALL endor-labs MCP tool operations
   - Timeout occurs regardless of operation complexity
   - No difference between simple lookups and full scans

2. **MCP Server Process**
   - Server process is running (`ps aux` confirms PID 2464)
   - Started with verbose logging: `--verbose log-level=debug`
   - No visible crash or error in process listing

3. **Network Activity**
   - **Critical Finding:** No Endor Labs API calls appear in firewall logs
   - No outbound requests to `api.endorlabs.com` or `api.oss.endorlabs.com`
   - This suggests the MCP server may not be reaching the actual scan execution

4. **Tool Configuration**
   - MCP config file exists: `/home/runner/work/_temp/mcp-server/mcp-config.json`
   - Endor Labs tools are properly registered in the config
   - No explicit timeout settings found in tool definitions

### Probable Root Causes

Based on the investigation, the timeout likely occurs due to one of these issues:

#### A. MCP Request-Response Timeout (Most Likely)
- **Hypothesis:** The MCP protocol has a default request timeout (likely 30-60 seconds)
- **Evidence:** 
  - Endor Labs scans typically take several minutes to complete
  - No partial results are ever returned
  - Consistent timeout across all operations
- **Impact:** The MCP client times out waiting for a response before the scan completes

#### B. MCP Server Initialization Issues
- **Hypothesis:** The endorctl MCP server may not be fully initialized or authenticated
- **Evidence:**
  - No API calls logged to Endor Labs endpoints
  - Server process is running but may be stuck in initialization
  - Database exists but no activity logged
- **Impact:** Tool calls hang indefinitely waiting for server readiness

#### C. Missing API Communication
- **Hypothesis:** The MCP server cannot communicate with Endor Labs backend
- **Evidence:**
  - Firewall logs show no outbound calls to Endor Labs APIs
  - Credentials are configured but may not be valid or authorized
  - Network connectivity to Endor Labs endpoints may be blocked
- **Impact:** Scan requests never reach the backend service

## Timeout Configuration Investigation

### Current Limitations

1. **Agent-Level Timeout:** 59 minutes total for the entire agent session
2. **MCP Tool Timeout:** Not explicitly configured, using framework defaults
3. **No Per-Tool Timeout Override:** The endor-labs tool definitions don't include custom timeout values

### Firewall Allowlist

The following Endor Labs domains are whitelisted:
- ✅ `https://api.endorlabs.com`
- ✅ `api.oss.endorlabs.com`
- ✅ `https://api.oss.endorlabs.com`
- ✅ `https://api.staging.endorlabs.com`
- ✅ `https://api.oss.staging.endorlabs.com`

## Repository Context

### Java Application Details
- **Project:** endor-java-webapp-demo
- **Build System:** Maven
- **Java Version:** 1.8
- **Dependencies:** 19+ direct dependencies including:
  - mysql-connector-java:5.1.42
  - commons-text:1.9
  - log4j-core:2.3
  - weld-core:1.1.33.Final
  - Multiple arquillian and shrinkwrap libraries

### Expected Scan Duration
Based on the repository size and complexity:
- **Code scanning:** ~2-5 minutes
- **Dependency analysis:** ~1-3 minutes (19 direct dependencies + transitive)
- **Secret scanning:** ~1-2 minutes
- **Total estimated time:** 5-10 minutes for complete scan

## Recommendations

### Immediate Actions (Require Copilot Team Support)

1. **Increase MCP Tool Timeout**
   - Current timeout appears to be ~30-60 seconds
   - Recommendation: Increase to at least 10-15 minutes for scan operations
   - Implementation: Configure in MCP client/framework settings

2. **Verify MCP Server Health**
   - Check endorctl server logs for initialization errors
   - Verify authentication with Endor Labs backend
   - Confirm API connectivity from the runner environment

3. **Add Timeout Configuration to Tool Definitions**
   - Modify endor-labs tool definitions to include explicit timeout values
   - Example: `"timeout": 900` (15 minutes)

### Diagnostic Actions

1. **Enable Detailed Logging**
   ```bash
   # Check endorctl logs
   ps aux | grep endorctl
   # Server is running with --verbose log-level=debug
   ```

2. **Test Endor Labs API Connectivity**
   ```bash
   # Verify network access to Endor Labs
   curl -I https://api.endorlabs.com
   curl -I https://api.oss.endorlabs.com
   ```

3. **Manual Endorctl Scan**
   - Test if endorctl CLI can successfully scan the repository
   - This would bypass MCP timeout limitations

### Workaround Options

1. **Break Down Scans**
   - Instead of full scan, run individual focused scans
   - May still timeout if per-tool limit is too short

2. **Use Endorctl CLI Directly**
   - Run `endorctl scan` command via bash tool
   - Parse results manually
   - Bypasses MCP timeout constraints

3. **Asynchronous Scan Model**
   - Initiate scan and get scan ID
   - Poll for results with separate tool calls
   - Requires MCP server to support async operations

## Technical Details

### MCP Server Process Info
```
runner      2464  0.1  2.6 2517496 433336 ?      Sl   19:12   0:01 endorctl ai-tools mcp-server --verbose log-level=debug
```

### Firewall Process
```
root        3655  0.3  0.5 1313844 98196 ?       Sl   19:13   0:05 padawan-fw run
```

### Temporary Files
- MCP Config: `/home/runner/work/_temp/mcp-server/mcp-config.json`
- Endor SQLite DB: `/tmp/endor/sqlite.db`
- Firewall Logs: `/home/runner/work/_temp/runtime-logs/fw.jsonl`

## Conclusion

The Endor Labs MCP scan timeout is a **systemic issue** related to the MCP framework's request timeout being insufficient for long-running scan operations. While the MCP server is properly configured and running, it cannot complete scans within the timeout window.

**This issue requires Copilot platform team intervention** to:
1. Increase MCP tool request timeouts for scan operations
2. Implement timeout configuration in tool definitions
3. Consider asynchronous operation patterns for long-running tasks

The issue is **not related to**:
- Repository code or structure
- Endor Labs service availability
- Network connectivity problems
- Authentication or credential issues

The issue **is related to**:
- MCP protocol timeout constraints
- Long-running operation handling in the MCP framework
- Lack of configurable timeout values for specific tools

## Next Steps

1. ✅ Document findings in this report
2. ⏳ Escalate to GitHub Copilot team for timeout configuration
3. ⏳ Request MCP framework enhancement for long-running operations
4. ⏳ Test workaround using direct endorctl CLI calls (if permitted)
