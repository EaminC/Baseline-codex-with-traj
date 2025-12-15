FROM ubuntu:22.04

# Set environment variables to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install packages
RUN apt-get update && apt-get install -y \
    gcc g++ git vim build-essential m4 autoconf bison flex cmake make \
    mtd-tools libssl-dev libfuse-dev google-perftools libgoogle-perftools-dev \
    libnfsidmap-dev libtirpc-dev libkrb5-3 libkrb5-dev libk5crypto3 \
    libgssapi-krb5-2 libgssglue1 libdbus-1-3 libattr1-dev libacl1-dev dbus \
    libdbus-1-dev libcap-dev libjemalloc-dev uuid-dev libblkid-dev xfslibs-dev \
    libwbclient-dev rpm2cpio libaio-dev libibverbs-dev librdmacm-dev rpcbind \
    nfs-common libboost-all-dev liburcu-dev libxxhash-dev nilfs-tools rename \
    mtd-utils python3-pip python3-numpy python3-scipy python3-matplotlib \
    && rm -rf /var/lib/apt/lists/*

# Set workdir to repo root
WORKDIR /Metis

# Copy everything from the current context to container's /Metis
COPY . /Metis

# Build and install the repo
RUN make && make install

# Set entrypoint and default command
ENTRYPOINT ["/bin/bash"]
