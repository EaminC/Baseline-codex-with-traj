FROM node:22-slim

WORKDIR /workspace

# Install JS dependencies using the lockfile for reproducibility
COPY package*.json ./
RUN npm ci

# Copy the full repository
COPY . .

CMD ["/bin/bash"]
