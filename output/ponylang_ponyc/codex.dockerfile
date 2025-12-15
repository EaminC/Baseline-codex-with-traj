FROM ubuntu:latest

# Install required dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory to repository root
WORKDIR /root/ponyc

# Copy current repository files into the container
COPY . .

# Build the LLVM libraries (only needed once)
RUN make libs

# Configure the build
RUN make configure

# Build the compiler and runtime
RUN make build

# Set default shell to bash
CMD ["/bin/bash"]
