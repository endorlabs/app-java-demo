# Endor Labs Security Scan Results

**Scan Date:** 2025-12-11  
**Repository:** endorlabs/app-java-demo  
**Scan Types:** Vulnerabilities, Secrets, Dependencies

## Executive Summary

The Endor Labs scan identified **187 security findings** across multiple severity levels:

- **Critical:** 30 findings
- **High:** 138 findings  
- **Medium:** 17 findings
- **Low:** 2 findings

## Critical Severity Findings (30)

### Hard-Coded Passwords and Authentication Issues
- UUID: `693aea11795b08283896b3df` - Use of hard-coded password (java_password_rule-ConstantDBPassword): ID #9a14d3
- UUID: `693aea11b7e2ab7f7f3c88de` - Use of hard-coded password: ID #b62eb8
- UUID: `693aea11b7e2ab7f7f3c88d3` - Use of hard-coded password: ID #2c3e96
- UUID: `693aea11caed38db9a8d57a0` - Use of hard-coded password (java_password_rule-ConstantDBPassword): ID #776e18
- UUID: `693aea11883084110e55b222` - Missing authentication for critical function (java_password_rule-EmptyDBPassword): ID #a4c022
- UUID: `693aea11883084110e55b21f` - Use of hard-coded password (java_password_rule-ConstantDBPassword): ID #df71dc
- UUID: `693aea11883084110e55b21d` - Use of hard-coded password: ID #785b0c
- UUID: `693aea11795b08283896b3d0` - Use of hard-coded password: ID #b0c405
- UUID: `693aea11795b08283896b3d2` - Use of hard-coded password: ID #210530
- UUID: `693aea1166a1e5390899adce` - Use of hard-coded password (java_password_rule-ConstantDBPassword): ID #984ca6
- UUID: `693aea11795b08283896b3dc` - Use of hard-coded password: ID #3e6347
- UUID: `693aea1166a1e5390899adc9` - Use of hard-coded password (java_password_rule-ConstantDBPassword): ID #835339
- UUID: `693aea1102eb18a251abc836` - Use of hard-coded password (java_password_rule-ConstantDBPassword): ID #e9bbea
- UUID: `693aea1102eb18a251abc844` - Missing authentication for critical function (java_password_rule-EmptyDBPassword): ID #f961a0

### Insecure HTTP URLs
- UUID: `693aea11b7e2ab7f7f3c88d8` - Use of Insecure HTTP URLs in Java Applications: ID #8e2e09
- UUID: `693aea11caed38db9a8d579f` - Use of Insecure HTTP URLs in Java Applications: ID #8e5ee0
- UUID: `693aea11b7e2ab7f7f3c88e8` - Use of Insecure HTTP URLs in Java Applications: ID #47a528
- UUID: `693aea11795b08283896b3e1` - Use of Insecure HTTP URLs in Java Applications: ID #0b9774
- UUID: `693aea11caed38db9a8d57af` - Use of Insecure HTTP URLs in Java Applications: ID #a0764a
- UUID: `693aea1166a1e5390899adc0` - Use of Insecure HTTP URLs in Java Applications: ID #6228ee
- UUID: `693aea1166a1e5390899adbb` - Use of Insecure HTTP URLs in Java Applications: ID #c1ec00
- UUID: `693aea1102eb18a251abc83d` - Use of Insecure HTTP URLs in Java Applications: ID #7d9cd5

