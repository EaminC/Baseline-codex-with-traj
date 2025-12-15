FROM node:18

# Install pnpm globally
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Copy repo files
COPY . /app

# Install dependencies
RUN pnpm install

# Add pnpm binaries to PATH
ENV PATH="/app/node_modules/.bin:$PATH"

# Set default shell
CMD ["/bin/bash"]
