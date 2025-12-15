FROM ubuntu:22.04

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    git \
    && python3 -m pip install --no-cache-dir conan \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /catch2

# Copy repo files into container
COPY . /catch2

# Configure conan and build
RUN conan profile new default --detect || true && \
    conan profile update settings.compiler.libcxx=libstdc++11 default && \
    conan install . --build=missing && \
    cmake -B build -S . && \
    cmake --build build && \
    cmake --install build

# Default to bash shell
CMD ["/bin/bash"]
