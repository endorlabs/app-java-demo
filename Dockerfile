# Use a specific version of Ubuntu as the base image for security
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$PATH:$CATALINA_HOME/bin

WORKDIR /app

# Update package list and install the necessary dependencies securely
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    unzip \
    tar \
    gzip \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/* \
    # Download and install the fixed version of Tomcat
    && wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.107/bin/apache-tomcat-9.0.107.tar.gz \
    && tar -xzf apache-tomcat-9.0.107.tar.gz \
    && mv apache-tomcat-9.0.107 $CATALINA_HOME \
    && rm apache-tomcat-9.0.107.tar.gz \
    # Create a non-root user for security
    && adduser --system --group tomcat \
    && usermod -d $CATALINA_HOME tomcat \
    && chown -R tomcat:tomcat $CATALINA_HOME

# Copy application libs to tomcat after ensuring they are also updated
COPY ./lib/*.jar $CATALINA_HOME/lib/

# Expose the port for the application
EXPOSE 8080

# Run Tomcat under the non-root user for security
USER tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]