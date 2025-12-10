# Endor MCP Environment Configuration Details

## Overview
This document provides comprehensive details about the Endor MCP (Model Context Protocol) configuration and environment variables used in the app-java-demo repository.

---

## MCP Server Configuration

### MCP Enable Status
```
COPILOT_MCP_ENABLED=true
```
The MCP server is **enabled** and operational for this repository.

### MCP Server Temporary Directory
```
COPILOT_AGENT_MCP_SERVER_TEMP=/home/runner/work/_temp/mcp-server
```
Temporary working directory for MCP server operations.

---

## Endor Labs API Configuration

### Authentication Credentials

The Endor Labs MCP tools use the following injected secrets for authentication:

```
COPILOT_AGENT_INJECTED_SECRET_NAMES=
  - COPILOT_MCP_ENDOR_API_CREDENTIALS_KEY
  - COPILOT_MCP_ENDOR_API_CREDENTIALS_SECRET
  - COPILOT_MCP_ENDOR_NAMESPACE
  - COPILOT_MCP_ENDOR_SCAN_DRY_RUN
```

#### Secret Descriptions:

1. **COPILOT_MCP_ENDOR_API_CREDENTIALS_KEY**
   - Type: API Key
   - Purpose: Primary authentication credential for Endor Labs API
   - Status: Injected by GitHub Actions (value masked)

2. **COPILOT_MCP_ENDOR_API_CREDENTIALS_SECRET**
   - Type: API Secret
   - Purpose: Secret key paired with API credentials key
   - Status: Injected by GitHub Actions (value masked)

3. **COPILOT_MCP_ENDOR_NAMESPACE**
   - Type: String
   - Purpose: Identifies the Endor Labs tenant/namespace for this organization
   - Status: Injected by GitHub Actions (value masked)

4. **COPILOT_MCP_ENDOR_SCAN_DRY_RUN**
   - Type: Boolean/String
   - Purpose: Controls whether Endor scans run in dry-run mode (no actual changes)
   - Status: Injected by GitHub Actions (value masked)

---

## Agent Configuration Files

### Primary Configuration
**Location:** `/home/runner/work/app-java-demo/app-java-demo/.config/github-copilot/agent.json`

```json
{
  "logLevel": "debug",
  "mcp": {
    "logLevel": "debug"
  }
}
```

### Alternate Configuration
**Location:** `/home/runner/work/app-java-demo/app-java-demo/.copilot/agent.json`

```json
{
  "logLevel": "debug",
  "mcp": {
    "logLevel": "debug"
  }
}
```

### Configuration Analysis:
- **Log Level:** Debug mode enabled for detailed logging
- **MCP Log Level:** Debug mode enabled for MCP-specific operations
- **Purpose:** Enables verbose logging for troubleshooting and monitoring

---

## GitHub Copilot Agent Configuration

### Agent Runtime
```
COPILOT_AGENT_RUNTIME_VERSION=runtime-82e7d12a83c7d303ba4f8db1c1afbae2c0d3ae3e
COPILOT_AGENT_SOURCE_ENVIRONMENT=production
COPILOT_AGENT_START_TIME_SEC=1765364287
COPILOT_AGENT_TIMEOUT_MIN=59
```

### Agent Execution Context
```
COPILOT_AGENT_ISSUE_NUMBER=0
COPILOT_AGENT_PR_NUMBER=
COPILOT_AGENT_PR_COMMIT_COUNT=1
COPILOT_AGENT_ONLINE_EVALUATION_DISABLED=false
```

### Copilot API
```
COPILOT_API_URL=https://api.githubcopilot.com
COPILOT_USE_SESSIONS=true
```

---

## Security Configuration

### Secret Scanning
```
SECRET_SCANNING_URL=https://scanning-api.github.com/api/v1/scan/multipart
```

### SSL/TLS Certificate Configuration
```
CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
SSL_CERT_DIR=/etc/ssl/certs
SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
NODE_EXTRA_CA_CERTS=/home/runner/work/_temp/runtime-logs/mkcert/rootCA.pem
```

