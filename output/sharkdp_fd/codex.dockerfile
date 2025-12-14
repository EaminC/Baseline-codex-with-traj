# syntax=docker/dockerfile:1.6

FROM rust:1.90-bookworm AS builder
WORKDIR /workspace

# Build dependencies for compiling fd
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential ca-certificates pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Pre-fetch dependencies using minimal context to leverage Docker layer caching
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && touch src/main.rs
RUN cargo fetch

# Copy the full repository and install the binary
COPY . .
RUN cargo install --path . --root /usr/local

FROM debian:bookworm-slim
WORKDIR /workspace

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates bash \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local /usr/local
COPY --from=builder /workspace /workspace

ENV PATH="/usr/local/bin:${PATH}"
CMD ["/bin/bash"]
