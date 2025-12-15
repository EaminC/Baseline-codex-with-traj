FROM openjdk:11

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ant \
    maven \
    clang \
    llvm \
    python3 \
    python3-pip \
    jq \
    bc \
    curl \
    ssh \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# Install python packages
RUN pip3 install cassandra-driver numpy scipy

# Set working directory
WORKDIR /ELECT

# Copy all files
COPY . /ELECT

# Build ELECT prototype
WORKDIR /ELECT/src/elect
RUN ant realclean && ant -Duse.jdk11=true

# Build YCSB benchmark tool
WORKDIR /ELECT/scripts/ycsb
RUN mvn clean package

# Default working directory
WORKDIR /ELECT

# Start in bash
CMD ["/bin/bash"]
