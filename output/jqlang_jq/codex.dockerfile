FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      autoconf \
      automake \
      libtool \
      pkg-config \
      flex \
      bison \
      python3 \
      ca-certificates \
      git \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/jq
COPY . /workspace/jq

RUN autoreconf -i \
 && ./configure --with-oniguruma=builtin \
 && make -j"$(nproc)" \
 && make check \
 && make install

CMD ["/bin/bash"]
