FROM node:20-bookworm-slim

# Avoid pulling Playwright browsers during install.
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

WORKDIR /repo

# Install build essentials, then prepare pnpm as defined in package.json.
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates git python3 build-essential \
  && rm -rf /var/lib/apt/lists/* \
  && corepack enable \
  && corepack prepare pnpm@10.4.0 --activate

COPY . .

RUN pnpm install --frozen-lockfile

CMD ["/bin/bash"]
