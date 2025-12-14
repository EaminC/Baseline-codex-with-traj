# Base image with Node.js LTS and corepack for pnpm
FROM node:20-bookworm

# OS packages needed for building native deps and running git-related scripts
RUN apt-get update \
  && apt-get install -y --no-install-recommends git python3 build-essential ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Match repo pnpm version
ENV PNPM_HOME=/usr/local/share/pnpm
ENV PATH="${PNPM_HOME}:${PATH}"
RUN corepack enable && corepack prepare pnpm@10.20.0 --activate

# Work from the repository root inside the container
WORKDIR /usr/src/vuejs_core

# Bring in the entire repo and install dependencies
COPY . .
RUN pnpm install --frozen-lockfile

# Drop into a bash shell at repo root by default
CMD ["/bin/bash"]
