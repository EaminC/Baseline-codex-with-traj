FROM openjdk:17
WORKDIR /app
COPY . /app
RUN ./gradlew build
CMD ["/bin/bash"]
