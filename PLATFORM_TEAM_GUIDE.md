# Platform Team Guide: Modifying MCP Timeout Settings

## Overview

This guide provides step-by-step instructions for the GitHub Copilot Platform Team to modify MCP timeout settings and resolve the Endor Labs scan timeout issue.

## Problem Context

- **Current MCP Timeout:** ~30-60 seconds
- **Required Timeout:** 15+ minutes (900+ seconds)
- **Affected Tools:** Endor Labs scan tools (and any other long-running MCP tools)
- **Error:** MCP error -32001 (Request timed out)

## Solution Options

### Option 1: Global MCP Timeout Increase (Recommended Quick Fix)

#### Location
The MCP timeout is likely configured in the MCP client/framework code that manages tool invocations.

#### Potential Configuration Files
Based on the investigation, the timeout configuration is likely in one of these locations:

1. **MCP Client Configuration**
   - File: `/home/runner/work/_temp/******-action-main/mcp/dist/index.js` (obfuscated build)
   - Source: MCP action main repository
   - Configuration: Request timeout for tool calls

2. **Environment Variables**
   - Add a new environment variable: `MCP_TOOL_REQUEST_TIMEOUT_MS`
   - Default: 60000 (60 seconds)
   - Recommended: 900000 (15 minutes)

3. **Runtime Configuration**
   - MCP server configuration file: `/home/runner/work/_temp/mcp-server/mcp-config.json`
   - Currently does not include timeout settings
   - Could be extended to support per-tool timeouts

#### Steps to Implement

**Step 1: Identify Timeout Configuration Location**
```bash
# In the MCP action repository, search for timeout configuration
grep -r "timeout" --include="*.ts" --include="*.js" mcp/src/
grep -r "60000\|30000" --include="*.ts" --include="*.js" mcp/src/
```

**Step 2: Update Timeout Value**
```typescript
// Example location (actual code may differ)
// File: mcp/src/mcp-client.ts

const MCP_TOOL_REQUEST_TIMEOUT = 
  parseInt(process.env.MCP_TOOL_REQUEST_TIMEOUT_MS || '900000'); // 15 minutes

// In the request handler:
async function callMCPTool(tool: string, params: any) {
  const timeout = MCP_TOOL_REQUEST_TIMEOUT;
  
  return await Promise.race([
    mcpServer.callTool(tool, params),
    new Promise((_, reject) => 
      setTimeout(() => reject(new Error('MCP error -32001: Request timed out')), timeout)
    )
  ]);
}
```

**Step 3: Set Environment Variable**
```yaml
# In GitHub Actions workflow or runtime configuration
env:
  MCP_TOOL_REQUEST_TIMEOUT_MS: "900000"  # 15 minutes
```

**Step 4: Deploy and Test**
```bash
# Test with Endor Labs scan
endor-labs-scan(path="/test/repo", scan_types=["vulnerabilities"])
```

### Option 2: Per-Tool Timeout Configuration (Better Long-term)

#### Extend MCP Config Schema

**Step 1: Update Tool Definition Schema**
```typescript
// File: mcp/src/types.ts or similar

interface MCPToolDefinition {
  name: string;
  description: string;
  input_schema: JSONSchema;
  timeout?: number;  // ADD THIS: Optional timeout in seconds
  // ... other fields
}
```

**Step 2: Update Config File Generation**
```typescript
// File: mcp/src/config-generator.ts or similar

function generateToolConfig(tool: MCPTool): MCPToolDefinition {
  return {
    name: tool.name,
    description: tool.description,
    input_schema: tool.input_schema,
    timeout: tool.timeout || DEFAULT_TIMEOUT,  // Use tool-specific or default
    // ... other fields
  };
}
```

**Step 3: Update Endor Labs MCP Server**
```bash
# In endorctl repository
# Update tool definitions to include timeout

# File: pkg/ai/tools/implementations/scantool/scantool.go (or similar)

func (s *ScanTool) GetToolDefinition() ToolDefinition {
  return ToolDefinition{
    Name: "scan",
    Description: "Scan a project for security issues...",
    InputSchema: schema,
    Timeout: 900,  // 15 minutes for scan operations
  }
}
```

**Step 4: Update MCP Config**
The config file `/home/runner/work/_temp/mcp-server/mcp-config.json` should include:
```json
{
  "endor-labs/scan": {
    "name": "endor-labs-scan",
    "namespacedName": "endor-labs/scan",
    "title": "endor-labs/scan",
    "description": "...",
    "timeout": 900,
    "input_schema": { ... }
  }
}
```