### Known Vulnerabilities (CVEs)
- UUID: `693aea11795b08283896b3c9` - **GHSA-2qrg-x229-3v8q:** Deserialization of Untrusted Data in Log4j
- UUID: `693aea1102eb18a251abc82a` - **GHSA-q485-j897-qc27:** XML External Entity Reference in mchange:c3p0
- UUID: `693aea11b7e2ab7f7f3c88d0` - **GHSA-jfh8-c2jp-5v3q:** Remote code injection in Log4j
- UUID: `693aea11b7e2ab7f7f3c88ce` - **GHSA-7rjr-3q55-vv33:** Incomplete fix for Apache Log4j vulnerability
- UUID: `693aea1102eb18a251abc82b` - **GHSA-599f-7c49-w659:** Arbitrary code execution in Apache Commons Text
- UUID: `693aea11883084110e55b219` - **GHSA-fxph-q3j8-mv87:** Deserialization of Untrusted Data in Log4j
- UUID: `693aea11795b08283896b3ca` - **GHSA-w77p-8cfg-2x43:** Improper Access Control in SLF4J

### Path Traversal
- UUID: `693aea11caed38db9a8d579d` - Path Traversal Vulnerability (java-servlet-path-traversal-risk): ID #9e5bf2

## High Severity Findings (138)

### SQL Injection Vulnerabilities (108 instances)
Multiple SQL injection vulnerabilities were identified across the application:

#### Spring SQL Injection via String Operations with NamedParameterJdbcTemplate (53 instances)
- UUID: `693aea11795b08283896b3e3` - ID #b61035
- UUID: `693aea11b7e2ab7f7f3c88dc` - ID #d41a5a
- UUID: `693aea1102eb18a251abc839` - ID #1c0a62
- UUID: `693aea1102eb18a251abc83a` - ID #37df2d
- UUID: `693aea11caed38db9a8d57b4` - ID #f89009
- UUID: `693aea1102eb18a251abc840` - ID #4a7e5d
- UUID: `693aea1102eb18a251abc843` - ID #bb6d81
- UUID: `693aea1102eb18a251abc845` - ID #931316
- UUID: `693aea1102eb18a251abc846` - ID #54aa99
- UUID: `693aea1102eb18a251abc835` - ID #497861
- UUID: `693aea1166a1e5390899adb4` - ID #51f061
- UUID: `693aea1166a1e5390899adb5` - ID #4b7dc5
- UUID: `693aea1166a1e5390899adb7` - ID #34238d
- UUID: `693aea1166a1e5390899adb8` - ID #3b2faa
- UUID: `693aea11caed38db9a8d57b1` - ID #2477fa
- UUID: `693aea1166a1e5390899adbd` - ID #b3581f
- UUID: `693aea1166a1e5390899adbe` - ID #968c79
- UUID: `693aea1166a1e5390899adc2` - ID #6977ff
- UUID: `693aea1166a1e5390899adc3` - ID #8386ee
- UUID: `693aea1166a1e5390899adc4` - ID #1d89b4
- UUID: `693aea1166a1e5390899adcb` - ID #f046f0
- UUID: `693aea11caed38db9a8d57ad` - ID #8776b1
- UUID: `693aea1166a1e5390899adcd` - ID #53f6ff
- UUID: `693aea11caed38db9a8d57aa` - ID #5e4a1d
- UUID: `693aea11795b08283896b3cf` - ID #3a49df
- UUID: `693aea11795b08283896b3d6` - ID #a6ea5b
- UUID: `693aea11caed38db9a8d57a6` - ID #2f0de8
- UUID: `693aea11caed38db9a8d57a5` - ID #b1361a
- UUID: `693aea11caed38db9a8d57a4` - ID #896208
- UUID: `693aea11883084110e55b221` - ID #1a4124
- UUID: `693aea11883084110e55b224` - ID #3d2a29
- UUID: `693aea11883084110e55b225` - ID #66daba
- UUID: `693aea11883084110e55b227` - ID #aa0f48
- UUID: `693aea11883084110e55b22a` - ID #c339e9
- UUID: `693aea11883084110e55b22f` - ID #5f775c
- UUID: `693aea11883084110e55b231` - ID #4625ba
- UUID: `693aea11883084110e55b235` - ID #ba8aff
- UUID: `693aea11883084110e55b236` - ID #b30d8e
- UUID: `693aea11caed38db9a8d57a1` - ID #9ae148
- UUID: `693aea11b7e2ab7f7f3c88dd` - ID #be5ce7
- UUID: `693aea11b7e2ab7f7f3c88e3` - ID #d6f594
- UUID: `693aea11b7e2ab7f7f3c88e6` - ID #3dac0f

