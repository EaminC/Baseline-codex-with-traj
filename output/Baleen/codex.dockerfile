FROM python:3.11

# Set working directory inside the container
WORKDIR /workspace

# Install basic dependencies
RUN apt-get update && apt-get install -y git bash && rm -rf /var/lib/apt/lists/*

# Copy all files in the current context to /workspace in container
COPY . /workspace

# Install Python dependencies if requirements.txt exists
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# Default command to open a bash shell
CMD ["/bin/bash"]
