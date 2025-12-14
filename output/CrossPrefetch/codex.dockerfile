# Development container for CrossPrefetch
FROM ubuntu:20.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

# Base toolchain and libs that the repo's scripts expect (mirrors scripts/install_packages.sh and kernel deps)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential git curl wget ca-certificates sudo \
    python3 python3-pip python3-setuptools python3-dev python3-venv \
    bc bison flex libssl-dev libelf-dev libncurses-dev libdpkg-dev kernel-package \
    numactl libnuma-dev libaio-dev libjemalloc-dev \
    cmake pkg-config \
    libboost-dev libboost-thread-dev libboost-system-dev libboost-program-options-dev \
    libconfig-dev uthash-dev cscope msr-tools \
    libmpich-dev mpich \
    libzstd-dev liblz4-dev libsnappy-dev libgflags-dev zlib1g-dev libbz2-dev libevent-dev \
    default-jdk maven unzip && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir zplot psutil

WORKDIR /opt/CrossPrefetch
COPY . /opt/CrossPrefetch

# Prep directories referenced by setvars.sh and make git happy when run as root
RUN mkdir -p /opt/CrossPrefetch/KERNEL /opt/CrossPrefetch/mountdir /mnt/pmemdir && \
    git config --global --add safe.directory /opt/CrossPrefetch

# Persist the environment expected by scripts/setvars.sh
ENV NVMBASE=/opt/CrossPrefetch \
    BASE=/opt/CrossPrefetch \
    OS_RELEASE_NAME=bionic \
    VER=5.14.0 \
    KERN_SRC=/opt/CrossPrefetch/linux-5.14.0 \
    SHELL=/bin/bash \
    QEMU_IMG=/opt/CrossPrefetch \
    QEMU_IMG_FILE=/opt/CrossPrefetch/qemu-image-fresh.img \
    MOUNT_DIR=/opt/CrossPrefetch/mountdir \
    QEMUMEM=40 \
    KERNEL=/opt/CrossPrefetch/KERNEL \
    PAPER=/opt/CrossPrefetch/Prop3/crossprefetch/graphs/ \
    PAPERGRAPHS=/opt/CrossPrefetch/Prop3/crossprefetch/graphs/SC \
    MACHINE_NAME=ASPLOS \
    OUTPUT_FOLDER=/opt/CrossPrefetch/results/ASPLOS/CAMERA-OPT-FINAL-TEST \
    OUTPUT_GRAPH_FOLDER=/opt/CrossPrefetch/results/ASPLOS/CAMERA-OPT-FINAL-TEST \
    OUTPUTDIR=/opt/CrossPrefetch/results/ASPLOS/CAMERA-OPT-FINAL-TEST \
    LINUX_SCALE_BENCH=/opt/CrossPrefetch/linux-scalability-benchmark \
    APPBENCH=/opt/CrossPrefetch/appbench \
    APPS=/opt/CrossPrefetch/appbench/apps \
    SHARED_LIBS=/opt/CrossPrefetch/shared_libs \
    PREDICT_LIB_DIR=/opt/CrossPrefetch/shared_libs/simple_prefetcher \
    QUARTZ=/opt/CrossPrefetch/shared_libs/quartz \
    SCRIPTS=/opt/CrossPrefetch/scripts \
    UTILS=/opt/CrossPrefetch/utils \
    RUN_SCRIPTS=/opt/CrossPrefetch/scripts/run \
    QUARTZSCRIPTS=/opt/CrossPrefetch/shared_libs/quartz/scripts \
    SHARED_DATA=/opt/CrossPrefetch/dataset \
    APPPREFIX="/usr/bin/time -v" \
    TEST_TMPDIR=/mnt/pmemdir \
    PATH=/opt/CrossPrefetch/scripts:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# PARA is dynamic so set it per shell; also pick up env in interactive shells by default
RUN echo 'export PARA="-j$(nproc)"' > /etc/profile.d/crossprefetch.sh && \
    echo 'source /etc/profile.d/crossprefetch.sh' >> /etc/bash.bashrc

CMD ["/bin/bash"]
