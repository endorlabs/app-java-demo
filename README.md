# App Java Demo - Vulnerability Check

This repository includes comprehensive tools for checking Maven dependencies for security vulnerabilities.

## Vulnerability Checking Tools

### Quick Start

To check all dependencies in `pom.xml` for vulnerabilities:

```bash
# Generate comprehensive vulnerability report
python3 comprehensive-vuln-check.py

# Or use the bash script
./check-vulnerabilities.sh
```

### Files

- **`comprehensive-vuln-check.py`** - Main vulnerability assessment tool
- **`parse-dependencies.py`** - Parses pom.xml and extracts dependencies
- **`check-vulnerabilities.sh`** - Bash script for quick checks
- **`VULNERABILITY-CHECK-README.md`** - Detailed documentation

### Generated Reports

After running the tools, you'll get:

1. **`comprehensive-vulnerability-report.md`** - Full vulnerability assessment with:
   - Executive summary with severity counts
   - Detailed CVE information for each vulnerable dependency
   - Remediation recommendations
   - Testing checklist

2. **`dependencies-to-check.json`** - Machine-readable list of all dependencies

3. **`dependency-list.md`** - Human-readable dependency list

### Current Status

As of the last scan:
- **Total Dependencies:** 16
- **🔴 Critical:** 1 (log4j-core 2.3 - Log4Shell)
- **🟠 High:** 2 (commons-text 1.9, mysql-connector-java 5.1.42)
- **🟡 Medium:** 1 (c3p0 0.9.5.2)

⚠️ **URGENT:** Critical vulnerabilities detected. See `comprehensive-vulnerability-report.md` for details.

### Using endor-labs MCP Server

Each dependency can be checked using the endor-labs MCP server:

```python
check_dependency_for_vulnerabilities(
    dependency_name='groupId:artifactId',
    ecosystem='maven',
    version='x.y.z'
)
```

All dependencies are documented in the JSON file for automated scanning.

### Automated Scanning

A GitHub Actions workflow (`.github/workflows/vulnerability-check.yml`) automatically:
- Scans dependencies when pom.xml changes
- Runs weekly security checks
- Generates reports as artifacts
- Comments on pull requests with findings
- Fails the build if critical vulnerabilities are found

### Next Steps

1. Review `comprehensive-vulnerability-report.md`
2. Update critical dependencies immediately
3. Test application after updates
4. Enable automated scanning in your CI/CD pipeline

For detailed instructions, see `VULNERABILITY-CHECK-README.md`.

## License

See repository license file.
