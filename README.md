<div align="center">

# Nightfall GPU Miner

<img src="assets/nightfall-miami-vice-banner.svg" alt="Nightfall GPU Miner — NVIDIA GPU + CPU mining for Nightfall" width="100%">

**Mine NIGHTFALLCOIN (NIGHT) on Linux using your NVIDIA GPU and CPU.**

Easy installation, automatic blockchain syncing, and a live mining dashboard. **After installation, just type `mine` to open the dashboard.** Prebuilt CUDA workers mean **no CUDA Toolkit or compiling required**.

**Latest: V2 · Nightfall Core 1.1.2 · Linux x86-64 · Beta**

**[Download V2 for Linux (.run)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/V2/nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run)** · [SHA-256 checksum](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/V2/nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run.sha256) · [What's new in V2](docs/RELEASE_NOTES_V2_CORE112.md)

</div>

> **Linux only.** Ubuntu 24.04 (64-bit) and a compatible NVIDIA driver are recommended. AMD HIP is included as an **untested experimental preview**. Windows is not included.
>
> This is an independent community beta, **not the official Nightfall Core miner**.

---

## New user? Install in 2 steps

You'll need a **public NIGHT payout address** (starts with `nf1`).

> Never enter your wallet's recovery phrase or private key.

### 1. Download and check the miner

Copy this into an Ubuntu/Linux terminal:

```bash
mkdir -p "$HOME/nightfall-download" && cd "$HOME/nightfall-download"
FILE=nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run
URL=https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/V2

curl -fL --retry 3 -o "$FILE" "$URL/$FILE" &&
curl -fL --retry 3 -o "$FILE.sha256" "$URL/$FILE.sha256" &&
sha256sum -c "$FILE.sha256" &&
bash "$FILE" --verify
```

Look for **`ONEFILE_BETA6_PACKAGE_SELFTEST_PASS`** (the internal self-test name is retained in V2).

> If the checksum or self-test fails, **do not install**.

### 2. Install

In the same terminal and download folder:

```bash
read -r -p "Your public NIGHT payout address (nf1...): " ADDR
bash "$FILE" --install --address "$ADDR"
```

The installer uses your current Linux account (no `sudo` required for a normal-user installation).

**Installation complete? Open your dashboard:**

```bash
mine
```

Your node syncs with the network first; mining starts when the chain is ready and peers agree.

> **`SYNCING_SAFE_WAIT` is normal while syncing.**

---

## Already mining? Upgrade to V2

Your existing blockchain, payout settings, mining history and GPU fee records are preserved by the supported upgrade process.

> **Use the same Linux account that installed the miner.**

First complete **Step 1 above** to download and verify V2.

**Stop the old miner and preview the upgrade:**

```bash
CTL="$HOME/.local/bin/minerctl"
[ "$(id -u)" -eq 0 ] && CTL=/opt/nightfall-miner/minerctl

"$CTL" stop
bash "$FILE" --upgrade --plan
```

Check the installation and blockchain paths shown by the plan. If everything is correct:

```bash
bash "$FILE" --upgrade
"$CTL" start
"$CTL" doctor
```

Using a custom installation folder? Add your original `--prefix PATH` to **both** upgrade commands and use its matching `minerctl`.

> **Don't replace the Core executable manually or upgrade while mining is running.**

---

## Open your mining dashboard

After installation, open the live dashboard with **one command**:

```bash
mine
```

The dashboard shows GPU and CPU hashrates, blockchain synchronization, mining status, and performance statistics. It also works while the node is syncing: `SYNCING_SAFE_WAIT` means mining is safely paused until the chain is ready.

Press `Q` or `Ctrl+C` to close **only the dashboard**. Mining and node synchronization continue in the background.

For advanced controls, use your installation's `minerctl` (`status`, `doctor`, `start`, or `stop`). See [Troubleshooting](docs/TROUBLESHOOTING.md) for the full command paths.

---

## Example NVIDIA GPU hashrates

These are **approximate historical NIGHT mining results**, collected across different miner versions, GPUs and test conditions. They are **not guaranteed V2 performance** or expected mining rewards.

| NVIDIA GPU | Approx. hashrate | Source |
| --- | ---: | --- |
| GTX 1070 | 2.60 kH/s | RC3 offline worker test |
| GTX 1660 Ti | 3.45 kH/s | User-reported measurement |
| RTX 3060 | 4.80 kH/s | User-reported measurement |
| RTX 3070 | 4.68 kH/s | RC3 offline worker test |
| RTX 4060 Ti 16 GB | 4.17 kH/s | RC3 offline worker test |
| Quadro RTX 5000 | 5.40 kH/s | RC3 offline worker test |
| RTX 5060 Ti 16 GB | 5.92 kH/s | Earlier development measurement |
| RTX 4070 Ti SUPER | 9.08 kH/s | Earlier development measurement |

**Results are not directly comparable:** some are offline worker measurements and others are field observations. Raw GPU hashrate, effective hashrate and actual rewards may differ because of GPU tuning, power limits, driver versions, node synchronization, stale work and mining luck. See [historical benchmarks](docs/HISTORICAL_BENCHMARKS.md) and [compatibility/test scope](docs/COMPATIBILITY.md) for more context.

---

## Good to know

- **NVIDIA CUDA + CPU:** precompiled workers for multiple GPU generations. You need a compatible driver, not a local CUDA Toolkit.
- **Nightfall Core 1.1.2:** better blockchain sync, fork recovery and storage handling. The required Mainnet upgrade at block **500,000** is included.
- **Developer fee:** **4.5% of completed GPU mining work**; **0% on CPU mining**.
- **AMD HIP:** experimental and **not tested on physical AMD GPUs**. Not recommended for beginners.
- **Beta:** GTX 1660 SUPER V2 startup/integrity testing passed, but long Mainnet mining performance and rewards are **not guaranteed**.

**Need help?** [Troubleshooting](docs/TROUBLESHOOTING.md) · [Full V2 release notes](docs/RELEASE_NOTES_V2_CORE112.md) · [Report a problem](https://github.com/Larppak/Nightfall-GPU-Miner/issues) · [License](LICENSE)

> *Important: GitHub's automatically generated “Source code (zip)” and “Source code (tar.gz)” files are **not** the ready-to-run miner. Download the `.run` file linked above.*
