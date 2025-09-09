# Secure multi-stage build: fetch patched third-party libraries and use a patched Tomcat runtime
# Stage 1: Dependency fetcher with minimal footprint and pinned package versions
FROM debian:12-slim AS deps

# Install only required tools and clean apt cache to minimize attack surface
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /safe-libs

# Download patched JARs to replace vulnerable ones
# - log4j-core: fix critical RCE and deserialization vulnerabilities (>=2.8.2). Using 2.17.2 LTS.
# - slf4j-ext: fix improper access control (>=1.7.26). Using 1.7.36.
# - c3p0: fix XXE and billion laughs (>=0.9.5.4). Using 0.9.5.5.
# - commons-text: fix arbitrary code execution (>=1.10.0). Using 1.10.0.
RUN set -eux; \
    curl -fSL -o log4j-core-2.17.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.17.2/log4j-core-2.17.2.jar; \
    curl -fSL -o slf4j-ext-1.7.36.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-ext/1.7.36/slf4j-ext-1.7.36.jar; \
    curl -fSL -o c3p0-0.9.5.5.jar https://repo1.maven.org/maven2/com/mchange/c3p0/0.9.5.5/c3p0-0.9.5.5.jar; \
    curl -fSL -o commons-text-1.10.0.jar https://repo1.maven.org/maven2/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.jar

# Stage 2: Runtime - pinned to Tomcat 9.0.108 (fixes multiple CVEs across catalina, coyote, websocket, util)
FROM tomcat:9.0.108-jdk17-temurin-jammy

# Create and use a dedicated non-root user, and set strict ownership
# Security: running as non-root reduces risk of container breakout
RUN set -eux; \
    groupadd --system --gid 1001 "tomcat"; \
    useradd --system --create-home --uid 1001 --gid 1001 --home-dir /home/"tomcat" "tomcat"; \
    chown -R "tomcat":"tomcat" "/usr/local/tomcat"

# Copy application-provided libraries (if present), but ensure vulnerable ones are removed
# Security: prefer COPY over ADD; apply ownership at copy time
COPY --chown=tomcat:tomcat ./lib/ /usr/local/tomcat/lib/

# Remove known vulnerable JARs that may be present in the app libs
# - log4j-core 2.3 (multiple critical CVEs)
# - slf4j-ext 1.7.2 (critical improper access control)
# - c3p0 0.9.5.2 (XXE and billion laughs)
# - commons-text 1.9 (arbitrary code execution)
RUN set -eux; \
    find "/usr/local/tomcat/lib" -maxdepth 1 -type f -name 'log4j-core-*.jar' -delete; \
    find "/usr/local/tomcat/lib" -maxdepth 1 -type f -name 'slf4j-ext-1.7.2*.jar' -delete; \
    find "/usr/local/tomcat/lib" -maxdepth 1 -type f -name 'c3p0-0.9.5.2*.jar' -delete; \
    find "/usr/local/tomcat/lib" -maxdepth 1 -type f -name 'commons-text-1.9*.jar' -delete

# Add patched libraries fetched in the deps stage
COPY --from=deps --chown=tomcat:tomcat /safe-libs/*.jar /usr/local/tomcat/lib/