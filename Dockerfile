# Secure multi-stage build to fetch patched libraries and run on a hardened Tomcat base

# Stage 1: Fetch patched dependency JARs from Maven Central
FROM debian:12-slim AS deps
# Security: install only needed tools and clean up apt cache
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /safe-libs
# Download fixed versions of vulnerable libraries (pin exact versions)
# - log4j-core: upgrade to 2.17.2 to fix multiple RCE/DoS vulnerabilities
# - slf4j-ext: upgrade to >=1.7.26 (use 1.7.36)
# - c3p0: upgrade to >=0.9.5.4 (use 0.9.5.5)
# - commons-text: upgrade to >=1.10.0 (use 1.10.0)
RUN set -eux; \
    curl -fSL -o log4j-core-2.17.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.17.2/log4j-core-2.17.2.jar; \
    curl -fSL -o slf4j-ext-1.7.36.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-ext/1.7.36/slf4j-ext-1.7.36.jar; \
    curl -fSL -o c3p0-0.9.5.5.jar https://repo1.maven.org/maven2/com/mchange/c3p0/0.9.5.5/c3p0-0.9.5.5.jar; \
    curl -fSL -o commons-text-1.10.0.jar https://repo1.maven.org/maven2/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.jar

# Stage 2: Use an official, pinned Tomcat base image with JDK 17
# Security: Use Tomcat 9.0.108 which contains fixes for multiple CVEs in catalina/coyote/websocket/util
FROM tomcat:9.0.108-jdk17-temurin-jammy

# Create non-root user and group, and set secure permissions
# Security: Drop root privileges for runtime
ARG APP_USER=tomcat
ARG APP_GROUP=tomcat
RUN set -eux; \
    groupadd --system --gid 1001 "$APP_GROUP"; \
    useradd --system --create-home --uid 1001 --gid 1001 --home-dir /home/"$APP_USER" "$APP_USER"; \
    chown -R "$APP_USER":"$APP_GROUP" "$CATALINA_HOME"

# Copy application-provided libraries, but ensure ownership is non-root
# Security: Use COPY (not ADD) and pin ownership
COPY --chown=${APP_USER}:${APP_GROUP} ./lib/ ${CATALINA_HOME}/lib/

# Remove known vulnerable JARs and replace with patched versions from the deps stage
# Security: purge vulnerable versions present in the application libs and add fixed ones
RUN set -eux; \
    find "${CATALINA_HOME}/lib" -maxdepth 1 -type f -name 'log4j-core-*.jar' -delete; \
    find "${CATALINA_HOME}/lib" -maxdepth 1 -type f -name 'slf4j-ext-1.7.2*.jar' -delete; \
    find "${CATALINA_HOME}/lib" -maxdepth 1 -type f -name 'c3p0-0.9.5.2*.jar' -delete; \
    find "${CATALINA_HOME}/lib" -maxdepth 1 -type f -name 'commons-text-1.9*.jar' -delete

# Add patched libraries
COPY --from=deps --chown=${APP_USER}:${APP_GROUP} /safe-libs/*.jar ${CATALINA_HOME}/lib/

# Expose application port
EXPOSE 8080

# Run as non-root user for least privilege
USER ${APP_USER}

# Start Tomcat
CMD ["catalina.sh", "run"]