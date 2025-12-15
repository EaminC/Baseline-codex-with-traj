FROM ubuntu:22.04

# Set argument for Verus version (hardcoded from README)
ARG VERUS_VER=release/rolling/0.2025.11.30.840fa61

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gcc \
    pkg-config \
    libssl-dev \
    unzip \
    build-essential \
    cmake \
    git \
 && rm -rf /var/lib/apt/lists/*

# Install Rust using rustup (default minimal install)
RUN curl --proto '=https' --tlsv1.2 --retry 10 --retry-connrefused -fsSL https://sh.rustup.rs | sh -s -- --default-toolchain none -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Verus
RUN wget -q "https://github.com/verus-lang/verus/releases/download/${VERUS_VER}/verus-${VERUS_VER}-x86-linux.zip" \
    && unzip "verus-${VERUS_VER}-x86-linux.zip" \
    && rm "verus-${VERUS_VER}-x86-linux.zip"
ENV PATH="/verus-x86-linux:${PATH}"

# Set workdir
WORKDIR /anvil

# Copy full repo into container
COPY . /anvil

# Build repo using build.sh script
RUN chmod +x ./build.sh && ./build.sh

# Start with bash shell in /anvil (repo root)
ENTRYPOINT ["/bin/bash"]
