# BPX Synapse node

![Synapse](./logo.svg)

Official Nim implementation of the Synapse network node.

Synapse is a real time off-chain communication layer for BPX DApps.

## Building the source

Make sure you have the standard developer tools installed, including a C compiler, GNU Make, Bash, and Git.

```bash
# The first `make` invocation will update all Git submodules.
# You'll run `make update` after each `git pull` in the future to keep those submodules updated.
make synapse

# Build with custom compilation flags. Do not use NIM_PARAMS unless you know what you are doing.
# Replace with your own flags
make synapse NIMFLAGS="-d:chronicles_colors:none -d:disableMarchNative"
```

## Usage

Run a node
```bash
./build/synapse
```