#### Spring SQL Injection via String Operations (java-spring-dto-sql-injection) (34 instances)
- UUID: `693aea1102eb18a251abc83b` - ID #7cf19d
- UUID: `693aea1102eb18a251abc842` - ID #420066
- UUID: `693aea11caed38db9a8d57b3` - ID #043049
- UUID: `693aea1102eb18a251abc847` - ID #a5f9cc
- UUID: `693aea1102eb18a251abc848` - ID #c1f97c
- UUID: `693aea1102eb18a251abc849` - ID #132a80
- UUID: `693aea11caed38db9a8d57b2` - ID #8e0716
- UUID: `693aea1102eb18a251abc834` - ID #298d86
- UUID: `693aea1166a1e5390899adb3` - ID #cf0b44
- UUID: `693aea1166a1e5390899adc5` - ID #eab0c7
- UUID: `693aea1166a1e5390899adca` - ID #3542b6
- UUID: `693aea11caed38db9a8d57ab` - ID #45b9b1
- UUID: `693aea11caed38db9a8d57a9` - ID #eb1406
- UUID: `693aea11795b08283896b3d1` - ID #bca1f4
- UUID: `693aea11795b08283896b3d4` - ID #fc2fa4
- UUID: `693aea11795b08283896b3d7` - ID #de3db2
- UUID: `693aea11795b08283896b3d9` - ID #29f422
- UUID: `693aea11795b08283896b3da` - ID #46162a
- UUID: `693aea11caed38db9a8d57a7` - ID #1c6a27
- UUID: `693aea11795b08283896b3de` - ID #5b19ea
- UUID: `693aea11795b08283896b3e0` - ID #b88097
- UUID: `693aea1102eb18a251abc833` - ID #ffdb85
- UUID: `693aea11883084110e55b232` - ID #0fd791
- UUID: `693aea1166a1e5390899adcc` - ID #ba95fc
- UUID: `693aea11883084110e55b21e` - ID #f0f66a
- UUID: `693aea11caed38db9a8d57a3` - ID #5cda64
- UUID: `693aea11883084110e55b223` - ID #a409ab
- UUID: `693aea11883084110e55b228` - ID #d8bd7c
- UUID: `693aea11883084110e55b22c` - ID #143c81
- UUID: `693aea1102eb18a251abc830` - ID #5e33da
- UUID: `693aea11caed38db9a8d57a2` - ID #508c6a
- UUID: `693aea1102eb18a251abc82f` - ID #18d249
- UUID: `693aea11caed38db9a8d579b` - ID #22c473
- UUID: `693aea11b7e2ab7f7f3c88d5` - ID #052343
- UUID: `693aea11b7e2ab7f7f3c88d6` - ID #d07205
- UUID: `693aea11b7e2ab7f7f3c88d9` - ID #a9cd77
- UUID: `693aea11b7e2ab7f7f3c88da` - ID #cccd48
- UUID: `693aea11883084110e55b21c` - ID #735b1f
- UUID: `693aea11caed38db9a8d579a` - ID #3234f1
- UUID: `693aea11b7e2ab7f7f3c88e2` - ID #ae141b
- UUID: `693aea11b7e2ab7f7f3c88e5` - ID #a26d96
- UUID: `693aea11caed38db9a8d57b0` - ID #27a8a1

