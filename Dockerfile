FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$PATH:$CATALINA_HOME/bin

WORKDIR /app

# Update package list and install basic dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    unzip \
    tar \
    gzip \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME dynamically based on actual installation and update PATH
RUN JAVA_HOME=$(find /usr/lib/jvm -name "java-17-openjdk-*" -type d | head -1) && \
    echo "export JAVA_HOME=$JAVA_HOME" >> /etc/environment && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/environment && \
    echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile

# Download and install Tomcat 9 (updated to secure version 9.0.90)
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.90/bin/apache-tomcat-9.0.90.tar.gz && \
    tar -xzf apache-tomcat-9.0.90.tar.gz && \
    mv apache-tomcat-9.0.90 /opt/tomcat && \
    rm apache-tomcat-9.0.90.tar.gz

# Set permissions for Tomcat
RUN chmod +x /opt/tomcat/bin/*.sh

# Create necessary directories
RUN mkdir -p /app/webapps /app/lib

# Copy the built artifact and dependencies from the target directory
COPY target/endor-java-webapp-demo.jar /app/webapps/
COPY target/dependency/ /app/lib/

# Copy the JAR file to Tomcat's webapps directory
RUN cp /app/webapps/endor-java-webapp-demo.jar $CATALINA_HOME/webapps/

# Copy dependencies to Tomcat's lib directory, ensuring updated versions
RUN cp /app/lib/*.jar $CATALINA_HOME/lib/

# Expose Tomcat's default port
EXPOSE 8080

# Create a startup script that sources environment variables
RUN echo '#!/bin/bash' > /startup.sh && \
    echo 'source /etc/environment' >> /startup.sh && \
    echo 'source /etc/profile' >> /startup.sh && \
    echo 'exec /opt/tomcat/bin/catalina.sh run' >> /startup.sh && \
    chmod +x /startup.sh

# Start Tomcat using the startup script
CMD ["/startup.sh"]