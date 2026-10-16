# ---------- Stage 1: Build ----------
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Pehle sirf pom.xml copy karo taaki dependencies cache ho jayein
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Phir source code copy karke jar banao (tests CI me pehle hi chal chuke hain)
COPY src ./src
RUN mvn -B clean package -DskipTests

# ---------- Stage 2: Run ----------
FROM eclipse-temurin:17-jre
WORKDIR /app

# Non-root user (security ke liye)
RUN useradd -r -u 1001 appuser
USER appuser

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]