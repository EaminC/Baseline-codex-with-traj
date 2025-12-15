FROM debian:latest

# Essential utilities and sudo
RUN apt-get update && apt-get install -y sudo bash curl

# Copy the entire repository to /crossprefetch
COPY . /crossprefetch
WORKDIR /crossprefetch

# Install system dependencies required by the repo
RUN bash scripts/install_packages.sh

# Setup environment variables and compile user library
RUN bash -c "source scripts/setvars.sh && cd shared_libs/simple_prefetcher && ./compile.sh"

# Set working directory to repo root and launch bash shell on start
WORKDIR /crossprefetch
ENTRYPOINT ["/bin/bash"]
