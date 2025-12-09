# App Java Demo

A Java web application demo project for security testing and analysis.

## Overview

This is a Java Maven-based web application that serves as a demonstration project. It includes various servlets, filters, and components that can be used for security testing and analysis purposes.

## Project Structure

```
app-java-demo/
├── src/
│   └── main/
│       ├── java/com/endor/     # Java source files
│       └── webapp/              # Web application resources
├── lib/                         # External libraries
├── pom.xml                      # Maven configuration
└── Dockerfile                   # Docker configuration
```

## Technologies

- **Language**: Java 8
- **Build Tool**: Maven
- **Web Framework**: Java Servlets (javax.servlet-api 3.1.0)
- **Dependencies**: Various including Apache Commons, MySQL, Weld, Log4j, etc.

## Building the Project

### Prerequisites
- Java JDK 8 or higher
- Maven 3.x

### Build Commands

```bash
# Clean and compile
mvn clean compile

# Build JAR
mvn package

# Run tests
mvn test
```

## Security Scanning with Endor Labs

This project includes integration with Endor Labs security scanning tools to identify vulnerabilities, secrets, and dependency issues.

### Quick Start - Running a Security Scan

#### Option 1: Using the Shell Script (Recommended)
```bash
# Run all scan types
./run-endor-scan.sh --all

# Run specific scan types
./run-endor-scan.sh --vulnerabilities
./run-endor-scan.sh --secrets
./run-endor-scan.sh --dependencies
```

#### Option 2: Using the Python Script
```bash
# Run all scan types
python3 endor_scan.py --all

# Run specific scan types
python3 endor_scan.py --vulnerabilities
python3 endor_scan.py --secrets
python3 endor_scan.py --dependencies
```

#### Option 3: Direct MCP Tool Invocation
Use the Endor Labs MCP server scan tool directly:

```
Tool: endor-labs-scan
Parameters:
  - path: /home/runner/work/app-java-demo/app-java-demo
  - scan_types: ["vulnerabilities", "secrets", "dependencies"]
```

### Scan Types

1. **Vulnerabilities**: Scans the Java code for security vulnerabilities including:
   - SQL injection
   - Cross-site scripting (XSS)
   - Path traversal
   - Insecure deserialization
   - And more

2. **Secrets**: Scans for leaked secrets such as:
   - API keys
   - Passwords
   - Tokens
   - Database credentials
   - Private keys

3. **Dependencies**: Scans Maven dependencies for known vulnerabilities:
   - Checks all direct dependencies in pom.xml
   - Analyzes transitive dependencies
   - Identifies CVEs and security advisories

### Documentation

For detailed information about security scanning:
- See [ENDOR_SCAN_README.md](ENDOR_SCAN_README.md) for comprehensive scanning guide
- See [endor-scan.md](endor-scan.md) for additional documentation

### Known Dependencies

Key dependencies that will be scanned include:
- `javax.servlet:javax.servlet-api:3.1.0`
- `org.apache.commons:commons-text:1.9`
- `mysql:mysql-connector-java:5.1.42`
- `org.apache.logging.log4j:log4j-core:2.3`
- And many more (see pom.xml)

**Note**: Some of these dependencies use older versions and may have known vulnerabilities.

## Docker Support

Build and run the application using Docker:

```bash
# Build Docker image
docker build -t app-java-demo .

# Run container
docker run -p 8080:8080 app-java-demo
```

## Development

### Adding New Servlets

1. Create a new Java class in `src/main/java/com/endor/`
2. Extend `HttpServlet`
3. Override `doGet()` or `doPost()` methods
4. Configure in `web.xml` or use annotations

### Running Locally

The application can be deployed to any servlet container such as:
- Apache Tomcat
- Jetty
- WildFly/JBoss

## Security Considerations

This is a **demo application** and contains intentional security issues for testing purposes. 

**DO NOT** deploy this application in a production environment without:
1. Running security scans
2. Addressing all identified vulnerabilities
3. Updating all dependencies to secure versions
4. Implementing proper security controls

## License

[Add license information here]

## Contributing

[Add contributing guidelines here]

## Support

For issues or questions:
- Open an issue in the repository
- Contact the development team
- Refer to the Endor Labs documentation for scanning-related questions
