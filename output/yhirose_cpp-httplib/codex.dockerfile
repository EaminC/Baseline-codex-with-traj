FROM ubuntu:22.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install essential build tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libssl-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    pkg-config \
    ca-certificates \
    curl \
    nano \
    bash \
 && rm -rf /var/lib/apt/lists/*

# Set working directory to the repo root
WORKDIR /app

# Copy all repo files into container
COPY . /app

# Build and install the project
RUN mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build . --target install

# Set shell to bash and start at repo root
CMD ["/bin/bash"]
