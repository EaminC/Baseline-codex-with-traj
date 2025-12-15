FROM node:18

WORKDIR /usr/src/app

# Copy package.json and package-lock.json first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all project files
COPY . .

# Default to interactive bash shell in repo root
CMD ["/bin/bash"]
