FROM rust:1.85

# Install prerequisite packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh xz-utils liblz4-tool musl-tools brotli zstd g++ \
    && rm -rf /var/lib/apt/lists/*

# Set workdir to repo root
WORKDIR /usr/src/ripgrep

# Copy repo into image
COPY . .

# Build release binary
RUN cargo build --release

# Default to bash shell at repo root
CMD ["/bin/bash"]
