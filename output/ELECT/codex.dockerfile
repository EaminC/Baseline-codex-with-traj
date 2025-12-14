FROM ubuntu:22.04

SHELL ["/bin/bash", "-lc"]

# Install system dependencies needed to build and run ELECT and its helpers.
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-11-jdk openjdk-11-jre \
        ant ant-optional maven \
        clang llvm gcc g++ make \
        libisal-dev \
        python3 python3-pip \
        ansible bc \
        curl jq rsync openssh-client \
        git ca-certificates netbase && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"
ENV ELECT_HOME=/workspace/ELECT

WORKDIR ${ELECT_HOME}

# Copy the repository into the image.
COPY . ${ELECT_HOME}

# Python packages used by the helper scripts.
RUN pip3 install --no-cache-dir cassandra-driver numpy scipy

# Default to an interactive shell at the repo root.
CMD ["/bin/bash"]
