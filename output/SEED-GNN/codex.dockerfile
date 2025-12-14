FROM pytorch/pytorch:2.0.0-cpu

WORKDIR /workspace/SEED-GNN

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1 \
    && pip install --no-cache-dir \
        torch-scatter==2.1.1 \
        torch-sparse==0.6.17 \
        torch-cluster==1.6.1 \
        torch-spline-conv==1.2.2 \
        -f https://data.pyg.org/whl/torch-2.0.0+cpu.html \
    && pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PYTHONPATH=/workspace/SEED-GNN:${PYTHONPATH}

CMD ["/bin/bash"]
