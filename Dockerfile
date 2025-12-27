# Use Tomcat 9 with Java 11 (standard for older Servlet projects)
FROM tomcat:9.0-jdk11-openjdk-slim

# Step 1: Remove existing default apps (docs, examples, etc.)
RUN rm -rf /usr/local/tomcat/webapps/*

# Step 2: Copy your war file and name it ROOT.war inside the container
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Step 3: Open port 8080
EXPOSE 8080

# Step 4: Run Tomcat
CMD ["catalina.sh", "run"]


