# Use a maintained base image version to avoid EOL vulnerabilities
FROM alpine:3.20.3 AS builder

# Install only the tools needed for build-time tasks and keep the builder separate to minimize the final image
RUN apk add --no-cache curl tar gzip

# Pin Jetty to a version with known security fixes
ARG JETTY_VERSION=9.4.57.v20241219

# Download and extract Jetty, and prepare a clean Jetty home
RUN mkdir -p /opt && \
    curl -fsSL https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${JETTY_VERSION}/jetty-distribution-${JETTY_VERSION}.tar.gz | tar xz -C /opt && \
    ln -s /opt/jetty-distribution-${JETTY_VERSION} /opt/jetty

# Remove HTTP/2 related jars to mitigate known vulnerabilities where full fixes are unavailable
RUN find /opt/jetty-distribution-${JETTY_VERSION}/lib -type f -name "*http2*.jar" -delete

# Fetch patched versions of vulnerable dependencies to replace unsafe ones later
ENV MAVEN_BASE=https://repo1.maven.org/maven2
RUN mkdir -p /safe-libs && \
    curl -fsSL ${MAVEN_BASE}/org/apache/logging/log4j/log4j-core/2.17.2/log4j-core-2.17.2.jar -o /safe-libs/log4j-core-2.17.2.jar && \
    curl -fsSL ${MAVEN_BASE}/com/mchange/c3p0/0.9.5.5/c3p0-0.9.5.5.jar -o /safe-libs/c3p0-0.9.5.5.jar && \
    curl -fsSL ${MAVEN_BASE}/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.jar -o /safe-libs/commons-text-1.10.0.jar && \
    curl -fsSL ${MAVEN_BASE}/org/slf4j/slf4j-ext/1.7.36/slf4j-ext-1.7.36.jar -o /safe-libs/slf4j-ext-1.7.36.jar

# Use a maintained base image version to avoid EOL vulnerabilities
FROM alpine:3.20.3

# Set application working directory
WORKDIR /app

# Install the minimal Java runtime to reduce attack surface
RUN apk add --no-cache openjdk17-jre-headless

# Set JAVA_HOME and PATH for the runtime environment
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Copy the secured Jetty distribution from the builder stage
COPY --from=builder /opt/jetty-distribution-9.4.57.v20241219 /opt/jetty-distribution-9.4.57.v20241219

# Create a stable symlink for Jetty home
RUN ln -s /opt/jetty-distribution-9.4.57.v20241219 /opt/jetty

# Set Jetty environment variables
ENV JETTY_HOME=/opt/jetty
ENV JETTY_BASE=/var/lib/jetty
ENV PATH=$JETTY_HOME/bin:$PATH

# Prepare Jetty base and ensure executable permissions for scripts
RUN mkdir -p $JETTY_BASE && chmod +x $JETTY_HOME/bin/*.sh

# Create application directories
RUN mkdir -p /app/webapps /app/lib

# Copy the built application artifact and its dependencies
COPY target/endor-java-webapp-demo.jar /app/webapps/
COPY target/dependency/ /app/lib/

# Copy application artifact to Jetty webapps for deployment
RUN cp /app/webapps/endor-java-webapp-demo.jar $JETTY_HOME/webapps/

# Copy dependencies to Jetty lib
RUN cp /app/lib/*.jar $JETTY_HOME/lib/

# Remove vulnerable dependency jars and replace them with patched versions
RUN find $JETTY_HOME/lib -type f -name "log4j-core-*.jar" -delete && \
    find $JETTY_HOME/lib -type f -name "c3p0-*.jar" -delete && \
    find $JETTY_HOME/lib -type f -name "commons-text-*.jar" -delete && \
    find $JETTY_HOME/lib -type f -name "slf4j-ext-*.jar" -delete && \
    find /app/lib -type f -name "log4j-core-*.jar" -delete && \
    find /app/lib -type f -name "c3p0-*.jar" -delete && \
    find /app/lib -type f -name "commons-text-*.jar" -delete && \
    find /app/lib -type f -name "slf4j-ext-*.jar" -delete

# Add the patched versions of the previously vulnerable dependencies
COPY --from=builder /safe-libs/ /tmp/safe-libs/
RUN cp /tmp/safe-libs/*.jar $JETTY_HOME/lib/ && rm -rf /tmp/safe-libs

# Create a dedicated non-root user and set least-privilege permissions
RUN addgroup -S jetty && adduser -S -D -H -s /sbin/nologin -G jetty -h $JETTY_BASE jetty && \
    chown -R jetty:jetty $JETTY_BASE $JETTY_HOME /app

# Expose Jetty default port
EXPOSE 8080

# Create a minimal startup script to launch Jetty
RUN echo '#!/bin/sh' > /startup.sh && \
    echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk' >> /startup.sh && \
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /startup.sh && \
    echo 'export JETTY_HOME=/opt/jetty' >> /startup.sh && \
    echo 'export JETTY_BASE=/var/lib/jetty' >> /startup.sh && \
    echo 'exec java -jar $JETTY_HOME/start.jar' >> /startup.sh && \
    chmod +x /startup.sh && \
    chown jetty:jetty /startup.sh

# Run as non-root for security hardening
USER jetty

# Start Jetty using the startup script
CMD ["/startup.sh"]