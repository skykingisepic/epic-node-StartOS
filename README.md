# Wrapper for epic-node

EPIC Node Server is a project that creates a service that runs on embassyOS. This repository creates the `s9pk` package that is installed to run `epic-node` on [embassyOS](https://github.com/Start9Labs/embassy-os/). Learn more about service packaging in the [Developer Docs](https://start9.com/latest/developer-docs/).

## Dependencies

Install the system dependencies below to build this project by following the instructions in the provided links. You can also find detailed steps to setup your environment in the service packaging [documentation](https://github.com/Start9Labs/service-pipeline#development-environment).

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [deno](https://deno.land/)
- [make](https://www.gnu.org/software/make/)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/tree/master/backend)

## Build environment
Prepare your embassyOS build environment. In this example we are using Linux Mint 20.
1. Install docker
```
sudo curl -fsSL https://get.docker.com -o- | bash
sudo usermod -aG docker "$USER"
exec sudo su -l $USER
```
2. Set buildx as the default builder
```
sudo docker buildx install
sudo docker buildx create --use
```
3. Enable cross-arch emulated builds in docker and get alpine
```
sudo docker run --privileged --rm linuxkit/binfmt:v0.8
sudo docker pull alpine
```
4. Install yq
```
sudo snap install yq
or
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod a+x /usr/local/bin/yq
```
5. Install deno
```
sudo snap install deno
or
curl -fsSL https://deno.land/x/install/install.sh | sh
mv /home/<user>/.deno/bin/deno /usr/bin/
export DENO_INSTALL="/home/<user>/.deno
```
6. Install essentials build packages
```
sudo apt-get install -y build-essential openssl libssl-dev libc6-dev clang libclang-dev ca-certificates
```
7. Install Rust
```
curl https://sh.rustup.rs -sSf | sh
# Choose nr 1 (default install)
source $HOME/.cargo/env
```
8. Build and install embassy-sdk
```
cd ~/ && git clone --recursive https://github.com/Start9Labs/embassy-os.git
cd embassy-os/backend/
./install-sdk.sh
sudo embassy-sdk init
```
Now you are ready to build the `epic-node` package!

## Cloning

Clone the project locally:

```
git clone https://github.com/skykingisepic/epic-node-embassyOS.git
```

## Building

Put the node binaries in the repo folder as epic-node-x86_64 and epic-node-aarch_64 or unzip included archives

To build the `epic-node` package using embassy-sdk version >=0.3.3, run the following command:

```
make
```

## Installing (on embassyOS)

Run the following commands to determine successful install:
> :information_source: Change embassy-server-name.local to your Embassy address

```
embassy-cli auth login
# Enter your embassy password
embassy-cli --host https://embassy-server-name.local package install epic-node.s9pk
```

If you already have your `embassy-cli` config file setup with a default `host`, you can install simply by running:

```
make install
```

> **Tip:** You can also install the epic-node.s9pk using **Sideload Service** under the **System > Manage** section.

### Verify Install

Go to your Embassy Services page, select **EPIC Node Server**, configure and start the service. Then, verify its interfaces are accessible.

**Done!** 

...

### Binary Builds and Source Notes

Included binaries were built on Pi4 running latest Raspbian Lite for aarch64 and Linux Mint 20.3 for X86_64

Epic Node Source repo located at https://github.com/EpicCash/epic

Build using Rust v1.62 (see 'Building the projects' section in repo README)

For aarch64 build on Pi4 you must change one line in Cargo.toml located in core folder:
```
#randomx = { path = "./randomx-rust", version = "0.1.0" }
randomx = { git = "https://github.com/johanneshahn/randomx-rs.git"}
```

