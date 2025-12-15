FROM node:22

# Set working directory to the root of the repo inside container
WORKDIR /workspace

# Copy package.json and package-lock.json first for caching
COPY package.json package-lock.json ./

# Copy workspace package manifests
COPY packages/insomnia-inso/package.json ./packages/insomnia-inso/
COPY packages/insomnia/package.json ./packages/insomnia/
COPY packages/insomnia-api/package.json ./packages/insomnia-api/
COPY packages/insomnia-testing/package.json ./packages/insomnia-testing/
COPY packages/insomnia-smoke-test/package.json ./packages/insomnia-smoke-test/
COPY packages/insomnia-scripting-environment/package.json ./packages/insomnia-scripting-environment/
COPY packages/insomnia-component-docs/package.json ./packages/insomnia-component-docs/

# Copy rest of the repo
COPY . .

# Install npm dependencies
RUN npm install

# Default to bash shell
CMD ["/bin/bash"]
