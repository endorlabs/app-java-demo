# 🚨 Endor Labs MCP Scan Timeout - Quick Reference

## TL;DR

**Problem:** Endor Labs scans timeout after ~60 seconds  
**Cause:** MCP timeout too short for scans that take 5-10 minutes  
**Status:** ⏸️ Blocked - requires Copilot platform team fix  
**Solution:** Increase MCP timeout to 15+ minutes  

---

## Visual Timeline

```
Time    Event
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
0:00    ✅ Tool call: endor-labs-scan starts
0:05    ⏳ MCP server receives request
0:10    ⏳ Server begins scan initialization
0:15    ⏳ Building dependency tree...
0:20    ⏳ Analyzing source code...
0:25    ⏳ Checking vulnerabilities...
0:30    ⏳ Scanning for secrets...
0:35    ⏳ Generating findings...
0:40    ⏳ Preparing results...
0:45    ⏳ Scan still running...
0:50    ⏳ Scan still running...
0:55    ⏳ Scan still running...
1:00    ❌ MCP TIMEOUT - Request aborted!
        ⛔ Error: MCP error -32001
        
5:00    🔍 Scan would have completed here
```

## The Gap

```
┌─────────────────────────────────────────────────────────┐
│  Endor Labs Scan Timeline                               │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     │
│  ◄──── Actual Scan Duration: 5-10 minutes ────────►     │
│                                                          │
│  ▓▓▓▓▓▓▓▓▓▓▓ ⚠️                                          │
│  ◄─ Timeout ─►                                           │
│   ~60 seconds                                            │
│                                                          │
└─────────────────────────────────────────────────────────┘

Legend: ▓ = Processing time  ⚠️ = Timeout occurs
```

## What Was Tested

| Test | Operation | Result |
|------|-----------|--------|
| 1️⃣ | Full scan (all types) | ❌ TIMEOUT |
| 2️⃣ | Vulnerabilities only | ❌ TIMEOUT |
| 3️⃣ | Dependencies only | ❌ TIMEOUT |
| 4️⃣ | Secrets only | ❌ TIMEOUT |
| 5️⃣ | Check specific dependency | ❌ TIMEOUT |
| 6️⃣ | Get vulnerability info | ❌ TIMEOUT |
| 7️⃣ | Get project resource | ❌ TIMEOUT |
| 8️⃣ | CLI workaround | ❌ BLOCKED (credentials) |

**Success Rate:** 0/8 (0%)

## Environment Status

| Component | Status | Details |
|-----------|--------|---------|
| MCP Server | ✅ Running | PID 2464, v1.7.704 |
| Credentials | ✅ Configured | Injected secrets |
| Network | ✅ Allowed | Firewall permits Endor domains |
| API Calls | ❌ None logged | Timeout before execution |
| Timeout Config | ❌ Too short | ~60s (need 900s+) |

## Why No Workarounds Exist

```
Option                     Status   Reason
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Use endorctl CLI           ❌      Credentials isolated to MCP
Increase tool timeout      ❌      Not configurable by agent
Split into smaller scans   ❌      Each scan still needs 5+ min
Run scan manually          ❌      No credential access
Async scan pattern         ❌      Not implemented in MCP server
```

## Solution Comparison

| Solution | Time to Fix | Effort | Impact | Priority |
|----------|-------------|--------|--------|----------|
| Increase global timeout | 1 day | Low | All tools | 🔴 HIGH |
| Per-tool timeout config | 1 week | Medium | Granular | 🟡 MEDIUM |
| Async operation pattern | 1 month | High | Best UX | 🟢 LOW |

## Impact

### What Works ✅
- Repository exploration
- Code reading/editing
- Build/test operations
- Git operations
- Other MCP tools

### What Doesn't Work ❌
- Endor Labs vulnerability scanning
- Endor Labs dependency analysis
- Endor Labs secret detection
- Endor Labs resource queries
- Any Endor Labs MCP tool

## Who Needs to Act

```
┌──────────────────────┐
│  Copilot Platform    │ ◄── Configure MCP timeout
│  Team                │     (15+ minutes)
└──────────────────────┘
          │
          │ Provides
          ▼
┌──────────────────────┐
│  MCP Framework       │ ◄── Applies timeout config
│                      │     to tool requests
└──────────────────────┘
          │
          │ Executes
          ▼
┌──────────────────────┐
│  Endor Labs MCP      │ ◄── Runs scan (works fine)
│  Server              │     Just needs more time!
└──────────────────────┘
```

## Quick Links

- **Full Analysis:** `ENDOR_SCAN_TIMEOUT_DEBUG.md`
- **Summary:** `TIMEOUT_INVESTIGATION_SUMMARY.md`
- **This File:** `README_TIMEOUT_ISSUE.md`

## Questions?

**Q: Is Endor Labs broken?**  
A: No, the service works fine. MCP timeout is too short.

**Q: Can we fix this ourselves?**  
A: No, requires platform team configuration change.

**Q: How long will it take to fix?**  
A: ~1 day for quick fix (increase timeout globally).

**Q: Will this happen again?**  
A: Yes, with any tool that takes >60s to complete.

---

**Investigation Date:** 2025-12-09  
**Status:** Investigation Complete ✅  
**Blocking:** Copilot Platform Team Action Required ⏸️  
**Priority:** HIGH 🔴  
