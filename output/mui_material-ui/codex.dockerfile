# Use Node 22 with bash available
FROM node:22-bullseye

# System deps for native builds and git operations
RUN apt-get update \
  && apt-get install -y --no-install-recommends git python3 build-essential \
  && rm -rf /var/lib/apt/lists/*

# Enable the required pnpm version via corepack
ENV PNPM_HOME=/usr/local/pnpm
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable pnpm && corepack prepare pnpm@10.22.0 --activate

# Work from the repo root inside the container
WORKDIR /mui-material-ui

# Copy repository and install dependencies
COPY . .
RUN pnpm install --frozen-lockfile

# Drop into a bash shell in the repo root by default
CMD ["/bin/bash"]
