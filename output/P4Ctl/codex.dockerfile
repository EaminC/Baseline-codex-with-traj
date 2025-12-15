FROM python:3.7-slim

# Install build dependencies
RUN apt-get update && apt-get install -y \
    bison \
    flex \
    g++ \
    make \
    sudo \
    iproute2 \
    net-tools \
    tcpdump \
    vim \
    less \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir scapy

# Create app directory
WORKDIR /app

# Copy all files
COPY . /app

# Build the netcl compiler
RUN make -C compiler netcl

# Set environment variables for Tofino SDE
ENV SDE=/bf-sde-9.7.0/
ENV SDE_INSTALL=/bf-sde-9.7.0/install

# Default to bash shell with repo root as working directory
CMD ["/bin/bash"]
