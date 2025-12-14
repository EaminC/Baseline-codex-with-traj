FROM python:3.7-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        libglib2.0-0 \
        libgl1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/Lottory

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["/bin/bash"]
