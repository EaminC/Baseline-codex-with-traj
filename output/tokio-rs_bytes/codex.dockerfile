FROM rust:slim

WORKDIR /usr/src/app

# Copy the manifest and lock files
COPY Cargo.toml Cargo.lock* ./

# Copy source code
COPY src ./src

# Build the project
RUN cargo build --release

CMD ["/bin/bash"]
