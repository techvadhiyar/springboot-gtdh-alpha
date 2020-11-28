# Stage - Build
# Did not officially tag this stage
FROM maven:3.5-jdk-8-alpine

WORKDIR /app

COPY pom.xml .

RUN mvn -e -B dependency:resolve

COPY src ./src

RUN mvn -e -B package

WORKDIR /app

# COPY ./target/*.jar /app.jar - does not work since it is meant to work on your local machine and not inside the container.
# Explanation: https://stackoverflow.com/questions/60573551/copy-or-add-command-in-dockerfile-fails-to-find-jar-file-for-springboot-applicat
RUN cp ./target/*.jar /app.jar

CMD ["java", "-jar", "/app.jar"]


# Must watch - https://www.youtube.com/watch?v=t2cDtDrNqc8 - Best Practices from Dockercon 2019