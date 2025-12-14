FROM python:3.8-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /workspace/RelTR

# System build tools and lightweight image/video libraries for deps like pycocotools and matplotlib
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    git \
    libgl1 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Core Python deps (CPU-only PyTorch 1.6 per project README)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    torch==1.6.0 \
    torchvision==0.7.0 \
    -f https://download.pytorch.org/whl/cpu/torch_stable.html

# Remaining Python stack
RUN pip install --no-cache-dir \
    cython \
    numpy \
    scipy \
    matplotlib \
    Pillow \
    tqdm \
    pycocotools

# Copy project into container
COPY . .

# Ensure in-repo imports resolve without installing a wheel
ENV PYTHONPATH=/workspace/RelTR

# Build the Cython box intersection extension
RUN cd lib/fpn && ./make.sh

# Default to an interactive shell at the repo root
CMD ["/bin/bash"]
