# Use a maintained Alpine base and build Jetty and patched libraries in a separate stage to reduce attack surface
FROM alpine:3.20.3 AS builder

# Install minimal tools required to fetch and unpack artifacts
RUN apk add --no-cache ca-certificates wget tar

# Set secure Jetty version
ARG JETTY_VERSION=9.4.57.v20241219

# Define Jetty paths
ENV JETTY_HOME=/opt/jetty

# Download and install a secured Jetty distribution version
RUN mkdir -p /opt && \
    wget -q "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${JETTY_VERSION}/jetty-distribution-${JETTY_VERSION}.tar.gz" -O /tmp/jetty.tar.gz && \
    tar -xzf /tmp/jetty.tar.gz -C /opt && \
    ln -s "/opt/jetty-distribution-${JETTY_VERSION}" "${JETTY_HOME}" && \
    rm -f /tmp/jetty.tar.gz

# Remove HTTP/2 components to mitigate known Jetty HTTP/2 vulnerabilities
RUN rm -f ${JETTY_HOME}/lib/*http2*.jar || true

# Ensure Jetty scripts are executable
RUN chmod +x ${JETTY_HOME}/bin/*.sh

# Download patched libraries to replace vulnerable ones at runtime
RUN mkdir -p /safe-libs && \
    wget -q -O /safe-libs/log4j-core-2.17.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.17.2/log4j-core-2.17.2.jar && \
    wget -q -O /safe-libs/log4j-api-2.17.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.17.2/log4j-api-2.17.2.jar && \
    wget -q -O /safe-libs/c3p0-0.9.5.5.jar https://repo1.maven.org/maven2/com/mchange/c3p0/0.9.5.5/c3p0-0.9.5.5.jar && \
    wget -q -O /safe-libs/commons-text-1.10.0.jar https://repo1.maven.org/maven2/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.jar && \
    wget -q -O /safe-libs/slf4j-ext-1.7.36.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-ext/1.7.36/slf4j-ext-1.7.36.jar


# Use a maintained Alpine base with only the JRE in the final image
FROM alpine:3.20.3

WORKDIR /app

# Install only the headless OpenJDK 17 runtime to reduce attack surface
RUN apk add --no-cache openjdk17-jre-headless

# Set JAVA_HOME for Alpine Linux
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Set Jetty environment variables
ENV JETTY_HOME=/opt/jetty
ENV JETTY_BASE=/var/lib/jetty
ENV PATH=$JETTY_HOME/bin:$PATH

# Create a dedicated non-root user and necessary directories with restricted permissions
RUN addgroup -S jetty && adduser -S -G jetty -h /var/lib/jetty -s /sbin/nologin jetty && \
    mkdir -p "$JETTY_BASE" /app/webapps /app/lib && \
    chown -R jetty:jetty "$JETTY_BASE" /app

# Keep ARG in final stage to resolve the builder artifact path
ARG JETTY_VERSION=9.4.57.v20241219

# Copy the secured Jetty distribution from the builder stage
COPY --from=builder /opt/jetty-distribution-${JETTY_VERSION} /opt/jetty-distribution-${JETTY_VERSION}
COPY --from=builder /opt/jetty /opt/jetty

# Copy patched libraries downloaded in the builder stage
COPY --from=builder /safe-libs /safe-libs

# Ensure Jetty scripts are executable and restrict world-writable permissions
RUN chmod -R go-w /opt && chmod +x $JETTY_HOME/bin/*.sh

# Copy the built artifact and dependencies from the target directory
COPY target/endor-java-webapp-demo.jar /app/webapps/
COPY target/dependency/ /app/lib/

# Remove HTTP/2 components to mitigate known Jetty HTTP/2 vulnerabilities at runtime
RUN rm -f ${JETTY_HOME}/lib/*http2*.jar || true

# Replace vulnerable libraries with patched versions and only include safe dependencies
# This step removes vulnerable libs (log4j 2.3, c3p0 0.9.5.2, commons-text 1.9, slf4j-ext 1.7.2) and any HTTP/2 jars from app libs
# Then it copies only safe dependencies and re-applies HTTP/2 removal to ensure none are reintroduced
RUN cp /app/webapps/endor-java-webapp-demo.jar $JETTY_HOME/webapps/ && \
    rm -f /app/lib/*http2*.jar || true && \
    rm -f /app/lib/log4j-core-*.jar /app/lib/log4j-api-*.jar /app/lib/c3p0-*.jar /app/lib/commons-text-*.jar /app/lib/slf4j-ext-*.jar || true && \
    find /app/lib -type f -name "*.jar" -exec cp {} $JETTY_HOME/lib/ \; && \
    cp /safe-libs/*.jar $JETTY_HOME/lib/ && \
    rm -f ${JETTY_HOME}/lib/*http2*.jar || true && \
    chown -R jetty:jetty $JETTY_HOME $JETTY_BASE && \
    chmod -R go-w $JETTY_HOME $JETTY_BASE && \
    rm -rf /safe-libs

# Expose Jetty's default port
EXPOSE 8080

# Create a startup script to launch Jetty with the secured environment
RUN echo '#!/bin/sh' > /startup.sh && \
    echo 'set -eu' >> /startup.sh && \
    echo 'umask 027' >> /startup.sh && \
    echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk' >> /startup.sh && \
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /startup.sh && \
    echo 'export JETTY_HOME=/opt/jetty' >> /startup.sh && \
    echo 'export JETTY_BASE=/var/lib/jetty' >> /startup.sh && \
    echo 'exec java -jar $JETTY_HOME/start.jar' >> /startup.sh && \
    chmod +x /startup.sh && \
    chown jetty:jetty /startup.sh

# Run as a non-root user for improved security
USER jetty

# Start Jetty using the startup script
CMD ["/startup.sh"]