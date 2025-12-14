FROM rust:1-bookworm

WORKDIR /usr/src/tracing

# Build tooling and common native dependencies used by the workspace.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential \
      pkg-config \
      ca-certificates \
      git \
      libssl-dev \
      libclang-dev \
      cmake \
    && rm -rf /var/lib/apt/lists/*

COPY . .

# Pre-fetch and compile the full workspace so the image is ready to develop or test.
RUN cargo fetch && cargo build --workspace --all-targets

# Drop into the repository root when the container starts.
CMD ["/bin/bash"]
