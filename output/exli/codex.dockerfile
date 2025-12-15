FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

# Install software properties common and basic dev tools
RUN apt-get update && apt-get install -y software-properties-common
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && \
    apt-get -qq -y install apt-utils curl wget unzip zip gcc mono-mcs sudo emacs vim less git build-essential pkg-config libicu-dev firefox

# Install geckodriver for Firefox
RUN curl -L https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-linux64.tar.gz | tar xz -C /usr/local/bin

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# Add user
RUN useradd -ms /bin/bash -c "ExLi User" exliuser && echo "exliuser:exliuser" | chpasswd && adduser exliuser sudo
USER exliuser
ENV USER exliuser

# Working directory
WORKDIR /home/exliuser/exli

# Copy repo files into container
COPY . /home/exliuser/exli

# Download and install SDKMAN
RUN curl -s "https://get.sdkman.io" | bash
ENV PATH="$HOME/.sdkman/bin:${PATH}"

# Install JDK 8
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java 8.0.302-open"

# Initialize conda
RUN conda init bash

# Prepare conda environment (python and dependencies)
RUN bash python/prepare-conda-env.sh

# Install ITest java project
RUN cd /home/exliuser/exli/inlinetest/java && bash install.sh

# Install ExLi java project
RUN cd /home/exliuser/exli/java && bash install.sh

# Default to bash shell
ENTRYPOINT ["/bin/bash"]
