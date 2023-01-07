FROM alpine:3.17

RUN apk update
RUN apk add --no-cache tini && \
    rm -f /var/cache/apk/*

ARG ARCH
ADD ./epic-node/target/${ARCH}-unknown-linux-musl/release/epic-node /usr/local/bin/epic-node
RUN chmod +x /usr/local/bin/epic-node
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
