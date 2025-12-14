FROM eclipse-temurin:17-jdk

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ARG USER=mockito
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${USER} \
    && useradd -m -u ${UID} -g ${GID} ${USER}

WORKDIR /workspace/mockito

COPY . /workspace/mockito

RUN chown -R ${USER}:${USER} /workspace/mockito

USER ${USER}

ENV GRADLE_USER_HOME=/home/${USER}/.gradle

# Prime the Gradle wrapper so the image is ready for interactive work.
RUN ./gradlew --no-daemon --version

CMD ["/bin/bash"]
