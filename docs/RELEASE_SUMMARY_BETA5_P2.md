# Nightfall GPU Miner — Beta 5 p2

> ⚠️ **Mandatory network upgrade at Mainnet block 500,000:** This Beta 5 p2 package contains **Core 1.0.11**, which will **stop following the correct chain after block 500,000**. [Nightfall Core 1.1.1](https://github.com/Instinctes/nightfall/releases/tag/v1.1.1) introduces the required consensus rules. A compatible Linux GPU Miner update is being tested. **Do not simply swap the bundled Core executable:** this miner requires its own GPU RPC integration. Keep existing blockchain and wallet data; no chain reset is needed.

**Linux x86-64 · Nightfall Core 1.0.11 · NVIDIA CUDA + Experimental AMD HIP**

Independent NIGHTFALLCOIN (NIGHT) community miner. **Pre-release — not official Nightfall Core software.**

## Download

**[Linux miner (.tar.gz)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.5-p2/nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz)** · [SHA-256 checksum](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.5-p2/nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz.sha256)

**SHA-256:** `bb31b66d94354e625add8030cd36824aaf9bab0afff5eb00ed9f3208633a8012`

## Linux quick start (NVIDIA)

Copy and paste into a Linux terminal. No GitHub account is needed:

```bash
mkdir -p "$HOME/nightfall-download" && cd "$HOME/nightfall-download"
TAG="v1.3.8-rc3-beta.5-p2"
FILE="nightfall-miner-${TAG}-linux-x86_64.tar.gz"
URL="https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/${TAG}"

curl -fL --retry 3 -o "$FILE" "$URL/$FILE" &&
curl -fL --retry 3 -o "$FILE.sha256" "$URL/$FILE.sha256" &&
sha256sum -c "$FILE.sha256" &&
tar -xzf "$FILE" &&
cd "nightfall-miner-${TAG}" &&
bash selftest.sh
```

After **`NIGHTFALL_MINER_PACKAGE_SELFTEST_PASS`**, enter **your public NIGHT payout address** (not a seed phrase):

```bash
read -r -p "Your public NIGHT payout address (nf1...): " ADDR
MODE="--user"
[ "$(id -u)" -eq 0 ] && MODE="--system"
bash install.sh "$MODE" --address "$ADDR"
```

The installer supports normal Linux users **and root rental containers** automatically. Blockchain synchronization and peer checks may take some time.

**Monitor / stop:** Normal user: `~/.local/bin/mine` or `~/.local/bin/minerctl stop`. Root: `/opt/nightfall-miner/mine` or `/opt/nightfall-miner/minerctl stop`.

## What's included

- **NVIDIA CUDA:** 12 precompiled GPU architectures, optimized GPU + CPU mining.
- **AMD HIP:** `gfx1030`, `gfx1100`, `gfx1101`, `gfx1200` — **experimental and NOT tested on real AMD GPU hardware**. Requires compatible ROCm drivers and an on-device correctness test; see guide before installing.
- **Core 1.0.11**, canonical network guard, FastSync, live hashrate/block dashboards and safe upgrades.
- GPU developer work fee **4.5%**; CPU fee **0%**.

**[Complete guide (including AMD and upgrades)](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/RELEASE_NOTES_BETA5_P2.md)** · [Troubleshooting](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/TROUBLESHOOTING.md) · [Report an issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues)

*This is beta software. Do not run an old fresh-install command over an existing installation. Use the upgrade guide to preserve your chain and fee state. Mining returns are not guaranteed.*
