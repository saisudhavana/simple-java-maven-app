FROM openjdk:8
COPY  target/my-app-1.0-SNAPSHOT.jar java-jenkins-docker.jar
ENTRYPOINT ["java", "-jar","java-jenkins-docker.jar"]
EXPOSE 8080

# # Use an official OpenJDK runtime as a parent image
# FROM openjdk:11-jre-slim

# # Set the working directory in the container
# WORKDIR /app

# # Copy the JAR file from the target directory to the container
# COPY target/my-app-1.0-SNAPSHOT.jar app.jar

# # Expose the port the app runs on
# EXPOSE 8080

# # Run the application
# ENTRYPOINT ["java", "-jar", "app.jar"]
