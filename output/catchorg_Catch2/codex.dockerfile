FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        ninja-build \
        git \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/catchorg_Catch2

COPY . .

RUN cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCATCH_BUILD_TESTING=OFF && \
    cmake --build build && \
    cmake --install build

CMD ["/bin/bash"]
