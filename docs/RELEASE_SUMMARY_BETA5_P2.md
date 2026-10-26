# Nightfall GPU Miner — Beta 5 p2

**Linux x86-64 · Nightfall Core 1.0.11 · NVIDIA CUDA + Experimental AMD HIP**

Independent community miner for NIGHTFALLCOIN (NIGHT). **Pre-release — not an official Nightfall Core release.**

## Download

- **[Download Linux miner (.tar.gz)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.5-p2/nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz)**
- [Download SHA-256 checksum](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.5-p2/nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz.sha256)

**SHA-256:** `bb31b66d94354e625add8030cd36824aaf9bab0afff5eb00ed9f3208633a8012`

## Highlights

- **NVIDIA:** 12 precompiled CUDA GPU targets; optimized CPU + GPU mining.
- **AMD:** four HIP targets (`gfx1030`, `gfx1100`, `gfx1101`, `gfx1200`). **Experimental — not tested on physical AMD hardware.** ROCm is required, and an on-device correctness check runs before mining.
- **Core 1.0.11**, canonical chain guard, FastSync, safe upgrades and mining statistics for 30 min / 6 h / 24 h.
- Hardened native controller with local integrity checks. **GPU developer fee 4.5%; CPU fee 0%.**

## Quick start (NVIDIA)

```bash
sha256sum -c nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz.sha256
tar -xzf nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz
cd nightfall-miner-v1.3.8-rc3-beta.5-p2
bash selftest.sh
bash install.sh --user --address 'nf1YOUR_PUBLIC_PAYOUT_ADDRESS'
~/.local/bin/mine
```

For AMD, replace the installation command with `bash install.sh --gpu-backend amd --user --address 'nf1YOUR_PUBLIC_PAYOUT_ADDRESS'` after installing compatible ROCm drivers. To update an existing installation, **stop mining first and use `--upgrade`** rather than installing over the existing data.

**[Full installation and upgrade guide](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/RELEASE_NOTES_BETA5_P2.md)** · [Report an issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues)

*AMD has not been physically validated by the publisher. Software is provided as-is; mining rewards are not guaranteed. Use a public payout address only — never a wallet seed or private key.*
