# Stage - Build
# Did not officially tag this stage
FROM maven:3.5-jdk-8-alpine

WORKDIR /app

COPY pom.xml .

RUN mvn -e -B dependency:resolve

COPY src ./src

RUN mvn -e -B package

# needed to add this command for AWS Bean Stalk to build the docker image...otherwise errors out...
# https://askinglot.com/what-is-the-difference-between-port-80-and-8080#:~:text=Port%2080%20is%20the%20default,not%20need%20to%20specify%20it.
# using /tcp does work so following a recommendation to remove /tcp from the below expose command..
# EXPOSE 80/tcp
EXPOSE 80

# Stage - Generate Image
# FROM openjdk:8-jre-alpine - having this breaks the RUN command, hence commented
WORKDIR /app

# COPY ./target/*.jar /app.jar - does not work since it is meant to work on your local machine and not inside the container.
# Explanation: https://stackoverflow.com/questions/60573551/copy-or-add-command-in-dockerfile-fails-to-find-jar-file-for-springboot-applicat
RUN cp ./target/*.jar /app.jar

CMD ["java", "-jar", "/app.jar"]


# Must watch - https://www.youtube.com/watch?v=t2cDtDrNqc8 - Best Practices from Dockercon 2019