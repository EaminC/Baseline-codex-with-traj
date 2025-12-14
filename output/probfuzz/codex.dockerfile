FROM python:2.7

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

WORKDIR /app

# System deps: Java for ANTLR, bc for scripts, and compilers for building pystan/torch.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openjdk-8-jre-headless \
      openjdk-8-jdk-headless \
      bc \
      wget \
      gfortran && \
    rm -rf /var/lib/apt/lists/*

# Copy repository and install Python dependencies (Python 2 stack).
COPY . /app
RUN pip install --no-cache-dir \
      antlr4-python2-runtime \
      six \
      astunparse \
      ast \
      pystan \
      edward \
      pyro-ppl==0.2.1 \
      tensorflow==1.5.0 \
      pandas && \
    pip install --no-cache-dir \
      http://download.pytorch.org/whl/cpu/torch-0.4.0-cp27-cp27mu-linux_x86_64.whl && \
    wget -O language/antlr/antlr-4.7.1-complete.jar \
      http://www.antlr.org/download/antlr-4.7.1-complete.jar && \
    cd language/antlr && \
    bash ./run.sh && \
    cd /app && \
    python check.py

# Drop into a shell at the repo root by default.
CMD ["/bin/bash"]
