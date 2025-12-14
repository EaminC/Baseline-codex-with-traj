FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    git \
    pkg-config \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /nlohmann_json

COPY . /nlohmann_json

RUN cmake -S . -B build -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DJSON_BuildTests=OFF \
    -DNLOHMANN_JSON_INSTALL=ON \
 && cmake --build build \
 && cmake --install build \
 && rm -rf build

CMD ["/bin/bash"]
