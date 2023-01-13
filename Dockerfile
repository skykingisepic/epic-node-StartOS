FROM ubuntu

RUN apt-get update \
  && apt-get install -y wget \
  && apt-get install -y unzip \
  && rm -rf /var/lib/apt/lists/*

ARG ARCH
ADD epic-node-${ARCH} /usr/local/bin/epic-node
RUN chmod +x /usr/local/bin/epic-node
ADD docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
ADD foundation.json /epic/foundation.json
ADD epic-server.toml /epic/epic-server.toml

