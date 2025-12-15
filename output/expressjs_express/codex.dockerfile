FROM node:18

WORKDIR /usr/src/app

# Copy package files separately to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the repository files
COPY . .

# Start container with bash shell at repo root
ENTRYPOINT ["/bin/bash"]
CMD [""]
