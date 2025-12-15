FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime

# Set environment variables for python
ENV DEBIAN_FRONTEND=noninteractive

# Install required apt dependencies
RUN apt-get update && apt-get install -y \
    python3.6 \
    python3-pip \
    python3.6-dev \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set python3.6 as default python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1

# Upgrade pip
RUN python -m pip install --upgrade pip

# Copy current repo to /RelTR
WORKDIR /RelTR
COPY . /RelTR

# Install python dependencies
RUN pip install matplotlib scipy
RUN pip install -U 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'

# Build the code computing box intersection native extension
RUN cd lib/fpn && sh make.sh

# Default to bash shell
CMD ["/bin/bash"]
