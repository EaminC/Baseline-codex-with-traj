FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    ninja-build \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/fmt

COPY . .

RUN cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DFMT_TEST=OFF \
  && cmake --build build --parallel \
  && cmake --install build \
  && rm -rf build

ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

CMD ["/bin/bash"]
