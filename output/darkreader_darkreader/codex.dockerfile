FROM node:18-bullseye

# Set working directory
WORKDIR /app

# Copy all files
COPY . .

# Install dependencies
RUN npm install

# Build the project
RUN npm run build

# Default to bash shell
CMD ["/bin/bash"]
