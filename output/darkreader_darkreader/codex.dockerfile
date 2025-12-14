FROM node:20-bookworm-slim

ENV NODE_ENV=development

# Install build tools needed for native dependencies and general CLI work.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Install dependencies first for better build caching.
COPY package*.json ./
RUN npm ci --no-audit --progress=false

# Copy the rest of the repository.
COPY . .

# Use the non-root node user for interactive work.
RUN chown -R node:node /usr/src/app
USER node

# Drop into a shell at the repo root.
CMD ["/bin/bash"]
