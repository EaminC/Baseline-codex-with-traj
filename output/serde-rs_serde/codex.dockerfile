# syntax=docker/dockerfile:1

FROM rust:1.81-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Use the faster sparse protocol when pulling crates.
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

# Place the repository at the container root and compile the full workspace.
WORKDIR /workspace/serde-rs_serde
COPY . .
RUN cargo build --workspace --all-targets --release

CMD ["/bin/bash"]
