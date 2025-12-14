FROM jruby:9.4-jdk17

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    JAVA_HOME=/opt/java/openjdk \
    LOGSTASH_SOURCE=1 \
    LOGSTASH_PATH=/usr/src/logstash \
    GRADLE_USER_HOME=/usr/src/logstash/.gradle

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      libffi-dev \
      libssl-dev \
      libyaml-dev \
      pkg-config \
      python3 \
      python3-distutils \
      unzip \
      zip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/logstash

COPY . .

RUN chmod +x gradlew && \
    ./gradlew --no-daemon installDevelopmentGems installDefaultGems

CMD ["/bin/bash"]
