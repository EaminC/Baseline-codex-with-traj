FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    ant \
    cmake \
    build-essential \
    git \
    wget \
    unzip \
    pkg-config \
    libgmp-dev \
    libgmpxx4ldbl \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME for JDK 8
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Copy repo files into container
COPY . /SymMC

WORKDIR /SymMC

# Build Enhanced_Kodkod
RUN cd Enhanced_Kodkod && ./build.sh

# Build Enumerator_Estimator
RUN cd Enumerator_Estimator && ./build.sh

# Default to bash shell
CMD ["/bin/bash"]
