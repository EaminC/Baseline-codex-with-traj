FROM rust:1.72-bullseye

# Create app directory
WORKDIR /app

# Copy entire repository
COPY . .

# Build the workspace to cache dependencies
RUN cargo build --release

# Default command to start bash shell
CMD ["/bin/bash"]
