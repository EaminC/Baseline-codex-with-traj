FROM rust:latest

WORKDIR /serde

# Copy entire repository to /serde in the container
COPY . /serde

# Build the entire cargo workspace in release mode
RUN cargo build --release

# Set default command to start a bash shell
CMD ["/bin/bash"]
