FROM golang:1.21-bookworm

ENV GO111MODULE=on \
    CGO_ENABLED=1

WORKDIR /workspace/go-zero

# Minimal tools to resolve modules from VCS.
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates && rm -rf /var/lib/apt/lists/*

# Cache module downloads separately from source copy.
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build and install all provided binaries into the image.
RUN go install ./...

CMD ["/bin/bash"]
