# syntax=docker/dockerfile:1
FROM node:22-bullseye

# System deps for node-gyp/Electron runtime pieces used by the workspace
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    python3 \
    build-essential \
    pkg-config \
    ca-certificates \
    libcurl4 \
    libcurl4-openssl-dev \
    libnss3 \
    libxss1 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgtk-3-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libxshmfence1 \
    libxtst6 \
    libxkbcommon0 \
    libfontconfig1 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/insomnia

# Supply NODE_AUTH_TOKEN at build time if you need access to GitHub-packaged deps.
ARG NODE_AUTH_TOKEN
COPY . .
RUN NODE_AUTH_TOKEN="${NODE_AUTH_TOKEN}" npm ci

ENV PATH="/usr/src/insomnia/node_modules/.bin:${PATH}"

CMD ["/bin/bash"]
