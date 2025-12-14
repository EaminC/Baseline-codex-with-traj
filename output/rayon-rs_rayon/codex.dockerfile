FROM rust:1.80-bookworm

ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      pkg-config \
      ca-certificates \
      libx11-dev \
      libxi-dev \
      libxrandr-dev \
      libxinerama-dev \
      libxcursor-dev \
      libgl1-mesa-dev \
      libosmesa6-dev \
      libwayland-dev \
      libxkbcommon-dev \
      libudev-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/rayon

COPY . .

RUN cargo fetch

RUN cargo build --workspace --all-targets

CMD ["/bin/bash"]
