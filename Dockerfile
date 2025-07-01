FROM rust:latest AS build
ARG PROXYDETOX_VERSION=0.12.0
RUN apt-get update && apt-get install -y libclang-19-dev
RUN mkdir -p /opt && cd /opt \
    && git clone https://github.com/kiron1/proxydetox.git \
    && cd proxydetox \
    && git checkout v${PROXYDETOX_VERSION}
RUN cargo install --path /opt/proxydetox/proxydetox


#Now build the final image containing the executable
FROM ubuntu:noble
RUN apt-get update && apt-get install -y libgssapi-krb5-2
COPY --from=build /usr/local/cargo/bin/proxydetox /usr/bin/proxydetox

EXPOSE 3128

ENTRYPOINT ["/usr/bin/proxydetox"]