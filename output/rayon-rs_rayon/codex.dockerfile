FROM rust:latest

# Create app directory in container
WORKDIR /app

# Copy everything from current directory to container
COPY . /app

# Build the Rust workspace
RUN cargo build --release

# Start a bash shell
CMD ["/bin/bash"]
