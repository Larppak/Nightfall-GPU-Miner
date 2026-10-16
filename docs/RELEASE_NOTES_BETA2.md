# Nightfall GPU Miner v1.3.8 RC3 Beta 2 — Core 1.0.6 and Rootless Installation

An update to the independent Linux x86-64 Nightfall GPU + CPU miner.
**The default installation no longer needs sudo.** This is a limited beta,
not an official NIGHTFALLCOIN Core release.

## What's new

- **Nightfall Core 1.0.6:** customized node with upstream sync and fork-recovery
  improvements, while preserving the existing GPU mining RPC and optimized CPU backend.
- **Rootless by default:** installs under `~/.local/share/` and commands in
  `~/.local/bin/` without changing system packages or requiring administrator
  permissions. The installer prints its plan and missing dependencies.
- **Reviewable installer:** the exact installation and upgrade helper source
  can be read in this repository before running the release archive.
- **Safe upgrade and rollback:** preserves chain data, payout settings and
  developer-fee counters, and refuses to overwrite unknown files or active services.
- **Unchanged GPU workers and protected controller:** the twelve existing CUDA
  architecture workers and fee/controller binaries are byte-identical to Beta 1.
- **Fees unchanged:** 4.5% of ordinary-user GPU mining work, 0% CPU fee.
  First-party miner software remains MIT-licensed; third-party terms apply.

## Quick start — Ubuntu 24.04 x86-64

Download the two release assets and verify the SHA-256 file before extracting:

```bash
sha256sum -c nightfall-miner-v1.3.8-rc3-beta.2-linux-x86_64.tar.gz.sha256
tar -xzf nightfall-miner-v1.3.8-rc3-beta.2-linux-x86_64.tar.gz
cd nightfall-miner-v1.3.8-rc3-beta.2
bash selftest.sh
bash install.sh --user --address "nf1YOUR_PUBLIC_PAYOUT_ADDRESS"
export PATH="$HOME/.local/bin:$PATH"
mine
```

No wallet seed or private key is needed. Use only a public `nf1...`
receiving address. A working NVIDIA driver is required; CUDA Toolkit /
`nvcc` is not.

For an existing installation, **stop mining first** and follow the
[upgrade guide](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/BETA2_UPGRADE.md).
A previous root-owned Beta 1 installation in `/opt` cannot silently
become user-owned; the system administrator must handle ownership/migration
deliberately.

## Validation and known limitations

- **39 Core tests and 25 native fee/controller regressions passed**.
- Rootless install, start/stop/restart, local dashboard, devnet CPU+GPU,
  upgrade/rollback, and short mainnet synchronization checks passed.
- The maintainer additionally reports successful mining using existing
  trusted FastState data. This user-reported test is not a new independent
  long-duration mainnet hashrate measurement.
- On GTX 1070, paired GPU throughput changed **−0.056%** vs Beta 1,
  within measured variation.
- The recorded fresh-mainnet smoke test did **not** reach network tip and
  logged two transient RPC timeouts while catching up. It correctly kept
  mining paused until canonical synchronization.
- Rootless testing was on **Ubuntu 24.04 WSL with GTX 1070**. Other GPU
  models, older driver families, bare-metal OS installs and long-duration
  mainnet effective hashrate were not retested for Beta 2.
- Bundled Core needs **glibc 2.39**. Older Linux versions require an
  explicit, separately provisioned source-build route; there is no
  automatic `apt`/Rustup installer in user mode.
- NVIDIA native worker architectures remain
  `sm_50/52/60/61/70/75/80/86/89/90/100/120`, but presence of an
  architecture binary does not certify the GPU model.

## Downloads and integrity

Download these **two Release assets**, not GitHub's automatically generated
“Source code” ZIP/TAR:

- `nightfall-miner-v1.3.8-rc3-beta.2-linux-x86_64.tar.gz`
- `nightfall-miner-v1.3.8-rc3-beta.2-linux-x86_64.tar.gz.sha256`

**Archive SHA-256:**

`032414655229e3396bce107d4d57cc2afe43d74b96a0ed000a315f943bf9284f`

Verification and install details:
[Beta 2 Quickstart](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/BETA2_QUICKSTART.md) ·
[Beta 2 Compatibility](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/BETA2_COMPATIBILITY.md) ·
[Review installation script](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/installer/install.sh) ·
[Report an issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues)

**Security note:** No-sudo installation reduces system privileges, but a
miner running under your normal Linux user can still access files readable
by that account. A dedicated user or separate mining machine is recommended.

MIT-licensed first-party components; upstream Nightfall Core and all other
bundled third-party components retain their respective licenses.
