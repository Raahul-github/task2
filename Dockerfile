# Use OpenJDK 17 as base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built JAR file
COPY ../task-api/target/taskmanager-1.0.0.jar app.jar

# Expose port
EXPOSE 8081

# Run the application with environment variables
CMD ["java", "-jar", "app.jar"]