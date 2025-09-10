FROM alpine:3.16

WORKDIR /app

# Install basic dependencies
RUN apk add --no-cache \
    wget \
    curl \
    unzip \
    tar \
    gzip \
    bash

# Install OpenJDK 17
RUN apk add --no-cache \
    openjdk17-jdk

# Set JAVA_HOME for Alpine Linux
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Install Jetty manually (not available as package in Alpine 3.16)
RUN wget -qO- https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.50.v20221201/jetty-distribution-9.4.50.v20221201.tar.gz | \
    tar xz -C /opt/ && \
    ln -s /opt/jetty-distribution-9.4.50.v20221201 /opt/jetty

# Set Jetty environment variables
ENV JETTY_HOME=/opt/jetty
ENV JETTY_BASE=/var/lib/jetty
ENV PATH=$JETTY_HOME/bin:$PATH

# Create Jetty base directory and set permissions
RUN mkdir -p $JETTY_BASE && \
    chmod +x $JETTY_HOME/bin/*.sh

# Create necessary directories
RUN mkdir -p /app/webapps /app/lib

# Copy the built artifact and dependencies from the target directory
COPY target/endor-java-webapp-demo.jar /app/webapps/
COPY target/dependency/ /app/lib/

# Copy the JAR file to Jetty's webapps directory
RUN cp /app/webapps/endor-java-webapp-demo.jar $JETTY_HOME/webapps/

# Copy dependencies to Jetty's lib directory
RUN cp /app/lib/*.jar $JETTY_HOME/lib/

# Expose Jetty's default port
EXPOSE 8080

# Create a startup script for Alpine Linux with manual Jetty installation
RUN echo '#!/bin/sh' > /startup.sh && \
    echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk' >> /startup.sh && \
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /startup.sh && \
    echo 'export JETTY_HOME=/opt/jetty' >> /startup.sh && \
    echo 'export JETTY_BASE=/var/lib/jetty' >> /startup.sh && \
    echo 'exec java -jar $JETTY_HOME/start.jar' >> /startup.sh && \
    chmod +x /startup.sh

# Start Jetty using the startup script
CMD ["/startup.sh"]
