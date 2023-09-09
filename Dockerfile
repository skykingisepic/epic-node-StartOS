FROM ubuntu:20.04

RUN apt-get update \
  && apt-get install -y wget \
  && apt-get install -y unzip \
  && apt-get install -y libncurses5 \
  && apt-get install -y libncursesw5 \
  && apt-get install -y zlib1g \
  && apt-get install -y screen \
  && apt-get install -y locales \
  && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  

ARG ARCH
ADD epic-node-${ARCH} /usr/local/bin/epic-node
RUN chmod +x /usr/local/bin/epic-node
ADD docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
ADD foundation.json /epic/foundation.json
ADD epic-server.toml /epic/epic-server.toml



