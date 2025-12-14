# syntax=docker/dockerfile:1
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        git \
        python3 \
        python3-pip \
        python3-bcc \
        python3-scapy \
        python3-pyroute2 \
        build-essential \
        bison \
        flex \
        libfl-dev \
        clang \
        llvm \
        libelf-dev \
        pkg-config \
        iproute2 \
        netcat \
        linux-headers-generic && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/P4Ctl
COPY . /opt/P4Ctl

RUN pip3 install --no-cache-dir "scapy==2.4.5" "pyroute2>=0.6.0"

RUN make -C compiler clean netcl && \
    ln -sf /opt/P4Ctl/compiler/netcl-compile /usr/local/bin/netcl-compile

# Default locations for the Tofino SDE; override at runtime if different.
ENV PYTHONPATH="/opt/P4Ctl/switch:${PYTHONPATH}" \
    SDE="/opt/bf-sde-9.7.0" \
    SDE_INSTALL="/opt/bf-sde-9.7.0/install"

ENTRYPOINT ["/bin/bash"]
