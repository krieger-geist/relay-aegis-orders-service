FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -DskipTests package

FROM eclipse-temurin:21-jre
RUN groupadd --system app && useradd --system --gid app --home /app app
WORKDIR /app
COPY --from=build /build/target/orders-service-1.0.0.jar /app/orders-service.jar
USER app
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/orders-service.jar"]
