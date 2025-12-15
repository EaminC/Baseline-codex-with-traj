FROM openjdk:17

WORKDIR /workdir

# Copy all files
COPY . /workdir

# Make the Maven wrapper executable
RUN chmod +x ./mvnw

# Run Maven install to build and install the project
RUN ./mvnw install -DskipTests

# Start a bash shell in the workdir by default
CMD ["/bin/bash"]
