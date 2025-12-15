FROM golang:latest

WORKDIR /go/src/google.golang.org/grpc

# Copy repo files
COPY . .

# Build all
RUN go build ./...

# Start bash shell
ENTRYPOINT ["/bin/bash"]
