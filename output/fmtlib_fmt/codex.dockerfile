FROM ubuntu:22.04

# Set noninteractive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    git \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /fmtlib_fmt

# Copy entire repo
COPY . /fmtlib_fmt

# Create build directory
RUN mkdir build
WORKDIR /fmtlib_fmt/build

# Run cmake and build
RUN cmake -GNinja .. && ninja && ninja install

# Set working directory back to repo root
WORKDIR /fmtlib_fmt

# Start bash shell
ENTRYPOINT ["/bin/bash"]