#### Formatted String in SQL Statement (java-formatted-sql-string) (21 instances)
- UUID: `693aea1102eb18a251abc838` - ID #bb6c89
- UUID: `693aea1102eb18a251abc83c` - ID #4a1ecc
- UUID: `693aea1102eb18a251abc83e` - ID #b6e9c6
- UUID: `693aea1102eb18a251abc841` - ID #f0a968
- UUID: `693aea1166a1e5390899adb6` - ID #2005f3
- UUID: `693aea1166a1e5390899adb9` - ID #54e791
- UUID: `693aea1166a1e5390899adba` - ID #3fdbb3
- UUID: `693aea1166a1e5390899adbc` - ID #8e2035
- UUID: `693aea1166a1e5390899adbf` - ID #91ad6b
- UUID: `693aea1166a1e5390899adc1` - ID #d9c73e
- UUID: `693aea1166a1e5390899adc6` - ID #111e4d
- UUID: `693aea1166a1e5390899adc7` - ID #c853ae
- UUID: `693aea11caed38db9a8d57ae` - ID #51e350
- UUID: `693aea11caed38db9a8d57ac` - ID #331ddb
- UUID: `693aea11795b08283896b3cd` - ID #54a568
- UUID: `693aea11795b08283896b3d3` - ID #de7cc9
- UUID: `693aea11795b08283896b3d5` - ID #588c17
- UUID: `693aea11795b08283896b3d8` - ID #250bf6
- UUID: `693aea11795b08283896b3db` - ID #f3e625
- UUID: `693aea11795b08283896b3dd` - ID #f13f88
- UUID: `693aea11795b08283896b3e2` - ID #ed4da9
- UUID: `693aea11795b08283896b3e4` - ID #2d3fc2
- UUID: `693aea11795b08283896b3e5` - ID #2be510
- UUID: `693aea1102eb18a251abc837` - ID #04bcb7
- UUID: `693aea11883084110e55b21a` - ID #3772f2
- UUID: `693aea11883084110e55b220` - ID #862f86
- UUID: `693aea11883084110e55b226` - ID #c4b240
- UUID: `693aea11883084110e55b229` - ID #ac2d00
- UUID: `693aea11883084110e55b22b` - ID #d6488d
- UUID: `693aea11883084110e55b22d` - ID #7b707c
- UUID: `693aea11883084110e55b230` - ID #368dc4
- UUID: `693aea11883084110e55b21b` - ID #0a35ea
- UUID: `693aea11caed38db9a8d579e` - ID #69e2aa
- UUID: `693aea11b7e2ab7f7f3c88d2` - ID #eb8630
- UUID: `693aea11caed38db9a8d579c` - ID #d9b28c
- UUID: `693aea11b7e2ab7f7f3c88d7` - ID #599ee7
- UUID: `693aea11b7e2ab7f7f3c88db` - ID #47631f
- UUID: `693aea11b7e2ab7f7f3c88df` - ID #5c2093
- UUID: `693aea11b7e2ab7f7f3c88e0` - ID #b9b629
- UUID: `693aea11b7e2ab7f7f3c88e1` - ID #c978ab
- UUID: `693aea11b7e2ab7f7f3c88e7` - ID #2007c6
- UUID: `693aea11b7e2ab7f7f3c88eb` - ID #3d482d

### Cross-Site Scripting (XSS) (4 instances)
- UUID: `693aea1166a1e5390899adc8` - Cross-site scripting vulnerability in Java servlet response writer: ID #29998d
- UUID: `693aea11caed38db9a8d57a8` - Cross-site scripting vulnerability in Java servlet response writer: ID #684496
- UUID: `693aea11b7e2ab7f7f3c88d4` - Cross-site scripting vulnerability in Java servlet response writer: ID #70de53
- UUID: `693aea11b7e2ab7f7f3c88e4` - Cross-site scripting vulnerability in Java servlet response writer: ID #afe5f0

