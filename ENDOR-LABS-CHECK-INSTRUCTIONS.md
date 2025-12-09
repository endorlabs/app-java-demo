# Endor Labs MCP Server - Dependency Check Instructions

This document provides the specific commands to check each Maven dependency using the endor-labs MCP server's `check_dependency_for_vulnerabilities` tool.

## Summary

- **Total Dependencies:** 16
- **Ecosystem:** maven
- **Source:** pom.xml

## Critical Priority Dependencies (Check First)

### 1. log4j-core (CRITICAL - Log4Shell)

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.apache.logging.log4j:log4j-core',
    ecosystem='maven',
    version='2.3'
)
```

**Why Critical:** CVE-2021-44228 (Log4Shell) - CVSS 10.0, Remote Code Execution

---

### 2. commons-text (HIGH Priority)

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.apache.commons:commons-text',
    ecosystem='maven',
    version='1.9'
)
```

**Why High:** CVE-2022-42889 - CVSS 9.8, Variable interpolation RCE

---

### 3. mysql-connector-java (HIGH Priority)

```python
check_dependency_for_vulnerabilities(
    dependency_name='mysql:mysql-connector-java',
    ecosystem='maven',
    version='5.1.42'
)
```

**Why High:** Multiple CVEs - CVSS 8.1

---

### 4. c3p0 (MEDIUM Priority)

```python
check_dependency_for_vulnerabilities(
    dependency_name='com.mchange:c3p0',
    ecosystem='maven',
    version='0.9.5.2'
)
```

**Why Medium:** CVE-2019-5427 - CVSS 7.5, XXE vulnerability

---

## All Other Dependencies

### 5. javax.servlet-api

```python
check_dependency_for_vulnerabilities(
    dependency_name='javax.servlet:javax.servlet-api',
    ecosystem='maven',
    version='3.1.0'
)
```

---

### 6. weld-core

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.jboss.weld:weld-core',
    ecosystem='maven',
    version='1.1.33.Final'
)
```

---

### 7. permit-reflect

```python
check_dependency_for_vulnerabilities(
    dependency_name='com.nqzero:permit-reflect',
    ecosystem='maven',
    version='0.3'
)
```

---

### 8. arquillian-config-spi

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.jboss.arquillian.config:arquillian-config-spi',
    ecosystem='maven',
    version='1.7.0.Alpha12'
)
```

---

### 9. arquillian-container-impl-base

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.jboss.arquillian.container:arquillian-container-impl-base',
    ecosystem='maven',
    version='1.7.0.Alpha12'
)
```

---

### 10. shrinkwrap-descriptors-api-base

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.jboss.shrinkwrap.descriptors:shrinkwrap-descriptors-api-base',
    ecosystem='maven',
    version='2.0.0'
)
```

---

### 11. shrinkwrap-impl-base

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.jboss.shrinkwrap:shrinkwrap-impl-base',
    ecosystem='maven',
    version='1.2.6'
)
```

---

### 12. mockito-core

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.mockito:mockito-core',
    ecosystem='maven',
    version='2.28.2'
)
```

---

### 13. error_prone_annotations

```python
check_dependency_for_vulnerabilities(
    dependency_name='com.google.errorprone:error_prone_annotations',
    ecosystem='maven',
    version='2.7.1'
)
```

---

### 14. webcomponentsjs

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.webjars.bowergithub.webcomponents:webcomponentsjs',
    ecosystem='maven',
    version='2.0.0-beta.3'
)
```

---

### 15. shadycss

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.webjars.bowergithub.webcomponents:shadycss',
    ecosystem='maven',
    version='1.9.1'
)
```

---

### 16. semver-api

```python
check_dependency_for_vulnerabilities(
    dependency_name='org.semver:api',
    ecosystem='maven',
    version='0.9.33'
)
```

---

## Batch Processing

To check all dependencies programmatically, load from `dependencies-to-check.json`:

```python
import json

with open('dependencies-to-check.json', 'r') as f:
    dependencies = json.load(f)

for dep in dependencies:
    check_dependency_for_vulnerabilities(
        dependency_name=dep['name'],
        ecosystem=dep['ecosystem'],
        version=dep['version']
    )
```

## Notes

- **Ecosystem:** All dependencies use `ecosystem='maven'`
- **Naming Format:** `groupId:artifactId`
- **Version Format:** As specified in pom.xml (including qualifiers like `.Final`, `-beta.3`, etc.)
- **Priority:** Check critical dependencies first as they pose immediate security risks

## Next Steps

1. Execute checks for all critical/high priority dependencies first
2. Review findings from endor-labs MCP server
3. Compare with findings in `comprehensive-vulnerability-report.md`
4. Update vulnerable dependencies
5. Re-run checks to verify fixes
