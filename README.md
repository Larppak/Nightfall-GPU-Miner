<div align="center">

# Nightfall GPU Miner

<img src="assets/nightfall-miami-vice-banner.svg" alt="Nightfall GPU Miner — NVIDIA GPU + CPU mining for Nightfall" width="100%">

**Mine NIGHTFALLCOIN (NIGHT) on Linux using your NVIDIA GPU and CPU.**

Easy installation, automatic blockchain syncing, and a live mining dashboard. The miner comes with prebuilt CUDA workers — **no CUDA Toolkit or compiling required**.

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

## Check your miner

```bash
CTL="$HOME/.local/bin/minerctl"
[ "$(id -u)" -eq 0 ] && CTL=/opt/nightfall-miner/minerctl

"$CTL" status
"$CTL" doctor
"$CTL" dashboard 5
```

The dashboard updates every 5 seconds. Press `Ctrl+C` to close **only the dashboard**. To control mining, use `"$CTL" stop` or `"$CTL" start`.

---

## Good to know

- **NVIDIA CUDA + CPU:** precompiled workers for multiple GPU generations. You need a compatible driver, not a local CUDA Toolkit.
- **Nightfall Core 1.1.2:** better blockchain sync, fork recovery and storage handling. The required Mainnet upgrade at block **500,000** is included.
- **Developer fee:** **4.5% of completed GPU mining work**; **0% on CPU mining**.
- **AMD HIP:** experimental and **not tested on physical AMD GPUs**. Not recommended for beginners.
- **Beta:** GTX 1660 SUPER V2 startup/integrity testing passed, but long Mainnet mining performance and rewards are **not guaranteed**.

**Need help?** [Troubleshooting](docs/TROUBLESHOOTING.md) · [Full V2 release notes](docs/RELEASE_NOTES_V2_CORE112.md) · [Report a problem](https://github.com/Larppak/Nightfall-GPU-Miner/issues) · [License](LICENSE)

> *Important: GitHub's automatically generated “Source code (zip)” and “Source code (tar.gz)” files are **not** the ready-to-run miner. Download the `.run` file linked above.*
