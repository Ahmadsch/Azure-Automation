# build
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY app/pom.xml .
COPY app/.mvn .mvn
COPY app/mvnw .
RUN ./mvnw -q -DskipTests dependency:go-offline

COPY app/src src
RUN ./mvnw -q -DskipTests package

# run
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /src/target/*.jar app.jar

ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
