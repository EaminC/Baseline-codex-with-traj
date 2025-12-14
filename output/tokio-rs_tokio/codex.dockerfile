# syntax=docker/dockerfile:1
FROM rust:1.78-bullseye

# Build tooling commonly needed for Tokio development
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        pkg-config \
        libssl-dev \
        clang \
        cmake \
        ca-certificates \
        git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/tokio

# Copy the repository into the image
COPY . .

# Pre-fetch dependencies so the image is ready to build or test
RUN cargo fetch --all-features

# Drop into a shell at the repository root by default
CMD ["/bin/bash"]
