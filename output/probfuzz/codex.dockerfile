FROM python:2.7-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget openjdk-8-jdk-headless bc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install required Python2 packages
RUN pip install --no-cache-dir \
    antlr4-python2-runtime six astunparse ast pystan edward pyro-ppl==0.2.1 tensorflow==1.5.0 pandas

# Set work directory
WORKDIR /app

# Copy the current repo contents into the container
COPY . /app

# Download Antlr jar and generate parser code
RUN wget -q http://www.antlr.org/download/antlr-4.7.1-complete.jar -P language/antlr/ && \
    bash language/antlr/run.sh

CMD ["/bin/bash"]
