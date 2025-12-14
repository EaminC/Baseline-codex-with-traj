FROM node:20-bookworm

# Keep workdir at the project root so the container drops into the repo.
WORKDIR /home/node/app

# Install dependencies first to leverage Docker layer caching.
COPY package*.json ./
RUN npm ci --ignore-scripts

# Copy the rest of the repository contents.
COPY . .

# Default to an interactive shell at the repo root.
CMD ["/bin/bash"]
