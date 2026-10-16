# --- Stage 1: Build the application ---
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Pehle dependencies download karein taaki caching fast ho
COPY pom.xml .
RUN mvn dependency:go-offline

# Source code copy karke jar file build karein (tests skip karke)
COPY src ./src
RUN mvn clean package -DskipTests

# --- Stage 2: Run the application using a lightweight JRE image ---
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Builder stage se sirf compiled jar file ko copy karein
COPY --from=builder /app/target/*.jar app.jar

# Spring Boot default port
EXPOSE 8080

# Application run karne ki command
ENTRYPOINT ["java", "-jar", "app.jar"]