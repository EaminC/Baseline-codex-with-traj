FROM python:3.12-slim-bullseye

# Install git and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the entire repo into the container
COPY . /app

# Install the repo in editable mode (dev mode)
RUN pip install --no-cache-dir -e .

# Default command: bash shell
CMD ["/bin/bash"]
