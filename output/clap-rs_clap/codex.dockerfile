FROM rust:1.78-bullseye

ENV CARGO_TERM_COLOR=always

WORKDIR /workspace

COPY . .

RUN cargo fetch --locked \
 && cargo build --locked

CMD ["/bin/bash"]
