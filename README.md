# Nightfall GPU Miner V2

**Linux NVIDIA GPU + CPU miner for NIGHTFALLCOIN (NIGHT).**

[![Linux](https://img.shields.io/badge/Linux-x86__64-blue)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/V2)
[![NVIDIA CUDA](https://img.shields.io/badge/NVIDIA-CUDA-76B900)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/V2)
![AMD experimental](https://img.shields.io/badge/AMD_HIP-experimental-orange)
[![Download V2](https://img.shields.io/badge/Download-V2-blue)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/V2)

**Latest release: [Nightfall GPU Miner V2 — Core 1.1.2](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/V2)**

Linux x86-64 · Ubuntu 24.04 recommended · Independent **pre-release**, not official Nightfall Core software.

**One-file download:** precompiled NVIDIA CUDA workers for 12 GPU architectures, CPU mining, automatic sync safety guard, optional AMD HIP preview, safe upgrade and rollback. No CUDA Toolkit or Rust compilation needed for the normal installation.

## Download and verify

**[Download V2 Linux miner (.run)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/V2/nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run)** · **[SHA-256 checksum](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/V2/nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run.sha256)** · [V2 release notes](docs/RELEASE_NOTES_V2_CORE112.md)

Copy into your Linux terminal:

```bash
mkdir -p "$HOME/nightfall-download" && cd "$HOME/nightfall-download"
FILE=nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run
URL=https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/V2

curl -fL --retry 3 -o "$FILE" "$URL/$FILE" &&
curl -fL --retry 3 -o "$FILE.sha256" "$URL/$FILE.sha256" &&
sha256sum -c "$FILE.sha256" &&
bash "$FILE" --verify
```

Expected result: `ONEFILE_BETA6_PACKAGE_SELFTEST_PASS`. **Do not install if the SHA-256 or package self-test fails.**

Verified V2 `.run` SHA-256:

```text
5d6e4935be8ab677b28502dc4f9f8494fc4f12c8dc849788cac31e64f4df5700
```

The internal package version is `1.3.8-rc3-beta.6-p1`; the public GitHub release tag is simply **`V2`**. These names are intentional.

## New installation

Run in the directory containing the verified `.run` file. You need a compatible NVIDIA GPU and driver, network access, and your **public NIGHT payout address**.

```bash
FILE=nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run
read -r -p "Public NIGHT address (nf1...): " ADDR
bash "$FILE" --install --address "$ADDR"
```

The installer selects a normal-user installation or root/system installation according to your Linux account. The node synchronizes first. The canonical-chain guard holds mining in `SYNCING_SAFE_WAIT` until it is safe to begin.

**Never provide your wallet seed, recovery phrase, private key or exchange credentials.**

## Upgrade from Beta 6 (Core 1.1.1)

**Stop → review upgrade plan → upgrade → restart.** Existing blockchain data, payout configuration, mining history and GPU-fee accounting are retained. Use the same account that installed the previous version, and run these commands from the V2 download directory.

```bash
FILE=nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run
CTL="$HOME/.local/bin/minerctl"
[ "$(id -u)" -eq 0 ] && CTL=/opt/nightfall-miner/minerctl

"$CTL" stop
bash "$FILE" --upgrade --plan
```

**Check the existing application and blockchain paths printed by the plan.** If correct:

```bash
bash "$FILE" --upgrade
"$CTL" start
"$CTL" doctor
```

If the previous installation used a custom `--prefix PATH`, supply that original prefix to **both** upgrade commands and use its matching `minerctl`. Do not install over a running node or replace the Core executable manually.

## Monitor your miner

After installation, on a normal-user account use `~/.local/bin/minerctl`; for root/system installations use `/opt/nightfall-miner/minerctl`.

```bash
"$CTL" status
"$CTL" doctor
"$CTL" dashboard 5
```

Dashboard `Ctrl+C` closes only the display; use `"$CTL" stop` to stop mining.

## V2 changes and limitations

- **Core 1.1.2** improves initial blockchain sync (short IBD pages), peer-specific reorg recovery, crash durability of blockchain storage, and light API validation.
- **Same Nightfall PoW and GPU kernels** as the previous Beta 6, including the Mainnet binding consensus activation at height 500,000.
- **GPU developer fee: 4.5% of completed GPU work. CPU developer fee: 0%.** Fee shares settle over multiple jobs, not necessarily each individual batch.
- GTX 1660 SUPER has passed V2 startup and integrity diagnostics. Core 1.1.2 passed private consensus, storage, IBD and GPU USER/DEV DEVNET tests. Extended multi-GPU Mainnet acceptance and developer-fee convergence are not yet independently demonstrated; no accepted Mainnet block is claimed.
- **AMD HIP is experimental**: included AMD workers have not been physically validated. Windows is **not** included in this Linux release.
- Independent community beta software; uptime, GPU compatibility, hashrate and mining rewards are not guaranteed.

[Full V2 release notes](docs/RELEASE_NOTES_V2_CORE112.md) · [Report an issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues) · [License and third-party notices](LICENSE) · [Previous Beta 6](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.6)

**Important — GitHub automatically lists “Source code (zip)” and “Source code (tar.gz)” for every release. These are repository snapshots, NOT the working GPU miner. Download only the verified `.run` asset above. The self-extracting package is not encryption.**
