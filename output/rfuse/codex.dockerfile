FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Base toolchain and dependencies for building the kernel, drivers, and userspace libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential make ninja-build meson pkg-config autoconf kernel-package \
    libncurses5-dev bison flex libssl-dev libelf-dev bc cpio kmod \
    fio python2 rsync zstd udev \
    ca-certificates curl git \
    && rm -rf /var/lib/apt/lists/*

# Place the repository at /rfuse and start shells there by default
WORKDIR /rfuse
COPY . /rfuse

# Ensure dynamic linker can find installed libs when built in the container
ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}

CMD ["/bin/bash"]
