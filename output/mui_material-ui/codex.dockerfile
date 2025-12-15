FROM node:18-bullseye

WORKDIR /app

COPY . .

RUN npm install -g pnpm@7 && pnpm install

CMD ["/bin/bash"]
