FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        make \
        cmake \
        sudo \
        libssl-dev \
        libgoogle-perftools-dev \
        google-perftools \
        libxxhash-dev \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/Metis
COPY . /opt/Metis

RUN make && make install

CMD ["/bin/bash"]
