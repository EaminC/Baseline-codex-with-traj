# Dev shell for Anvil (Rust + Verus + Go/kind-ready)
FROM ubuntu:22.04

ARG RUST_TOOLCHAIN=1.91.0
ARG VERUS_RELEASE=0.2025.11.30.840fa61
ARG GO_VERSION=1.20.14

ENV DEBIAN_FRONTEND=noninteractive \
    VERUS_DIR=/opt/verus \
    GOPATH=/go \
    PATH=/root/.cargo/bin:/usr/local/go/bin:/go/bin:/opt/verus:${PATH}

SHELL ["/bin/bash", "-c"]

# Base build tools and common dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl git wget unzip pkg-config libssl-dev ca-certificates python3 \
 && rm -rf /var/lib/apt/lists/*

# Rust toolchain (matches rust-toolchain.toml)
RUN curl --proto '=https' --tlsv1.2 --retry 10 --retry-connrefused -fsSL "https://sh.rustup.rs" \
    | sh -s -- --default-toolchain none -y \
 && source "$HOME/.cargo/env" \
 && rustup toolchain install "${RUST_TOOLCHAIN}" \
 && rustup default "${RUST_TOOLCHAIN}"

# Go toolchain (for kind-based e2e flow)
RUN wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
 && rm -rf /usr/local/go \
 && tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz" \
 && rm "go${GO_VERSION}.linux-amd64.tar.gz" \
 && mkdir -p "${GOPATH}/bin"

# Verus release (matches CI)
RUN wget -q "https://github.com/verus-lang/verus/releases/download/release%2F${VERUS_RELEASE}/verus-${VERUS_RELEASE}-x86-linux.zip" \
 && unzip -q "verus-${VERUS_RELEASE}-x86-linux.zip" \
 && rm "verus-${VERUS_RELEASE}-x86-linux.zip" \
 && mv verus-x86-linux "${VERUS_DIR}" \
 && ln -s "${VERUS_DIR}" /verus

WORKDIR /anvil
COPY . /anvil

# Pre-fetch Cargo deps so the shell is ready to build
RUN source "$HOME/.cargo/env" && cargo fetch

CMD ["/bin/bash"]
