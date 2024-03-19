UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
    SHA_CMD := sha256sum
endif
ifeq ($(UNAME_S),Darwin)
    SHA_CMD := shasum -a 256
endif

PKG_ID := $(shell yq e ".id" manifest.yaml)
PKG_VERSION := $(shell yq e ".version" manifest.yaml)
TS_FILES := $(shell find ./ -name \*.ts)
$(shell rm epic*.tar.* && rm *sha256sum*.*)
$(shell wget https://github.com/EpicCash/epic/releases/download/v3.6.0/epic-3.6.0-startos-aarch64.tar.gz)
$(shell wget https://github.com/EpicCash/epic/releases/download/v3.6.0/epic-3.6.0-startos-aarch64-sha256sum.txt)
$(shell tar -zxf epic-3.6.0-startos-aarch64.tar.gz)
$(shell wget https://github.com/EpicCash/epic/releases/download/v3.6.0/epic-3.6.0-startos-x86_64.tar.gz)
$(shell wget https://github.com/EpicCash/epic/releases/download/v3.6.0/epic-3.6.0-startos-x86_64-sha256sum.txt)
$(shell tar -zxf epic-3.6.0-startos-x86_64.tar.gz)
valid1 := $(shell $(SHA_CMD) -c epic-3.6.0-startos-x86_64-sha256sum.txt)
valid2 := $(shell $(SHA_CMD) -c epic-3.6.0-startos-aarch64-sha256sum.txt)

# delete the target of a rule if it has changed and its recipe exits with a nonzero exit status
.DELETE_ON_ERROR:

all: verify

verify: $(PKG_ID).s9pk
	@start-sdk verify s9pk $(PKG_ID).s9pk
	@echo " Done!"
	@echo "   Filesize: $(shell du -h $(PKG_ID).s9pk) is ready"

install:
ifeq (,$(wildcard ~/.embassy/config.yaml))
	@echo; echo "You must define \"host: http://startos-server-name.local\" in ~/.embassy/config.yaml config file first"; echo
else
	start-cli package install $(PKG_ID).s9pk
endif

clean:
	rm -rf docker-images
	rm -f image.tar
	rm -f $(PKG_ID).s9pk
	rm -f scripts/*.js

scripts/embassy.js: $(TS_FILES)
	deno bundle scripts/embassy.ts scripts/embassy.js

docker-images/aarch64.tar: Dockerfile ./foundation.json ./epic-server.toml docker_entrypoint.sh checkup.sh epic-node-aarch64
ifeq ($(findstring OK,$(valid2)),)
	@echo "sha256sum Validation Failed for epic-node-aarch64 binary"; exit 1
else
ifeq ($(ARCH),x86_64)
else
	mkdir -p docker-images
	docker buildx build --tag start9/$(PKG_ID)/main:$(PKG_VERSION) --build-arg ARCH=aarch64 --platform=linux/arm64 -o type=docker,dest=docker-images/aarch64.tar .
endif
endif

docker-images/x86_64.tar: Dockerfile ./foundation.json ./epic-server.toml docker_entrypoint.sh checkup.sh epic-node-x86_64
ifeq ($(findstring OK,$(valid1)),)
	@echo "sha256sum Validation Failed for epic-node-x86_64 binary"; exit 1
else
ifeq ($(ARCH),aarch64)
else
	mkdir -p docker-images
	docker buildx build --tag start9/$(PKG_ID)/main:$(PKG_VERSION) --build-arg ARCH=x86_64 --platform=linux/amd64 -o type=docker,dest=docker-images/x86_64.tar .
endif
endif

$(PKG_ID).s9pk: manifest.yaml instructions.md icon.png LICENSE scripts/embassy.js docker-images/aarch64.tar docker-images/x86_64.tar
ifeq ($(ARCH),aarch64)
	@echo "start-sdk: Preparing aarch64 package ..."
else ifeq ($(ARCH),x86_64)
	@echo "start-sdk: Preparing x86_64 package ..."
else
	@echo "start-sdk: Preparing Universal Package ..."
endif
	@start-sdk pack
