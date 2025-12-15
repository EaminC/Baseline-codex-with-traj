FROM openjdk:17-slim

# Install Python3, pip, and Maven
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    maven \
    bash \
 && rm -rf /var/lib/apt/lists/*

# Install pytest Python package
RUN pip3 install pytest

# Set working directory
WORKDIR /app

# Copy all repo files
COPY . /app

# Build and install Maven modules
RUN mvn -f commons-cli/pom.xml install
RUN mvn -f commons-cli-graal/pom.xml install
RUN mvn -f commons-csv/pom.xml install
RUN mvn -f commons-csv-graal/pom.xml install
RUN mvn -f graal-glue-generator/pom.xml install

# Default to bash shell
CMD ["/bin/bash"]
