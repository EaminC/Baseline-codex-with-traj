# syntax=docker/dockerfile:1
FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash \
       ca-certificates \
       curl \
       git \
       openjdk-17-jdk \
       maven \
    && rm -rf /var/lib/apt/lists/*

# Make Java and Maven available and prefer bash for shells.
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"
SHELL ["/bin/bash", "-c"]

WORKDIR /workspace/gluetest

# Copy repository contents into the image.
COPY . .

# Python tooling for running the translated test suites.
RUN pip install --no-cache-dir pytest

# Ensure translated sources are on the module search path.
ENV PYTHONPATH=/workspace/gluetest/commons-cli-python/src:/workspace/gluetest/commons-csv-python/src

# Drop into a shell at container start.
CMD ["/bin/bash"]
