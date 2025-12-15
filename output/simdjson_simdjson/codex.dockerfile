FROM ubuntu:22.04

# Set environment variables for non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive

# Install build tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    nano \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Set working directory in container
WORKDIR /simdjson_simdjson

# Copy all repo files to container
COPY . /simdjson_simdjson/

# Create build dir and build project
RUN mkdir build && cd build && \
    cmake -DBUILD_SHARED_LIBS=OFF -DSIMDJSON_IMPLEMENTATION=icelake;haswell;westmere;fallback .. && \
    make -j$(nproc)

# Default to bash shell at repo root
CMD ["/bin/bash"]
