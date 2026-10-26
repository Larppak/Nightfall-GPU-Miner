# Nightfall GPU Miner

[![Linux x86-64](https://img.shields.io/badge/platform-Linux%20x86__64-64748b)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2)
[![NVIDIA CUDA](https://img.shields.io/badge/GPU-NVIDIA%20CUDA-76B900)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2)
[![AMD HIP experimental](https://img.shields.io/badge/AMD%20HIP-experimental-orange)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2)
[![Nightfall Core 1.0.11](https://img.shields.io/badge/Nightfall%20Core-1.0.11-blue)](https://github.com/Instinctes/nightfall)
[![Beta 5 p2](https://img.shields.io/badge/release-Beta%205%20p2-blue)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2)

Independent **NVIDIA GPU + optimized CPU miner** for
[NIGHTFALLCOIN (NIGHT)](https://nightfallcoin.org/), using
**Nightfall Core 1.0.11**. The Linux beta also includes **experimental
AMD ROCm/HIP mining**, which has **not been tested on physical AMD
hardware by the publisher**.

**GPU developer fee: 4.5% of completed GPU work. CPU developer fee: 0%.**
This is a community miner, **not an official Nightfall Core release**.

## Download — latest Beta 5 p2

**[Download the Linux x86-64 miner (.tar.gz)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.5-p2/nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz)** ·
**[Download SHA-256 checksum](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.5-p2/nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz.sha256)** ·
[Release notes](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2)

**SHA-256:** `bb31b66d94354e625add8030cd36824aaf9bab0afff5eb00ed9f3208633a8012`

Use the two named **Release assets** above. GitHub's automatically
generated *Source code* ZIP/TAR archives contain public documentation,
**not the ready-to-run miner**. For the prebuilt Core, **Ubuntu 24.04
x86-64** is recommended.

## Install — NVIDIA + CPU

A supported NVIDIA GPU and working driver are required; no local CUDA
Toolkit or `nvcc` compilation is needed for precompiled workers.

Download the two release assets into the same folder, then run as an
ordinary (non-root) Linux account:

```bash
sha256sum -c nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz.sha256
tar -xzf nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz
cd nightfall-miner-v1.3.8-rc3-beta.5-p2
bash selftest.sh
bash install.sh --user --address 'nf1YOUR_PUBLIC_PAYOUT_ADDRESS' --plan
bash install.sh --user --address 'nf1YOUR_PUBLIC_PAYOUT_ADDRESS'
~/.local/bin/mine
```

Only a **public `nf1...` receiving address** is required. Never enter
a wallet seed phrase, private key or wallet file.

For an intentionally root-operated rental/container installation, use
`--system` instead of `--user`, and control the installed miner using
`/opt/nightfall-miner/minerctl`.

## AMD GPU — experimental

The beta includes four HIP workers: `gfx1030`, `gfx1100`,
`gfx1101` and `gfx1200`. A compatible AMD GPU, ROCm runtime/driver
and `rocminfo` are required before installation. The installer runs
an **on-device correctness check** and refuses to mine if it fails.

**AMD mining is experimental and untested by the publisher on
physical AMD hardware.** GPU hashrate, actual Mainnet acceptance, driver
compatibility and stability are not guaranteed. The initial AMD path
supports fresh, separate installations, not a mixed AMD/NVIDIA rig.

```bash
bash install.sh --gpu-backend amd --user --address 'nf1YOUR_PUBLIC_PAYOUT_ADDRESS' --plan
bash install.sh --gpu-backend amd --user --address 'nf1YOUR_PUBLIC_PAYOUT_ADDRESS'
```

For AMD root/system installations, replace `--user` with `--system`
and use a **fresh, empty** app directory and chain datadir.

## Upgrading an existing miner

**Stop the existing miner first.** Do not perform a fresh install over
the old application or chain state. From the verified new archive use
`--upgrade --plan`, review the preserved data and rollback plan, then
apply the upgrade. For example, an existing root/system installation:

```bash
/opt/nightfall-miner/minerctl stop
bash install.sh --system --upgrade --prefix /opt/nightfall-miner --plan
bash install.sh --system --upgrade --prefix /opt/nightfall-miner
/opt/nightfall-miner/minerctl native-integrity-check
/opt/nightfall-miner/minerctl start
/opt/nightfall-miner/minerctl doctor
```

Run these commands **from inside the extracted latest release folder**.
For rootless installations, use the original user installation prefix
and `--user --upgrade` instead. The upgrade preserves chain data,
public payout settings, GPU fee accounting and mining logs.

[Complete Beta 5 p2 installation and upgrade guide](docs/RELEASE_NOTES_BETA5_P2.md)

## What it includes

| Feature | Details |
| --- | --- |
| GPU mining | 12 precompiled NVIDIA CUDA architectures; 4 experimental AMD HIP targets |
| Hybrid mining | Optimized CPU mining alongside one selected GPU backend |
| Chain safety | Canonical peer agreement guard; pauses mining when chain agreement is insufficient |
| FastSync | SHA-256-verified trusted historical bootstrap, followed by normal network validation |
| Monitoring | Terminal Dashboard and optional loopback-only web Dashboard; 30m / 6h / 24h history |
| Recovery | Safe stopped-service upgrade/rollback, `minerctl doctor`, fee and native-integrity diagnostics |
| Fees | GPU 4.5% work-based developer fee; CPU 0% |

The historical bootstrap anchor is locally trusted rather than having
every block through the anchor individually reverified. The node
checks subsequent blocks and waits for canonical network agreement.

### Useful commands

For a root/system installation, replace `minerctl` below with
`/opt/nightfall-miner/minerctl`.

```bash
~/.local/bin/minerctl status
~/.local/bin/minerctl doctor
~/.local/bin/minerctl native-integrity-check
~/.local/bin/minerctl fee-policy-check
~/.local/bin/minerctl dev-fee-status
~/.local/bin/minerctl fastsync-info
```

### Testing and performance

An earlier NVIDIA Beta 5 field test on a GTX 1660 Ti observed approximately
**3.41 kH/s raw / 3.31 kH/s effective GPU hashrate** on a canonical
Mainnet chain. The Beta 5 p2 CUDA binaries remain unchanged from
that version, but the new p2 launch/integrity path has been tested in
isolated Linux CI rather than in a separate, sustained physical GPU run.
Do not assume those speeds apply to other cards.

[Historical GPU and CPU benchmark measurements](docs/HISTORICAL_BENCHMARKS.md)
are older development observations, not guaranteed Beta 5 p2 benchmarks.
There is **no publisher-verified AMD hashrate** yet.

## Documentation, history and support

- [Latest Beta 5 p2 release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2) ·
  [Detailed release notes](docs/RELEASE_NOTES_BETA5_P2.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md) ·
  [Report a bug or AMD testing result](https://github.com/Larppak/Nightfall-GPU-Miner/issues)
- [Historical benchmarks](docs/HISTORICAL_BENCHMARKS.md) ·
  [GPU mining concept (educational)](GPU_MINING_CONCEPT.md)
- [Older Beta 3 release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.3) ·
  [Earlier Beta 2](docs/RELEASE_NOTES_BETA2.md) and
  [Beta 1](docs/RELEASE_NOTES_RC3_BETA.md) notes

**Important source/installer distinction:** This public repository
primarily hosts **documentation and Release downloads**, not the private
optimized CUDA/HIP or native controller sources. The files under
[`installer/`](installer/) are **historical Beta 2 review copies** and
must not be used to install the current Beta 5 p2. Use `install.sh`,
`selftest.sh` and `UPGRADE.md` **inside the downloaded verified
Beta 5 p2 archive**.

First-party miner software and documentation retain the existing
[MIT license](LICENSE). Third-party software has its own terms and
notices in the release package. Mining rewards are probabilistic and
not guaranteed; local accepted block counters do not necessarily
represent finalized wallet rewards. Local integrity/obfuscation
checks deter casual tampering but do not prevent a machine owner
from modifying the miner.
