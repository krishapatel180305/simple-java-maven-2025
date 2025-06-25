FROM maven:3.8.5-openjdk-11
COPY . /app
WORKDIR /app
RUN mvn clean package
