# syntax=docker/dockerfile:1

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        clang \
        cmake \
        git \
        make \
        pkg-config \
        python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/ponyc

COPY . .

ENV CC=clang \
    CXX=clang++

RUN make libs build_flags="-j$(nproc)" \
    && make configure \
    && make build build_flags="-j$(nproc)" \
    && make install

CMD ["/bin/bash"]
