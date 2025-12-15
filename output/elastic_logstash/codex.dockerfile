FROM openjdk:17-jdk-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    bash \
    ruby-full \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install bundler
RUN gem install bundler

WORKDIR /app

# Copy the repo contents
COPY . /app

# Install ruby gems dependencies using bundler
RUN bundle install

CMD ["/bin/bash"]
