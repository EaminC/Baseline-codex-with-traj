FROM python:3.8-slim

# System dependencies for Python builds and the R stack used by rpy2/eva
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        r-base r-base-dev \
        build-essential git wget ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/flex

# Install Python dependencies first for better build caching
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Bring in the full repo
COPY . .

# Ensure the tool modules are on the Python path when you shell in
ENV PYTHONPATH=/workspace/flex/tool:/workspace/flex/tool/src:${PYTHONPATH}

CMD ["/bin/bash"]
