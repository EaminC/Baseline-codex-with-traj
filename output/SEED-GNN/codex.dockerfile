FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install system dependencies and python3
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 python3.10-distutils python3-pip python3.10-venv \
    build-essential git curl ca-certificates wget && \
    ln -sf /usr/bin/python3.10 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install PyTorch 2.0.0 with CUDA 11.7 from official repo
RUN pip install torch==2.0.0+cu117 torchvision==0.15.1+cu117 torchaudio==2.0.1 --extra-index-url https://download.pytorch.org/whl/cu117

# Install PyTorch Geometric dependencies separately
RUN pip install torch-scatter==2.1.1 torch-sparse==0.6.17 torch-cluster==1.6.1 torch-spline-conv==1.2.2 -f https://data.pyg.org/whl/torch-2.0.0+cu117.html

# Set workdir
WORKDIR /app

# Copy repo contents
COPY . /app

# Install python dependencies from requirements.txt
RUN pip install -r requirements.txt

# Use bash shell by default
CMD ["/bin/bash"]
