FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt /app/

# Install system dependencies if needed, then python packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
 && pip install --no-cache-dir -r requirements.txt \
 && apt-get remove -y git \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# Copy entire repo content
COPY . /app

# Default command: bash shell
CMD ["/bin/bash"]
