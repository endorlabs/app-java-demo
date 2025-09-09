# Use a builder stage to fetch and prepare Tomcat and safe dependencies
FROM ubuntu:22.04 AS builder

# Security: use noninteractive mode to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Security: define Tomcat home and pin Tomcat to a secure, patched version to address multiple CVEs
ENV CATALINA_HOME=/opt/tomcat
ENV TOMCAT_VERSION=9.0.108

# Set working directory for temporary operations
WORKDIR /tmp

# Security: install only required tools and clear apt cache to minimize attack surface
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget curl unzip tar gzip ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Security: download and install Tomcat at a patched version and remove default apps to reduce attack surface
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar -xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
    rm -f apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    chmod +x ${CATALINA_HOME}/bin/*.sh && \
    rm -rf ${CATALINA_HOME}/webapps/docs ${CATALINA_HOME}/webapps/examples ${CATALINA_HOME}/webapps/manager ${CATALINA_HOME}/webapps/host-manager

# Create application directories
RUN mkdir -p /app/webapps /app/lib

# Copy the built artifact and dependencies from the target directory
COPY target/endor-java-webapp-demo.jar /app/webapps/
COPY target/dependency/ /app/lib/

# Security: remove vulnerable JARs and replace with patched versions to remediate CVEs
RUN rm -f /app/lib/log4j-core-*.jar /app/lib/log4j-api-*.jar /app/lib/commons-text-*.jar /app/lib/slf4j-ext-*.jar /app/lib/c3p0-*.jar && \
    wget -q -O ${CATALINA_HOME}/lib/log4j-core-2.17.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.17.2/log4j-core-2.17.2.jar && \
    wget -q -O ${CATALINA_HOME}/lib/log4j-api-2.17.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.17.2/log4j-api-2.17.2.jar && \
    wget -q -O ${CATALINA_HOME}/lib/commons-text-1.10.0.jar https://repo1.maven.org/maven2/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.jar && \
    wget -q -O ${CATALINA_HOME}/lib/slf4j-ext-1.7.36.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-ext/1.7.36/slf4j-ext-1.7.36.jar && \
    wget -q -O ${CATALINA_HOME}/lib/c3p0-0.9.5.4.jar https://repo1.maven.org/maven2/com/mchange/c3p0/0.9.5.4/c3p0-0.9.5.4.jar && \
    find /app/lib -type f -name "*.jar" -exec cp {} ${CATALINA_HOME}/lib/ \; && \
    cp /app/webapps/endor-java-webapp-demo.jar ${CATALINA_HOME}/webapps/

# Security: set restrictive file permissions for Tomcat files and ensure scripts are executable
RUN find ${CATALINA_HOME} -type d -exec chmod 0755 {} \; && \
    find ${CATALINA_HOME} -type f -exec chmod 0644 {} \; && \
    chmod 0755 ${CATALINA_HOME}/bin/*.sh

# Use a minimal, secure runtime base image with Java 17 JRE
FROM eclipse-temurin:17-jre-jammy

# Security: set Tomcat home and PATH explicitly to avoid sourcing global profiles
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=${PATH}:${CATALINA_HOME}/bin

# Set working directory for consistency
WORKDIR /app

# Security: create a dedicated non-root user and group for running Tomcat
RUN groupadd --system --gid 1001 tomcat && \
    useradd --system --uid 1001 --gid 1001 --home-dir ${CATALINA_HOME} --shell /usr/sbin/nologin tomcat

# Copy prepared Tomcat and application from the builder stage
COPY --from=builder /opt/tomcat /opt/tomcat

# Security: adjust ownership and permissions to least privilege
RUN chown -R tomcat:tomcat /opt/tomcat && \
    find /opt/tomcat -type d -exec chmod 0755 {} \; && \
    find /opt/tomcat -type f -exec chmod 0644 {} \; && \
    chmod 0755 /opt/tomcat/bin/*.sh

# Expose Tomcat's default port
EXPOSE 8080

# Security: create a minimal startup script without sourcing global environment files
RUN printf '%s\n' '#!/bin/sh' 'exec /opt/tomcat/bin/catalina.sh run' > /startup.sh && \
    chmod +x /startup.sh

# Security: run as non-root user
USER 1001:1001

# Start Tomcat using the startup script
CMD ["/startup.sh"]