FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    meson \
    ninja-build \
    pkg-config \
    autoconf \
    kernel-package \
    libncurses5-dev \
    bison \
    flex \
    libssl-dev \
    fio \
    python2 \
    libelf-dev \
    rsync \
    zstd \
    udev \
    sudo \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /rfuse

# Copy all files from current context to /rfuse
COPY . /rfuse

# Run install scripts for libfuse and librfuse
RUN chmod +x lib/libfuse/libfuse_install.sh lib/librfuse/librfuse_install.sh 
RUN ./lib/libfuse/libfuse_install.sh && ./lib/librfuse/librfuse_install.sh

CMD ["/bin/bash"]
