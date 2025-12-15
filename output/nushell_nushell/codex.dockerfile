FROM rust:latest

# Create a new user to avoid running as root
RUN useradd -m nushelluser

# Create app directory and set as workdir
WORKDIR /usr/src/nushell

# Copy the entire repo into the container
COPY . .

# Install required dependencies for building (if any)
# We rely on cargo and Rust from rust official image, no extra deps needed

# Build and install nushell using cargo
RUN cargo install --path . --locked

# Change to non-root user
USER nushelluser

# Set workdir for the shell
WORKDIR /usr/src/nushell

# Start bash shell by default
CMD ["/bin/bash"]