### Firewall Configuration
The agent operates with firewall rules enabled. Firewall ruleset is defined and enforced (base64-encoded in environment).

---

## Enabled Copilot Features

The following security and agent features are enabled:

### Security Features:
- ✅ `copilot_swe_agent_firewall_enabled_by_default` - Network firewall protection
- ✅ `copilot_swe_agent_enable_security_tool` - Security analysis tools
- ✅ `copilot_swe_agent_secret_scanning_hook` - Secret detection
- ✅ `copilot_swe_agent_enable_dependabot_checker` - Dependency vulnerability checking

### Agent Capabilities:
- ✅ `copilot_swe_agent_resolve_repo_images` - Repository image resolution
- ✅ `copilot_swe_agent_vision` - Visual understanding capabilities
- ✅ `copilot_swe_agent_parallel_tool_execution` - Concurrent tool execution
- ✅ `copilot_swe_agent_code_review` - Automated code review
- ✅ `copilot_swe_agent_validation_agent_dependencies` - Dependency validation
- ✅ `copilot_swe_agent_memory_usage` - Memory tracking
- ✅ `copilot_swe_agent_memory_service` - Memory service integration

### Experiments:
```
COPILOT_EXPERIMENTS=ghpad_aa:true
COPILOT_EXPERIMENT_ASSIGNMENT_CONTEXT=copilot_t_ci:31333650;ghpad_aa_t:31385605;cp_jb_t_lixleitest:31428973;
```

---

## GitHub Actions Environment

### Repository Context
```
GITHUB_REPOSITORY=endorlabs/app-java-demo
GITHUB_REPOSITORY_ID=543265997
GITHUB_REPOSITORY_OWNER=endorlabs
GITHUB_REPOSITORY_OWNER_ID=92199924
```

### Branch and Commit Information
```
GITHUB_REF=refs/heads/copilot/add-cve-2025-23333-info
GITHUB_REF_NAME=copilot/add-cve-2025-23333-info
GITHUB_REF_TYPE=branch
GITHUB_REF_PROTECTED=false
GITHUB_SHA=97452d1b73d07b8ec137b908c3cadf5b638f7f0a
```

### GitHub API Endpoints
```
GITHUB_API_URL=https://api.github.com
GITHUB_GRAPHQL_URL=https://api.github.com/graphql
GITHUB_SERVER_URL=https://github.com
GITHUB_DOWNLOADS_URL=https://api.github.com/internal/user-attachments/assets
GITHUB_UPLOADS_URL=https://uploads.github.com/user-attachments/assets
```

### Workflow Details
```
GITHUB_WORKFLOW=dynamic/copilot-swe-agent/copilot
GITHUB_WORKFLOW_REF=endorlabs/app-java-demo/dynamic/copilot-swe-agent/copilot@refs/heads/copilot/add-cve-2025-23333-info
GITHUB_WORKFLOW_SHA=97452d1b73d07b8ec137b908c3cadf5b638f7f0a
GITHUB_RUN_ID=20096223517
GITHUB_RUN_NUMBER=74
GITHUB_RUN_ATTEMPT=1
GITHUB_JOB=copilot
GITHUB_ACTION=__run_10
GITHUB_ACTIONS=true
```

### Actor Information
```
GITHUB_ACTOR=copilot-swe-agent[bot]
GITHUB_ACTOR_ID=198982749
GITHUB_TRIGGERING_ACTOR=copilot-swe-agent[bot]
```

---

## Build and Development Environment

### Java Configuration
```
JAVA_HOME=/opt/hostedtoolcache/Java_Microsoft_jdk/17.0.10/x64
```

#### Available Java Versions:
| Version | Path |
|---------|------|
| Java 8 | /usr/lib/jvm/temurin-8-jdk-amd64 |
| Java 11 | /usr/lib/jvm/temurin-11-jdk-amd64 |
| Java 17 | /opt/hostedtoolcache/Java_Microsoft_jdk/17.0.10/x64 |
| Java 21 | /usr/lib/jvm/temurin-21-jdk-amd64 |
| Java 25 | /usr/lib/jvm/temurin-25-jdk-amd64 |

