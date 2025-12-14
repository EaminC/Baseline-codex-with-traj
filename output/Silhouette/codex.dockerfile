FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    make \
    memcached \
    openssh-client \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    qemu-system-x86 \
    tk-dev \
    xz-utils \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/Silhouette

COPY . /workspace/Silhouette

RUN chmod 600 codebase/scripts/fs_conf/sshkey/fast25_ae_vm \
    && chmod 644 codebase/scripts/fs_conf/sshkey/fast25_ae_vm.pub

RUN python3 -m pip install --no-cache-dir \
    pymemcache \
    memcache \
    psutil \
    pytz \
    qemu.qmp \
    intervaltree \
    aenum \
    netifaces \
    prettytable \
    tqdm \
    numpy \
    matplotlib

RUN make -C codebase/tools/disk_content

CMD ["/bin/bash"]
