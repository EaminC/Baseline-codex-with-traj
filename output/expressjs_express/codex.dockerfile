# Development image for the express repository
FROM node:20-bookworm

# Install dependencies into a writable app directory
WORKDIR /usr/src/app

# Install dependencies first for better layer caching
COPY package*.json ./
RUN set -eux; \
    npm install

# Copy the rest of the repository
COPY . .

# Default to an interactive shell at the repo root
CMD ["/bin/bash"]
