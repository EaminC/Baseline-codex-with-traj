# Python 3.11 base image keeps parity with the recommended environment
FROM python:3.11-slim

# OS dependencies for building Python wheels (e.g., lightgbm) and pulling submodules
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Work from the repository root inside the image
WORKDIR /workspace/Baleen

# Copy source and initialize the bundled submodule if present
COPY . /workspace/Baleen
RUN if [ -d .git ]; then git submodule update --init --recursive; fi

# Install Python dependencies needed to run the simulator and notebooks
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r BCacheSim/install/requirements.txt

# Ensure Python can import the repository modules from anywhere
ENV PYTHONPATH=/workspace/Baleen

# Drop into a shell at the repository root by default
CMD ["/bin/bash"]
