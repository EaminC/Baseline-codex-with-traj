FROM python:3.6-slim

# Install dependencies for conda and system
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh
ENV PATH=$CONDA_DIR/bin:$PATH

WORKDIR /app

# Copy repository contents
COPY . /app

# Create conda environment with Python 3.6 and install Python dependencies
RUN conda create -n flex-env python=3.6 -y && \
    /bin/bash -c "source $CONDA_DIR/etc/profile.d/conda.sh && conda activate flex-env && pip install -r requirements.txt"

# Activate conda environment on container start
SHELL ["/bin/bash", "-c"]
CMD ["/bin/bash"]
