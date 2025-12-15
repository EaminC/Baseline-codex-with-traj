FROM rust:latest

# Set working directory
WORKDIR /app

# Copy source code
COPY . /app

# Build and install bat using cargo
RUN cargo install --path . --locked

# Set default shell
CMD ["/bin/bash"]
