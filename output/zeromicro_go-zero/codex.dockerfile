FROM golang:1.21-bullseye

WORKDIR /go-zero

# Copy entire repo
COPY . /go-zero

# Download dependencies
RUN go mod download

# Default to an interactive bash shell
CMD ["/bin/bash"]
