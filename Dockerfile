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
    && rm -rf /var/lib/apt/lists/*

# Install OpenJDK 17
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME dynamically based on actual installation and update PATH
RUN JAVA_HOME=$(find /usr/lib/jvm -name "java-17-openjdk-*" -type d | head -1) && \
    echo "export JAVA_HOME=$JAVA_HOME" >> /etc/environment && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/environment && \
    echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile && \
    echo "JAVA_HOME=$JAVA_HOME" >> /etc/environment && \
    echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/environment

# Security: Update Apache Tomcat to 9.0.108 to address vulnerabilities in 9.0.62
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.108/bin/apache-tomcat-9.0.108.tar.gz && \
    tar -xzf apache-tomcat-9.0.108.tar.gz && \
    mv apache-tomcat-9.0.108 /opt/tomcat && \
    rm apache-tomcat-9.0.108.tar.gz

# Set permissions for Tomcat
RUN chmod +x /opt/tomcat/bin/*.sh

# Create necessary directories
RUN mkdir -p /app/webapps /app/lib

# Copy the built artifact and dependencies from the target directory
COPY target/endor-java-webapp-demo.jar /app/webapps/
COPY target/dependency/ /app/lib/

# Copy the JAR file to Tomcat's webapps directory
RUN cp /app/webapps/endor-java-webapp-demo.jar $CATALINA_HOME/webapps/

# Security: Replace vulnerable libraries with fixed versions (log4j-core 2.8.2, slf4j-ext 1.7.26, c3p0 0.9.5.4, commons-text 1.10.0)
RUN cp /app/lib/*.jar $CATALINA_HOME/lib/ && \
    rm -f $CATALINA_HOME/lib/log4j-core-*.jar \
          $CATALINA_HOME/lib/slf4j-ext-*.jar \
          $CATALINA_HOME/lib/c3p0-*.jar \
          $CATALINA_HOME/lib/commons-text-*.jar && \
    wget -O $CATALINA_HOME/lib/log4j-core-2.8.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.8.2/log4j-core-2.8.2.jar && \
    wget -O $CATALINA_HOME/lib/slf4j-ext-1.7.26.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-ext/1.7.26/slf4j-ext-1.7.26.jar && \
    wget -O $CATALINA_HOME/lib/c3p0-0.9.5.4.jar https://repo1.maven.org/maven2/com/mchange/c3p0/0.9.5.4/c3p0-0.9.5.4.jar && \
    wget -O $CATALINA_HOME/lib/commons-text-1.10.0.jar https://repo1.maven.org/maven2/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.jar

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