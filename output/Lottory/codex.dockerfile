FROM python:3.7-buster

# Install OS dependencies and clean cached files
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        git \
        wget && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /Lottory

# Copy entire repo contents
COPY . /Lottory

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Default to bash shell at container start
CMD ["/bin/bash"]
