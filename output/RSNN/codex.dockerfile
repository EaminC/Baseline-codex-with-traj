FROM python:3.10-slim

ARG WORKDIR=/workspace/RSNN

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONPATH=${WORKDIR}

WORKDIR ${WORKDIR}

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libatlas-base-dev \
    libhdf5-dev \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . .

CMD ["/bin/bash"]
