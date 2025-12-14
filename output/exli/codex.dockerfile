# Build an ExLi image that drops into /bin/bash at the repo root with the
# Python and Java tooling installed.
FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        git \
        unzip \
        zip \
        build-essential \
        pkg-config \
        software-properties-common \
        locales \
        sudo \
        vim \
        less \
        emacs \
        mono-mcs \
        firefox \
        libicu-dev && \
    rm -rf /var/lib/apt/lists/*

# Geckodriver is needed alongside Firefox for the existing tooling.
RUN curl -L https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-linux64.tar.gz \
    | tar xz -C /usr/local/bin

# Install Miniconda for Python tooling.
ENV CONDA_DIR=/opt/conda
RUN curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    $CONDA_DIR/bin/conda clean -afy
ENV PATH=$CONDA_DIR/bin:$PATH

# Create a non-root user and hand ownership of conda over.
RUN useradd -ms /bin/bash exli && \
    echo "exli ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/exli && chmod 0440 /etc/sudoers.d/exli && \
    chown -R exli:exli $CONDA_DIR

USER exli
WORKDIR /home/exli
ENV HOME=/home/exli
SHELL ["/bin/bash", "-lc"]

# Install Java 8 and Maven via SDKMAN.
ENV SDKMAN_DIR=/home/exli/.sdkman
RUN curl -s "https://get.sdkman.io" | bash
RUN source "$SDKMAN_DIR/bin/sdkman-init.sh" && \
    sdk install java 8.0.302-open && \
    sdk install maven 3.8.3

ENV JAVA_HOME=/home/exli/.sdkman/candidates/java/current
ENV PATH=/opt/conda/bin:/home/exli/.sdkman/candidates/java/current/bin:/home/exli/.sdkman/candidates/maven/current/bin:/home/exli/.sdkman/bin:$PATH

# Bring the repository into the image.
COPY --chown=exli:exli . /home/exli/exli
WORKDIR /home/exli/exli

# Set up the Python environment and install ExLi (editable with extras).
RUN conda init bash && \
    cd python && \
    bash prepare-conda-env.sh 3.9 exli

# Install the Java artifacts.
RUN source "$SDKMAN_DIR/bin/sdkman-init.sh" && \
    cd java && \
    bash install.sh

# Make sure the environment is ready when a shell starts.
RUN echo "source $SDKMAN_DIR/bin/sdkman-init.sh" >> /home/exli/.bashrc && \
    echo "conda activate exli" >> /home/exli/.bashrc

CMD ["/bin/bash"]
