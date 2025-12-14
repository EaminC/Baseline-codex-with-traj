# Lightweight dev image for simdjson: builds & installs the library, then drops
# you into /workspace/simdjson with bash.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        ninja-build \
        python3 \
        pkg-config \
        ca-certificates \
        git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/simdjson

# Copy the repository into the image.
COPY . .

# Configure, build, and install simdjson system-wide.
RUN cmake -S . -B build -G Ninja -D CMAKE_BUILD_TYPE=Release \
    && cmake --build build --target install

# Default to an interactive shell at the repo root.
CMD ["/bin/bash"]