**Step 5: Use Timeout in MCP Client**
```typescript
// File: mcp/src/mcp-client.ts

async function callMCPTool(toolName: string, params: any) {
  const toolConfig = getToolConfig(toolName);
  const timeout = (toolConfig.timeout || DEFAULT_TIMEOUT) * 1000; // Convert to ms
  
  return await Promise.race([
    mcpServer.callTool(toolName, params),
    new Promise((_, reject) => 
      setTimeout(() => reject(new Error('MCP error -32001: Request timed out')), timeout)
    )
  ]);
}
```

### Option 3: Async Operation Pattern (Future Enhancement)

This requires more significant changes to the Endor Labs MCP server to support asynchronous operations.

#### High-Level Design

**New Tools to Add:**
1. `endor-labs-scan-start` - Initiates scan, returns scan_id
2. `endor-labs-scan-status` - Checks status of running scan
3. `endor-labs-scan-results` - Retrieves results when complete
4. `endor-labs-scan-cancel` - Cancels a running scan

**Implementation Steps:**
1. Modify endorctl MCP server to support async operations
2. Store scan state in SQLite database (`/tmp/endor/sqlite.db`)
3. Return scan IDs immediately (within timeout)
4. Allow polling for completion
5. Cache results for retrieval

This is a larger effort and recommended for future improvement.

## Testing After Changes

### Test 1: Simple Scan
```javascript
// Should complete within 15 minutes
endor-labs-scan({
  path: "/home/runner/work/app-java-demo/app-java-demo",
  scan_types: ["dependencies"]
})
```

### Test 2: Full Scan
```javascript
// Should complete within 15 minutes
endor-labs-scan({
  path: "/home/runner/work/app-java-demo/app-java-demo",
  scan_types: ["vulnerabilities", "secrets", "dependencies"]
})
```

### Test 3: Verify No Timeout
```bash
# Monitor logs for timeout errors
tail -f /home/runner/work/_temp/runtime-logs/output.log | grep -i timeout
```

## Monitoring and Validation

### Success Criteria
- ✅ Scans complete without MCP error -32001
- ✅ Results are returned within expected timeframe (5-10 minutes)
- ✅ No API timeout errors in logs
- ✅ Findings are properly returned to the agent

### Metrics to Track
- **Scan Duration:** Average time for different scan types
- **Timeout Rate:** Percentage of scans that timeout
- **Success Rate:** Percentage of scans that complete successfully

## Rollback Plan

If issues occur after timeout increase:

**Step 1: Revert Configuration**
```bash
# Restore previous timeout value
# Or remove environment variable
unset MCP_TOOL_REQUEST_TIMEOUT_MS
```

**Step 2: Redeploy Previous Version**
```bash
# Revert to previous MCP action version
git checkout <previous-commit>
```

**Step 3: Verify Rollback**
```bash
# Test that other tools still work
# Check logs for errors
```

## Additional Considerations

### Impact on Other Tools
- Increasing global timeout affects all MCP tools
- Monitor for unintended side effects
- Consider per-tool configuration if issues arise

### Performance Impact
- Longer timeouts don't affect successful operations
- Only impacts error cases (actual timeouts)
- No performance penalty for fast operations

### Security Considerations
- Longer timeouts increase resource usage for failed operations
- Monitor for denial-of-service scenarios
- Consider rate limiting for scan operations

## Contact and Support

**For Implementation Questions:**
- Review MCP framework documentation
- Check MCP action repository for timeout configuration
- Test in staging environment before production

**For Endor Labs Specific Questions:**
- Endor Labs MCP server repository
- Endorctl CLI documentation
- Endor Labs support team

## References

- **Investigation Report:** `ENDOR_SCAN_TIMEOUT_DEBUG.md`
- **Quick Reference:** `README_TIMEOUT_ISSUE.md`
- **Summary:** `TIMEOUT_INVESTIGATION_SUMMARY.md`
- **MCP Config:** `/home/runner/work/_temp/mcp-server/mcp-config.json`
- **MCP Server Process:** `endorctl ai-tools mcp-server --verbose log-level=debug`

## Estimated Implementation Time

| Solution | Effort | Risk | Timeline |
|----------|--------|------|----------|
| Option 1: Global Timeout | Low | Low | 1-2 days |
| Option 2: Per-Tool Config | Medium | Medium | 1 week |
| Option 3: Async Pattern | High | High | 3-4 weeks |

## Next Steps

1. ✅ Review this guide
2. ⏳ Identify timeout configuration location in MCP action code
3. ⏳ Implement Option 1 (global timeout increase)
4. ⏳ Test with Endor Labs scans
5. ⏳ Deploy to production
6. ⏳ Monitor for issues
7. ⏳ Consider Option 2 for better long-term solution

---

**Document Version:** 1.0  
**Last Updated:** 2025-12-09  
**Author:** GitHub Copilot Agent  
**Status:** Ready for Implementation
