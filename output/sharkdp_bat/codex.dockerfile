FROM rust:1-bookworm

SHELL ["/bin/bash", "-c"]

WORKDIR /app

COPY . /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        libssl-dev \
        pkg-config \
    && rm -rf /var/lib/apt/lists/* \
    && cargo install --locked --path . \
    && bat --version

ENV PATH="/usr/local/cargo/bin:${PATH}"

CMD ["/bin/bash"]
