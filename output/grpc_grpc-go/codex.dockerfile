# Dev image to drop into a shell at the repo root with grpc-go built using Go tip.
FROM golang:1.22-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/grpc_grpc-go
COPY . .

# Install the Go tip toolchain to satisfy the go 1.24 module directive.
RUN go install golang.org/dl/gotip@latest \
    && /go/bin/gotip download

# Prefer the tip toolchain (and keep the gotip launcher available).
ENV PATH="/root/sdk/gotip/bin:/go/bin:${PATH}"

# Preload module deps and install all packages in the repo.
RUN gotip version \
    && gotip mod download \
    && gotip install ./...

CMD ["/bin/bash"]
