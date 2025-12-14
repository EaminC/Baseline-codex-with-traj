FROM maven:3.9.9-eclipse-temurin-17

WORKDIR /workspace/alibaba_fastjson2

COPY . .

# Install the project into the local Maven repo without running tests to keep the image slim.
RUN mvn --batch-mode -DskipTests -Dmaven.javadoc.skip=true -Dgpg.skip=true install

CMD ["/bin/bash"]