### Cryptographic Issues (8 instances)
- UUID: `693aea1102eb18a251abc83f` - Use of a broken or risky cryptographic algorithm (java_crypto_rule-CipherPaddingOracle): ID #7666dd
- UUID: `693aea11795b08283896b3e6` - RSA Encryption Without Proper Padding Scheme: ID #29e769
- UUID: `693aea1102eb18a251abc831` - Use of Cryptographically Weak Pseudo-Random Number Generator (java-insufficient-randomness): ID #77e483
- UUID: `693aea11883084110e55b22e` - Use of Deprecated or Weak Digests and Ciphers - java: ID #a4ca6c
- UUID: `693aea11883084110e55b233` - Use of a broken or risky cryptographic algorithm (java_crypto_rule-CipherDESedeInsecure): ID #6ed63e
- UUID: `693aea11883084110e55b234` - Use of a broken or risky cryptographic algorithm (java_crypto_rule-CipherIntegrity): ID #421e08
- UUID: `693aea11b7e2ab7f7f3c88ec` - Use of a broken or risky cryptographic algorithm (java_crypto_rule-CipherECBMode): ID #71afd6
- UUID: `693aea11b7e2ab7f7f3c88e9` - Use of Deprecated or Weak Digests and Ciphers - java: ID #ba9d83

### Other High Severity Issues
- UUID: `693aea11795b08283896b3cc` - Improper neutralization of CRLF sequences in HTTP headers ('HTTP Response Splitting'): ID #ec0ad2
- UUID: `693aea11795b08283896b3ce` - Improper Restriction of XML External Entity Reference (DocumentBuilderFactory): ID #474e9c
- UUID: `693aea1102eb18a251abc832` - Externally-supplied search path (java-external-search-path): ID #72a6eb
- UUID: `693aea11b7e2ab7f7f3c88cc` - **GHSA-84p2-vf58-xhxv:** Billion laughs attack in c3p0

### Insecure Cookie
- UUID: `693aea11b7e2ab7f7f3c88ea` - Sensitive cookie sent over HTTPS without 'Secure' attribute: ID #a820f0

## Medium Severity Findings (17)

### Known Vulnerabilities (CVEs)
- UUID: `693aea11caed38db9a8d5799` - **GHSA-p6xc-xr62-6r2g:** Apache Log4j2 vulnerable to Improper Input Validation and Uncontrolled Recursion
- UUID: `693aea1166a1e5390899adb0` - **GHSA-8489-44mv-ggj8:** Improper Input Validation and Injection in Apache Log4j2
- UUID: `693aea1102eb18a251abc82c` - **GHSA-j288-q9x7-2f5v:** Apache Commons Lang is vulnerable to Uncontrolled Recursion when processing long inputs
- UUID: `693aea11b7e2ab7f7f3c88cf` - **GHSA-mvr2-9pj6-7w5j:** Denial of Service in Google Guava
- UUID: `693aea11b7e2ab7f7f3c88cd` - **GHSA-jcq3-cprp-m333:** Privilege escalation in mysql-connector-jav
- UUID: `693aea11883084110e55b218` - **GHSA-w6f2-8wx4-47r5:** Incorrect Authorization in MySQL Connector Java
- UUID: `693aea11883084110e55b217` - **GHSA-7g45-4rm6-3mm3:** Guava vulnerable to insecure use of temporary directory

### Dependency Issues
- UUID: `693aea10b7e2ab7f7f3c88c6` - License Risk in Dependency mysql:mysql-connector-java@5.1.42
- UUID: `693aea10b7e2ab7f7f3c88c7` - Outdated Dependency org.mockito:mockito-core@2.28.2
- UUID: `693aea10795b08283896b3c6` - Outdated Dependency net.bytebuddy:byte-buddy-agent@1.9.10
- UUID: `693aea10caed38db9a8d5795` - Unmaintained Dependency org.webjars.bowergithub.webcomponents:webcomponentsjs@2.0.0-beta.3
- UUID: `693aea10883084110e55b214` - Outdated Dependency com.google.errorprone:error_prone_annotations@2.7.1
- UUID: `693aea1002eb18a251abc826` - Unmaintained Dependency org.webjars.bowergithub.webcomponents:shadycss@1.9.1
- UUID: `693aea10795b08283896b3c5` - Outdated Dependency net.bytebuddy:byte-buddy@1.9.10
- UUID: `693aea1066a1e5390899adac` - Unmaintained Dependency org.semver:api@0.9.33

