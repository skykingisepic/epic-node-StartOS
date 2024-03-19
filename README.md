# Wrapper for epic-node

EPIC Node Server is a project that creates a service that runs on Start9 server. This repository creates the `s9pk` package that is installed to run `epic-node` on [StartOS](https://github.com/Start9Labs/start-os/). Learn more about service packaging in the [Developer Docs](https://docs.start9.com/latest/developer-docs/packaging).

## Cloning

Clone the project locally:

```
git clone https://github.com/skykingisepic/epic-node-StartOS.git
```

## Building

Binaries are downloaded from github latest release of Epic Node Server and verified

To build the `epic-node` package using start-sdk version 0.3.5+, run the following command:

```
make
```

## Installing (on StartOS)

Run the following commands to determine successful install:
> :information_source: Change startos-server-name.local to your StartOS address

```
start-cli auth login
# Enter your StartOS password
start-cli --host https:/startos-server-name.local package install epic-node.s9pk
```

If you already have your `start-cli` config file setup with a default `host`, you can install simply by running:

```
make install
```

> **Tip:** You can also install the epic-node.s9pk using **Sideload Service** under the **System > Manage** section.

### Verify Install

Go to your Start9 Services page, select **EPIC Node Server**, and start the service. Go to Logs and watch the progress of the bootstrap download and unzip (Server won't start until complete). Then, verify the Server is accessible via ssh, docker, and screen (see Instructions).

**Done!** 

...

### Binary Builds and Source Notes

Release binaries were built on Pi4 running latest Raspbian Lite for aarch64 and Linux Mint 20.3 for X86_64

Epic Node Source repo located at https://github.com/EpicCash/epic

Built using Rust v1.74 (see 'Building the projects' section in repo README)

For aarch64 build on Pi4 you must change one line in Cargo.toml located in core folder:
```
#randomx = { path = "./randomx-rust", version = "0.1.0" }
randomx = { git = "https://github.com/johanneshahn/randomx-rs.git"}
```

For users building epic node binary on Ubuntu 22+, you will need to install libssl1.1.1f from Ubuntu's package manager. See epic 3.6.0 release notes. Must be included in docker file as node binary dependency.
