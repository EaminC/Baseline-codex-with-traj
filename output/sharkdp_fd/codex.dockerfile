FROM rust:latest

# Create app directory
WORKDIR /app

# Copy source code
COPY . .

# Build the project with release profile
RUN cargo build --release

# Set working directory to the project root
WORKDIR /app

# Default command starts bash shell
CMD ["/bin/bash"]