## Low Severity Findings (2)

### Dependency Issues
- UUID: `693aea10b7e2ab7f7f3c88c8` - Dependency org.semver:api@0.9.33 With Low Activity Score
- UUID: `693aea1002eb18a251abc827` - Dependency org.webjars.bowergithub.webcomponents:shadycss@1.9.1 With Low Activity Score

### Known Vulnerabilities (CVEs)
- UUID: `693aea1166a1e5390899adb1` - **GHSA-vwqq-5vrc-xw9h:** Improper validation of certificate with host mismatch in Apache Log4j SMTP appender
- UUID: `693aea1166a1e5390899adb2` - **GHSA-5mg8-w23w-74h3:** Information Disclosure in Guava

## Key Recommendations

### Critical Priority
1. **Remove all hard-coded passwords** - Replace with secure credential management (environment variables, secret managers)
2. **Replace HTTP URLs with HTTPS** - All external communications must use secure protocols
3. **Upgrade Log4j** - Critical remote code execution vulnerabilities exist (Log4Shell and related)
4. **Upgrade Apache Commons Text** - Arbitrary code execution vulnerability
5. **Fix path traversal vulnerability** - Implement proper input validation and sanitization
6. **Upgrade c3p0** - XML External Entity (XXE) vulnerability

### High Priority  
1. **Fix SQL injection vulnerabilities** - Use parameterized queries instead of string concatenation
2. **Implement XSS protection** - Encode all user-supplied data in servlet responses
3. **Update cryptographic algorithms** - Replace weak ciphers (DES, ECB mode) with AES-256-GCM
4. **Fix HTTP response splitting** - Validate and sanitize HTTP headers
5. **Fix XXE vulnerability** - Configure XML parsers securely
6. **Use strong random number generators** - Replace with SecureRandom

### Medium Priority
1. **Upgrade dependencies** - Update mockito, byte-buddy, error_prone_annotations
2. **Replace unmaintained dependencies** - Find actively maintained alternatives for webcomponentsjs, shadycss, semver API
3. **Address license risks** - Review mysql-connector-java license compatibility
4. **Upgrade Guava and MySQL Connector** - Known security issues exist

## Affected Dependencies

- **apache:log4j-core@2.3** - Multiple critical Log4j vulnerabilities
- **apache:commons-text@1.9** - Arbitrary code execution
- **mchange:c3p0@0.9.5.2** - XXE and billion laughs attacks
- **mysql:mysql-connector-java@5.1.42** - Multiple authorization issues
- **org.mockito:mockito-core@2.28.2** - Outdated
- **org.webjars.bowergithub.webcomponents:webcomponentsjs@2.0.0-beta.3** - Unmaintained
- **org.webjars.bowergithub.webcomponents:shadycss@1.9.1** - Unmaintained
- **org.semver:api@0.9.33** - Unmaintained
- **com.google.errorprone:error_prone_annotations@2.7.1** - Outdated

## Next Steps

1. Prioritize fixing all CRITICAL findings immediately
2. Create a remediation plan for HIGH severity SQL injection issues
3. Schedule dependency upgrades for all outdated/vulnerable libraries
4. Implement secure coding practices training for the development team
5. Establish regular security scanning as part of CI/CD pipeline
6. Consider implementing a Web Application Firewall (WAF) as an additional layer of protection

---

**Note:** This scan report contains UUIDs for each finding. Use the Endor Labs `get_resource` tool with these UUIDs to retrieve detailed information about specific findings.
