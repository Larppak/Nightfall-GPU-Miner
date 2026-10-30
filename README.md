# Nightfall GPU Miner

**Easy GPU + CPU mining for NIGHTFALLCOIN (NIGHT) on Linux.**

![Linux](https://img.shields.io/badge/Linux-x86__64-blue)
![NVIDIA CUDA](https://img.shields.io/badge/NVIDIA-CUDA-76B900)
![AMD experimental](https://img.shields.io/badge/AMD_HIP-experimental-orange)
[![Latest release](https://img.shields.io/badge/Latest-Beta_5_p2-blue)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2)

**Latest version:** [Beta 5 p2](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2) · **Nightfall Core 1.0.11** · Ubuntu 24.04 x86-64 recommended.

> **Important — upcoming Nightfall network upgrade:** Official [Core 1.1.1](https://github.com/Instinctes/nightfall/releases/tag/v1.1.1) activates new consensus rules at **Mainnet block 500,000**. The Beta 5 p2 download on this page still bundles Core **1.0.11** and **must be upgraded before block 500,000**. It will not follow the correct chain after activation. A fork-compatible Linux GPU miner is being validated; **do not simply replace the included Core binary**, because this miner needs its customized GPU RPC. No chain reset, new wallet or mining algorithm change is required.


Supports precompiled **NVIDIA CUDA** mining alongside optimized CPU mining. **AMD ROCm/HIP is included as an experimental preview**, not yet tested on physical AMD hardware.

**GPU developer fee: 4.5% of completed GPU work. CPU developer fee: 0%.** This is an independent community miner, not an official Nightfall Core release.

## 🚀 Start mining on Linux (NVIDIA)

You need a compatible NVIDIA GPU and working driver, an internet connection, and **your public `nf1...` NIGHT payout address**. No CUDA Toolkit or programming is needed.

### Step 1 — Download, unpack and test

**Copy and paste this entire block into your Linux terminal.** It downloads the miner directly from GitHub, verifies its checksum, extracts it and runs the self-test.

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

You should see **`NIGHTFALL_MINER_PACKAGE_SELFTEST_PASS`**. If a download, checksum or self-test fails, **do not install**; check the error first.

**Prefer downloading files manually?** [Miner (.tar.gz)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.5-p2/nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz) · [SHA-256 checksum](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.5-p2/nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz.sha256).

### Step 2 — Install and start

Run this **in the extracted miner folder**. It detects whether you are using a normal Linux account or `root` and chooses the correct installation mode automatically.

```bash
read -r -p "Your public NIGHT payout address (nf1...): " ADDR

MODE="--user"
[ "$(id -u)" -eq 0 ] && MODE="--system"

bash install.sh "$MODE" --address "$ADDR"
```

**That's it!** The installer checks the hardware, prepares the Nightfall node and starts the miner. On a completely new machine, it may take a while to download/synchronize the blockchain and verify peers before GPU mining begins.

> **Using `root` in a rental/container?** The commands above automatically select `--system`. Do not use `--user` as root. The normal-user installation needs **no `sudo`**.

### Step 3 — View your mining dashboard

```bash
if [ "$(id -u)" -eq 0 ]; then
  /opt/nightfall-miner/mine
else
  "$HOME/.local/bin/mine"
fi
```

To manage mining, use these commands:

| Action | Normal Linux user | Root / system installation |
| --- | --- | --- |
| Check status | `~/.local/bin/minerctl status` | `/opt/nightfall-miner/minerctl status` |
| Stop mining | `~/.local/bin/minerctl stop` | `/opt/nightfall-miner/minerctl stop` |
| Start again | `~/.local/bin/minerctl start` | `/opt/nightfall-miner/minerctl start` |
| Check for problems | `~/.local/bin/minerctl doctor` | `/opt/nightfall-miner/minerctl doctor` |

Closing the dashboard is **not** the same as stopping the miner; use `minerctl stop` when you want to stop mining.

## 🟥 AMD GPUs — experimental

The package includes AMD HIP workers for `gfx1030`, `gfx1100`, `gfx1101` and `gfx1200`.

**AMD mining has NOT been verified on a physical AMD GPU by the publisher.** A compatible GPU, installed ROCm driver/runtime and `rocminfo` are required. The installer performs an on-device hash correctness test before mining. Performance, stability and Mainnet acceptance are unverified.

After completing **Step 1**, use this command **instead of the NVIDIA installation in Step 2**:

```bash
read -r -p "Your public NIGHT payout address (nf1...): " ADDR
MODE="--user"
[ "$(id -u)" -eq 0 ] && MODE="--system"
bash install.sh --gpu-backend amd "$MODE" --address "$ADDR"
```

AMD is currently intended for **fresh installations on an empty app/chain directory**, not switching an existing NVIDIA installation to AMD.

## 🔄 Already running an older version?

**Do not run a fresh installation over an existing miner.** Stop the miner, download and verify the latest package using **Step 1**, then follow the [upgrade instructions](docs/RELEASE_NOTES_BETA5_P2.md#upgrade-an-existing-linux-installation). The upgrade preserves existing chain data, wallet payout settings, GPU fee accounting and logs.

## Features and support

- **12 NVIDIA CUDA GPU architectures** (Maxwell to Blackwell), with GPU + CPU mining.
- Nightfall Core **1.0.11**, FastSync, and a canonical network guard that pauses mining until sufficient peer agreement is available.
- Terminal dashboard and optional localhost browser dashboard, including **30-minute, 6-hour and 24-hour** mining statistics.
- Safe upgrade/rollback, health diagnostics and protected native-controller integrity checks.
- Hardware-dependent performance: an earlier NVIDIA Beta 5 test on an RTX 3080 reached approximately **9.1 kH/s**. These figures are user-reported and not guaranteed for every card or driver; AMD has no verified benchmark yet.

[Full installation and upgrade guide](docs/RELEASE_NOTES_BETA5_P2.md) ·
[Troubleshooting](docs/TROUBLESHOOTING.md) ·
[Historical benchmarks](docs/HISTORICAL_BENCHMARKS.md) ·
[Report an issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues)

**Download safety:** Use the actual release `.tar.gz` asset, not GitHub's automatically generated *Source code* ZIP. The expected archive SHA-256 is
`bb31b66d94354e625add8030cd36824aaf9bab0afff5eb00ed9f3208633a8012`.
Only a **public payout address** is required; **never share your wallet seed or private key**.

The public [`installer/` directory](installer/) contains **old Beta 2 review copies** and is **not** the current installer. Run the `install.sh` from the **verified, downloaded Beta 5 p2 archive**. First-party materials remain [MIT-licensed](LICENSE); third-party notices are bundled with the release. Mining rewards are not guaranteed.
