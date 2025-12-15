FROM rust:1.74

# Create app directory
WORKDIR /app

# Copy the entire repo into the container
COPY . .

# Build the entire workspace to install dependencies and compile
RUN cargo build --release

# Set the default working directory on container start
WORKDIR /app

# Default command to run bash shell
CMD ["/bin/bash"]
