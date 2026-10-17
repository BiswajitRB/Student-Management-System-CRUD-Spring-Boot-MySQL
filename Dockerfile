# ==========================================
# STAGE 1: Build the application using Maven
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the jar file (skipping tests for faster build)
RUN mvn clean package -DskipTests

# ==========================================
# STAGE 2: Create lightweight production image
# ==========================================
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy only the built jar file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]