FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Build tooling and common deps for the library (including OpenSSL support).
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    pkg-config \
    libssl-dev \
    ca-certificates \
    git \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Copy the repository into the image and build/install it.
WORKDIR /opt/httplib/src
COPY . .
RUN cmake -S . -B /opt/httplib/build -DCMAKE_BUILD_TYPE=Release \
    && cmake --build /opt/httplib/build --parallel \
    && cmake --install /opt/httplib/build

# Drop into a shell at the repo root when the container starts.
WORKDIR /opt/httplib/src
CMD ["/bin/bash"]
