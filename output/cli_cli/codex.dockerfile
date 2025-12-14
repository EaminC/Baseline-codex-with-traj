# syntax=docker/dockerfile:1

FROM golang:1.25-bookworm AS builder

ENV CGO_ENABLED=1 \
    GOTOOLCHAIN=auto

WORKDIR /workspace

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git && \
    rm -rf /var/lib/apt/lists/*

COPY . .

RUN go mod download

# Build and stage a full install (binary, manpages, completions).
RUN make install DESTDIR=/opt/gh-install

FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        git \
        less && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/gh-install/usr/local/ /usr/local/
COPY --from=builder /workspace /workspace

WORKDIR /workspace
ENV PATH="/usr/local/bin:${PATH}"

CMD ["/bin/bash"]
