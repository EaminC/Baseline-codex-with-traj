FROM node:18-bullseye

WORKDIR /usr/src/dayjs

# Install dependencies first for better cache utilization
COPY package.json package-lock.json ./
RUN npm ci

# Bring the rest of the repository into the image
COPY . .

# Drop into a shell at the repository root
CMD ["/bin/bash"]
