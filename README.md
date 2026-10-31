# Nightfall GPU Miner

**Easy NVIDIA GPU + CPU mining for NIGHTFALLCOIN (NIGHT) on Linux.**

![Linux](https://img.shields.io/badge/Linux-x86__64-blue)
![NVIDIA CUDA](https://img.shields.io/badge/NVIDIA-CUDA-76B900)
![AMD experimental](https://img.shields.io/badge/AMD_HIP-experimental-orange)
[![Latest release](https://img.shields.io/badge/Release-Beta_6-blue)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.6)

**Latest release:** [v1.3.8 RC3 Beta 6](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.6) · **Nightfall Core 1.1.1** · Ubuntu 24.04 x86-64 recommended.

> **Important:** Core 1.1.1 includes the mandatory Mainnet consensus upgrade at **block 500,000**. Earlier Beta 5 p2 uses Core 1.0.11 and must be upgraded before that point. You do **not** need a new wallet or to redownload the chain.

## Download and verify

**Linux x86-64, NVIDIA driver required.** Download one self-extracting `.run` miner and its checksum. No CUDA Toolkit or Rust build needed.

[**Download Linux miner (.run)**](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.6/nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.run) · [**SHA-256 checksum**](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.6/nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.run.sha256) · [Release notes](docs/RELEASE_NOTES_BETA6.md)

Or copy this block into your Linux terminal:

```bash
mkdir -p "$HOME/nightfall-download" && cd "$HOME/nightfall-download"
FILE=nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.run
URL=https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.6

curl -fL --retry 3 -o "$FILE" "$URL/$FILE" &&
curl -fL --retry 3 -o "$FILE.sha256" "$URL/$FILE.sha256" &&
sha256sum -c "$FILE.sha256" &&
chmod +x "$FILE" &&
./"$FILE" --verify
```

Expected: `ONEFILE_BETA6_PACKAGE_SELFTEST_PASS`. **Do not install if verification fails.**

The published `.run` SHA-256 is:

```text
9e7e2c7f143c5d2d61b22f6493f00760894c73af44d721fc36ea4bbaf79251fd
```

## New installation

Run this **in the same download directory**. Use only your public `nf1...` NIGHT payout address:

```bash
read -r -p "Public NIGHT payout address (nf1...): " ADDR
./nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.run --install --address "$ADDR"
```

The installer selects normal-user or root/system mode automatically. FastSync and the live canonical peer guard keep mining paused until the chain is ready. **Never enter a wallet seed or private key.**

## Upgrade from Beta 5 p2

**Simple, safe upgrade:** stop the old miner, review the plan, upgrade, restart. Use the **same Linux account** that installed Beta 5 p2. Your chain, existing payout address, GPU fee state and logs are retained.

```bash
CTL="$HOME/.local/bin/minerctl"
[ "$(id -u)" -eq 0 ] && CTL=/opt/nightfall-miner/minerctl
"$CTL" stop
./nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.run --upgrade --plan
```

Check that the plan shows the correct **existing install and chain paths**. Then run:

```bash
./nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.run --upgrade
"$CTL" start
"$CTL" doctor
```

If your installation uses a nonstandard folder, pass your existing `--prefix PATH` to **both** upgrade commands and use the `minerctl` in that prefix. The upgrade includes a rollback mechanism.

## Features and limitations

- **12 precompiled NVIDIA CUDA GPU architectures** with CPU mining, FastSync, canonical peer checks and mining status dashboard.
- **GPU developer fee: 4.5% of completed GPU work; CPU fee: 0%.**
- Beta 6 was validated with a real **GTX 1650** on Mainnet for GPU USER/DEV work and automatic DEV fee dispatch; a valid Mainnet block was **not** observed during short tests.
- The block-500,000 consensus rules passed isolated DEVNET tests; live post-fork Mainnet operation has **not yet** been demonstrated.
- **AMD HIP is experimental** and has **not** been physically validated. Not all NVIDIA models have been tested with this exact Beta 6 release.
- This is independent community beta software, **not an official Nightfall Core release**. Mining rewards and speeds are not guaranteed.

[Full Beta 6 notes](docs/RELEASE_NOTES_BETA6.md) · [Report an issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues) · [License](LICENSE) · [Previous Beta 5 p2](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2)

**Download safety:** Use the release's `.run` asset, **not** GitHub's automatically generated *Source code* archives or older files under `installer/`. The OneFile format is convenience packaging, not encryption.
