# Etapa 1: build
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app

# 1) Copiar pom y descargar dependencias (caché)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 2) Copiar código y compilar sin tests
COPY src ./src
RUN mvn clean package -DskipTests -B

# Etapa 2: runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copiar el JAR generado
COPY --from=builder /app/target/*.jar app.jar

# Exponer el puerto (ajusta si tu app usa otro)
EXPOSE 8080

# Comando de arranque
ENTRYPOINT ["java","-jar","/app/app.jar"]
