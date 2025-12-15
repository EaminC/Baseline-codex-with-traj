FROM rust:1.71

# Create app directory in container
WORKDIR /app

# Copy all files from current directory into container
COPY . /app

# Build the Rust workspace in release mode
RUN cargo build --release

# Set working directory for runtime
WORKDIR /app

# Use bash as the default command
CMD ["/bin/bash"]
