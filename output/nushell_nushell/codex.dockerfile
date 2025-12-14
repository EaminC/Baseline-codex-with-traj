FROM rust:1.90-bookworm

ARG DEBIAN_FRONTEND=noninteractive

# System packages needed for native builds (openssl, git bindings, pkg-config, clang) and TLS support.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        pkg-config \
        libssl-dev \
        libgit2-dev \
        libssh2-1-dev \
        clang \
        cmake \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/nushell

COPY . .

# Build and install Nushell from this checkout using the locked dependency set.
RUN cargo install --locked --path . --root /usr/local \
    && cargo clean

ENV PATH="/usr/local/bin:${PATH}"

# Drop into an interactive shell at the repository root by default.
CMD ["/bin/bash"]
