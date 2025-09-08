FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$PATH:$CATALINA_HOME/bin

WORKDIR /app

# Update package list and install basic dependencies
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk wget curl unzip tar gzip && \
    rm -rf /var/lib/apt/lists/* && \
    # Install specific version of Tomcat to mitigate security risks
    wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.107/bin/apache-tomcat-9.0.107.tar.gz && \
    tar -xzf apache-tomcat-9.0.107.tar.gz && \
    mv apache-tomcat-9.0.107 $CATALINA_HOME && \
    rm apache-tomcat-9.0.107.tar.gz

# Copy application files into the container
COPY ./lib/*.jar $CATALINA_HOME/lib/

# Set permissions for the Tomcat user
RUN chown -R tomcat:tomcat $CATALINA_HOME && \
    chmod -R 755 $CATALINA_HOME

# Switch to a non-root user for security
USER tomcat

# Expose Tomcat's default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]