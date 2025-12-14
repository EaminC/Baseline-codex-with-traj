FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    pkg-config \
    python3 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/zstd
COPY . .

RUN set -eux; \
    make -j"$(nproc)"; \
    make install; \
    ldconfig

WORKDIR /opt/zstd
ENTRYPOINT ["/bin/bash"]
