FROM ubuntu:latest

# Install build dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential cmake ninja-build meson pkg-config \
    python3 python3-pip git curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /work

# Copy repo contents
COPY . /work

# Build and install
RUN make && make install

# Default shell
ENTRYPOINT ["/bin/bash"]
CMD ["-l"]
