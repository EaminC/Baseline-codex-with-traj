FROM rust:1-bookworm

# Build dependencies for ripgrep (PCRE2 support, build tooling).
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libpcre2-dev \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# Build and install ripgrep with PCRE2 enabled.
RUN cargo build --release --locked --features pcre2 \
  && cargo install --path . --locked --features pcre2

ENV PATH="/usr/local/cargo/bin:${PATH}"
CMD ["/bin/bash"]
