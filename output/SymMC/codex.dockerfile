FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install toolchain and build dependencies for Java (Enhanced_Kodkod) and C++ (Enumerator_Estimator)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-8-jdk \
        ant \
        build-essential \
        cmake \
        zlib1g-dev \
        libgmp-dev && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

WORKDIR /opt/SymMC

# Copy the repository into the image
COPY . /opt/SymMC

# Build the Enhanced_Kodkod Java module
RUN cd Enhanced_Kodkod && ./build.sh

# Build the Enumerator_Estimator (MiniSat-based) module
RUN cd Enumerator_Estimator && ./build.sh

# Keep tools discoverable when you drop into the container
ENV PATH="/opt/SymMC/Enumerator_Estimator/cmake-build-release:${PATH}"

# Start in the repository root with an interactive shell
CMD ["/bin/bash"]
