# GitHub Copilot Debug Configuration

This directory contains configuration files to help debug GitHub Copilot agent issues.

## Debug Mode Configuration

The `agent.json` file enables debug logging for the GitHub Copilot agent and MCP (Model Context Protocol) servers.

### How to Use

To enable debug mode, copy this file to your user config directory:

```bash
# On Linux/macOS
mkdir -p ~/.config/github-copilot
cp .copilot/agent.json ~/.config/github-copilot/agent.json

# On Windows
mkdir -p $env:APPDATA\github-copilot
cp .copilot\agent.json $env:APPDATA\github-copilot\agent.json
```

**Important**: The configuration must be in place **before** the Copilot agent starts. Debug mode cannot be enabled for an already-running agent.

### What This Enables

When debug mode is active:
- Detailed logging of agent operations
- MCP server communication logs
- More verbose error messages
- Helpful for diagnosing timeout issues and tool failures

### Debug Logs Location

After enabling debug mode, logs may be available at:
- `/home/runner/work/_temp/cca-mcp-debug-logs/` (in GitHub Actions)
- Check agent output for log file locations

## Endor Labs Scan Tool

The Endor Labs MCP server scan tool may timeout when scanning large repositories. If you experience timeout issues:

1. **Enable debug mode** (see above) to get detailed logs
2. **Use the provided scan script** as a workaround:
   ```bash
   # From the repository root
   ./.copilot/run-scan.sh --namespace YOUR_NAMESPACE
   ```
3. **Or use direct endorctl invocation**:
   ```bash
   endorctl scan --namespace YOUR_NAMESPACE --path . --dependencies --secrets
   ```
4. **Review timeout settings** - The MCP tool call timeout is currently hardcoded in the platform

### Scan Script (`run-scan.sh`)

The included `run-scan.sh` script provides a convenient way to run Endor Labs scans with proper configuration. It automatically uses the `COPILOT_MCP_ENDOR_NAMESPACE` environment variable if available.

## Environment Variables

Key environment variables for debugging:

- `COPILOT_AGENT_DEBUG` - Set to `true` to enable debug mode
- `COPILOT_MCP_ENABLED` - Shows if MCP is enabled
- `COPILOT_AGENT_TIMEOUT_MIN` - Overall agent timeout (default: 59 minutes)

## Known Issues

- **MCP Timeout**: Long-running operations like security scans may timeout before completion
- **Error Code -32001**: JSON-RPC timeout in MCP protocol layer
- Configuration changes don't apply to already-running agents
