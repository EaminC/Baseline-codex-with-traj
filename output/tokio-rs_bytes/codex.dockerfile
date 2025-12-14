FROM rust:1-bullseye

# Build dependencies commonly needed by Rust projects.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        pkg-config \
        ca-certificates \
        git \
    && rm -rf /var/lib/apt/lists/*

# Work out of the repository root.
WORKDIR /workspace

# Prime the dependency cache.
COPY Cargo.toml Cargo.lock ./
RUN cargo fetch --locked

# Copy the full source and build so the crate is ready to use.
COPY . .
RUN cargo build --locked --all-features

# Drop into a bash shell at the repository root.
CMD ["/bin/bash"]
