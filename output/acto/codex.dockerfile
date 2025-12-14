# Base image with Python 3.12 for the Acto tooling
FROM python:3.12-slim

ARG GO_VERSION=1.22.7
ARG KIND_VERSION=v0.20.0
ARG KUBECTL_VERSION=v1.27.0

# Install system dependencies, Go toolchain, kind, and kubectl
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        build-essential \
        gcc \
        make && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

RUN curl -fsSLo /usr/local/bin/kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64" && \
    chmod +x /usr/local/bin/kind && \
    curl -fsSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x /usr/local/bin/kubectl

WORKDIR /workspace/acto

# Copy the repository and install Python dependencies
COPY . .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Build native Go shared libraries and install the project in editable mode
RUN make && \
    pip install --no-cache-dir -e .

# Default to an interactive shell at the repository root
CMD ["/bin/bash"]
