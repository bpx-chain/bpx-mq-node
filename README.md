# BPX Message Queue node

Official Nim implementation of the BPX Message Queue.

BPX MQ is a decentralized, peer-to-peer network of message relaying nodes. The purpose of BPX MQ is providing
real time, off-chain communication for DApps running on the BPX blockchain. In simple terms, BPX MQ can be
compared to a global, distributed in trustless manner RabbitMQ or Apache Kafka cluster, where each BPX wallet
is a user account and can send messages to other wallets, or participate in pub-sub groups.

## Building the source

Make sure you have the standard developer tools installed, including a C compiler, GNU Make, Bash, and Git.

```bash
# The first `make` invocation will update all Git submodules.
# You'll run `make update` after each `git pull` in the future to keep those submodules updated.
make bpxmqnode

# Build with custom compilation flags. Do not use NIM_PARAMS unless you know what you are doing.
# Replace with your own flags
make bpxmqnode NIMFLAGS="-d:chronicles_colors:none -d:disableMarchNative"
```

## Usage

Run a node
```bash
./build/bpxmqnode
```