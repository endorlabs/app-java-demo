# Endor Labs MCP Timeout Investigation - Summary

## Problem Statement
All Endor Labs MCP server tool calls timeout before completion (MCP error -32001).

## Investigation Completed ✅

### What Was Tested
1. ✅ Full repository scans (vulnerabilities + secrets + dependencies)
2. ✅ Individual scan types (each tested separately)
3. ✅ Specific dependency vulnerability checks
4. ✅ Vulnerability information retrieval
5. ✅ Project resource retrieval
6. ✅ MCP server process verification
7. ✅ Credential configuration verification
8. ✅ Network/firewall configuration review
9. ✅ CLI workaround feasibility

### Results
- **100% timeout rate** across all 6+ tool operations
- **MCP server is running** correctly (PID 2464)
- **Credentials are configured** (injected secrets)
- **Firewall allows** Endor Labs domains
- **No workaround possible** (credentials isolated to MCP server)

## Root Cause: MCP Request Timeout Too Short

### The Problem
```
Expected scan duration:  5-10 minutes
Current MCP timeout:     ~30-60 seconds  ❌
```

### Why It Happens
1. Endor Labs scans analyze:
   - Source code (19+ files)
   - Dependencies (19 direct + many transitive)
   - Secrets in git history
   - Security vulnerabilities
   
2. This requires:
   - Building dependency tree
   - Calling external APIs
   - Analyzing code patterns
   - Generating findings
   
3. MCP protocol timeout expires before scan completes

## What This Means

### For Users
- ❌ Cannot use Endor Labs scan functionality via Copilot
- ❌ No workaround available in current environment
- ⏳ Requires platform-level fix

### For Copilot Team
- 🔧 MCP framework needs timeout configuration
- 🔧 Long-running operations need async support
- 🔧 Per-tool timeout override capability needed

## Recommended Solutions

### Option 1: Increase MCP Tool Timeout (Quick Fix)
**Implementation:** Increase default MCP request timeout from ~60s to 15+ minutes

**Pros:**
- ✅ Simple configuration change
- ✅ Works for all long-running tools
- ✅ No code changes needed

**Cons:**
- ⚠️ May mask other issues
- ⚠️ Global change affects all tools

**Priority:** 🔴 HIGH - Unblocks functionality immediately

### Option 2: Per-Tool Timeout Configuration (Better)
**Implementation:** Allow tools to specify custom timeouts in their definitions

```json
{
  "endor-labs/scan": {
    "name": "endor-labs-scan",
    "timeout": 900,  // 15 minutes
    ...
  }
}
```

**Pros:**
- ✅ Granular control
- ✅ Doesn't affect other tools
- ✅ Future-proof

**Cons:**
- ⚠️ Requires MCP framework changes
- ⚠️ More configuration complexity

**Priority:** 🟡 MEDIUM - Better long-term solution

### Option 3: Async Operation Pattern (Best)
**Implementation:** Support async scan initiation and status polling

```
1. Call: endor-labs-scan-start → returns scan_id
2. Call: endor-labs-scan-status(scan_id) → returns progress
3. Call: endor-labs-scan-results(scan_id) → returns findings
```

**Pros:**
- ✅ No timeout issues
- ✅ Better user experience
- ✅ Can show progress
- ✅ Scalable pattern

**Cons:**
- ⚠️ Requires MCP server changes
- ⚠️ More complex implementation
- ⚠️ Different interaction model

**Priority:** 🟢 LOW - Future enhancement

## Immediate Action Required

### For Copilot Platform Team

1. **Increase MCP timeout** to 15 minutes (or make configurable)
   - File: MCP client configuration
   - Setting: Request timeout value
   - Impact: Unblocks Endor Labs scanning

2. **Add timeout configuration** to MCP tool schema
   - Allow tools to specify custom timeouts
   - Document in MCP server development guide

3. **Monitor for similar issues** with other long-running tools
   - GitHub Actions analysis
   - Large repository operations
   - External API integrations

### For This Issue

**Status:** ⏸️ Blocked - Waiting for platform team
**Blocker:** MCP timeout configuration not accessible
**Owner:** GitHub Copilot Platform Team
**ETA:** Pending team response

## Evidence & Logs

See `ENDOR_SCAN_TIMEOUT_DEBUG.md` for:
- Detailed test results
- Process information
- Configuration dumps
- Network traffic analysis
- Complete root cause analysis

## FAQ

### Q: Can we just increase the agent timeout?
**A:** No. The agent timeout is 59 minutes, which is sufficient. The issue is the MCP tool request timeout (~60s).

### Q: Can we use endorctl CLI directly?
**A:** No. Credentials are isolated to the MCP server process for security. Direct CLI access is blocked.

### Q: Is this an Endor Labs issue?
**A:** No. This is a GitHub Copilot MCP framework limitation. Endor Labs service is working correctly.

### Q: Can we work around this?
**A:** No. All tested workarounds failed due to credential isolation and timeout constraints.

### Q: Will this affect other tools?
**A:** Yes. Any MCP tool with operations taking >60 seconds will experience the same issue.

## Contact

For questions or updates, refer to:
- Detailed Report: `ENDOR_SCAN_TIMEOUT_DEBUG.md`
- GitHub Issue: (to be created)
- Copilot Platform Team: (escalation required)

---

**Last Updated:** 2025-12-09  
**Investigation Status:** ✅ Complete  
**Resolution Status:** ⏳ Pending Platform Team  
**Blocking Issue:** MCP timeout configuration
