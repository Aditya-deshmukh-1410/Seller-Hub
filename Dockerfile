# Use Tomcat 9 with Java 17
FROM tomcat:9.0-jdk17-openjdk-slim

# Remove existing default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR as ROOT.war
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]