### Build Tools
```
GRADLE_HOME=/usr/share/gradle-9.2.1
```

### Language Runtimes
- **Go:** Multiple versions available (1.22, 1.23, 1.24, 1.25)
- **Node.js:** NVM enabled at /home/runner/.nvm
- **PowerShell:** Available via POWERSHELL_DISTRIBUTION_CHANNEL=GitHub-Actions-ubuntu24
- **Swift:** /usr/share/swift/usr/bin
- **Selenium:** /usr/share/java/selenium-server.jar

### Package Managers
```
PIPX_HOME=/opt/pipx
PIPX_BIN_DIR=/opt/pipx_bin
VCPKG_INSTALLATION_ROOT=/usr/local/share/vcpkg
NVM_DIR=/home/runner/.nvm
GHCUP_INSTALL_BASE_PREFIX=/usr/local
```

---

## Runner Environment

### Operating System
```
RUNNER_OS=Linux
ImageOS=ubuntu24
ImageVersion=20251126.144.1
DEBIAN_FRONTEND=noninteractive
```

### System Configuration
```
RUNNER_ARCH=X64
RUNNER_ENVIRONMENT=github-hosted
RUNNER_NAME=GitHub Actions 1000150055
RUNNER_WORKSPACE=/home/runner/work/app-java-demo
RUNNER_TEMP=/home/runner/work/_temp
RUNNER_TOOL_CACHE=/opt/hostedtoolcache
HOME=/home/runner
USER=runner
SHELL=/bin/bash
LANG=C.UTF-8
```

### Network Configuration
```
DOTNET_SYSTEM_NET_DISABLEIPV6=1
```

---

## File System Paths

### Workspace Locations
```
GITHUB_WORKSPACE=/home/runner/work/app-java-demo/app-java-demo
PWD=/home/runner/work/app-java-demo/app-java-demo
```

### Runner Communication Files
```
GITHUB_ENV=/home/runner/work/_temp/_runner_file_commands/set_env_*
GITHUB_OUTPUT=/home/runner/work/_temp/_runner_file_commands/set_output_*
GITHUB_PATH=/home/runner/work/_temp/_runner_file_commands/add_path_*
GITHUB_STATE=/home/runner/work/_temp/_runner_file_commands/save_state_*
GITHUB_STEP_SUMMARY=/home/runner/work/_temp/_runner_file_commands/step_summary_*
```

### Trajectory Output
```
CPD_SAVE_TRAJECTORY_OUTPUT=/home/runner/work/_temp/copilot-developer-action-main/dist/trajectory.md
```

---

## Additional Configuration

### Homebrew (Package Manager)
```
HOMEBREW_NO_AUTO_UPDATE=1
HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=3650
```

### .NET Configuration
```
DOTNET_NOLOGO=1
DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
DOTNET_MULTILEVEL_LOOKUP=0
```

### System Services
```
SYSTEMD_EXEC_PID=1917
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/0/bus
XDG_RUNTIME_DIR=/run/user/1001
XDG_CONFIG_HOME=/home/runner/.config
```

---

## Environment Analysis

### Security Posture
- ✅ MCP server enabled with authentication
- ✅ API credentials properly injected and masked
- ✅ SSL/TLS certificates configured
- ✅ Secret scanning enabled
- ✅ Firewall rules active
- ✅ Debug logging enabled for troubleshooting

### Configuration Status
- ✅ All Endor Labs credentials properly injected
- ✅ MCP logging set to debug for detailed diagnostics
- ✅ Multiple security features enabled
- ✅ GitHub Actions integration fully configured

### Potential Issues
- ⚠️ Endor MCP service experiencing timeout issues (as of report generation)
- ⚠️ Repository contains outdated dependencies with known vulnerabilities
- ℹ️ Java 8 target in pom.xml while Java 17 is available in environment

---

**Document Generated:** 2025-12-10T10:58:54.659Z  
**Configuration Version:** 1.0  
**Environment:** GitHub Actions (ubuntu24)
