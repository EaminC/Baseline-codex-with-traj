FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Set working directory in container
WORKDIR /nlohmann_json

# Copy repository contents into container
COPY . /nlohmann_json

# Create build directory and build the project
RUN mkdir -p build && cd build && cmake .. && cmake --build .

# Start with bash shell at repo root
CMD ["/bin/bash"]
