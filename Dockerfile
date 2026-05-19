FROM openjdk:27-ea-windowsservercore-ltsc2025

WORKDIR /app

COPY target/demo-workshop-2.1.3.jar ttrend.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","ttrend.jar"]