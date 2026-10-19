# Nightfall GPU Miner

```text
 _   _ _       _     _    __       _ _   __  __ _                 
| \ | (_)     | |   | |  / _|     | | | |  \/  (_)                
|  \| |_  __ _| |__ | |_| |_ __ _ | | | | \  / |_ _ __   ___ _ __ 
| . ` | |/ _` | '_ \| __|  _/ _` || | | | |\/| | | '_ \ / _ \ '__|
| |\  | | (_| | | | | |_| || (_| || | | | |  | | | | | |  __/ |   
|_| \_|_|\__, |_| |_|\__|_| \__,_||_|_| |_|  |_|_|_| |_|\___|_|   
          __/ |                                                    
         |___/                                                     
```

![Platform](https://img.shields.io/badge/platform-Linux%20x86__64-lightgrey)
[![GPU](https://img.shields.io/badge/GPU-NVIDIA%20CUDA-76B900)](https://developer.nvidia.com/cuda-toolkit)
[![Nightfall Core](https://img.shields.io/badge/Nightfall%20Core-v1.0.7-green)](https://github.com/Instinctes/nightfall)
[![Status](https://img.shields.io/badge/status-RC3%20limited%20beta-blue)](https://github.com/Larppak/Nightfall-GPU-Miner/releases)

**Nightfall GPU Miner** is an independent, high-performance **NVIDIA CUDA + CPU** miner for **NIGHTFALLCOIN (NIGHT)**, built around a customized Nightfall Core v1.0.7. It combines GPU acceleration, CPU mining, multi-GPU support, hardware autotuning, fast synchronization and live monitoring.

**Fees:** 4.5% of GPU hashes to support ongoing development; **CPU mining has no developer fee**. This is an independent community miner, **not an official Nightfall Core release**.

## 🌌 About NIGHTFALLCOIN (NIGHT)

[NIGHTFALLCOIN](https://nightfallcoin.org/) is a privacy-focused, fair-launch Proof-of-Work cryptocurrency with a 90 million NIGHT supply cap. It uses the memory-hard **Nighthash-v2 (Argon2id)** mining algorithm.

[Official website](https://nightfallcoin.org/) · [Web wallet](https://wallet.nightfallcoin.org/) · [Nightfall Core](https://github.com/Instinctes/nightfall)

**Interested in building your own GPU miner?** Check out [GPU Mining Concept](GPU_MINING_CONCEPT.md) for a short explanation of Nighthash-v2, GPU memory parallelism, and an educational CUDA-style example. This is not the source code of the released miner or a security audit of its binaries.

## 🆕 Beta 3 — Core 1.0.7 & Safer Sync

**Beta 3 is available** as a Linux x86-64 pre-release. It updates the
customized node to **Nightfall Core 1.0.7**, improves deep-fork and IBD
handling, and hardens process isolation. The protected NVIDIA CUDA workers and
fee-controller binaries remain unchanged from Beta 2.

Rootless installation on Ubuntu 24.04 is supported. Only a **public** `nf1...`
payout address is required; never provide a wallet seed or private key.

[Beta 3 release notes](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.3) ·
[Previous Beta 2 release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.2)

**Installer review note:** The public [installer](installer/install.sh) and
[upgrade helper](installer/safe_upgrade.py) are **Beta 2 review copies**.
For Beta 3, use the verified scripts and instructions inside the release archive.

## 📥 GPU Miner Downloads & Releases

**Latest: Nightfall GPU Miner v1.3.8 RC3 Beta 3 — Linux x86-64 (Pre-release)**

- 📦 **[Download Beta 3 miner (.tar.gz)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.3/nightfall-miner-v1.3.8-rc3-beta.3-linux-x86_64.tar.gz)**
- 🔐 **[Download Beta 3 SHA-256 checksum (.sha256)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.3/nightfall-miner-v1.3.8-rc3-beta.3-linux-x86_64.tar.gz.sha256)**

**Beta 3 archive SHA-256:** `f7cfec8dbdbc5fc5f53a1594a3528f55a68f8f4a75df8f6930dc80be0cef9f4c`

The precompiled NVIDIA CUDA workers require a compatible driver, but no CUDA
Toolkit. Ubuntu 24.04 x86-64 is recommended.

**Important:** GitHub's automatically generated **"Source code" ZIP/TAR** files
are public repository snapshots, **not the executable miner**. Download the two
Beta 3 release assets above.

**Previous release:** [Beta 2](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.2).
For existing installations, follow `UPGRADE.md` inside the Beta 3 archive.

## Quickstart

**Recommended:** Ubuntu 24.04 x86-64, a compatible NVIDIA proprietary driver,
and a normal (non-root) Linux user. Download **both Beta 3 files** to the same
directory, then:

```bash
sha256sum -c nightfall-miner-v1.3.8-rc3-beta.3-linux-x86_64.tar.gz.sha256
tar -xzf nightfall-miner-v1.3.8-rc3-beta.3-linux-x86_64.tar.gz
cd nightfall-miner-v1.3.8-rc3-beta.3
bash selftest.sh
bash install.sh --user --address "nf1YOUR_PUBLIC_PAYOUT_ADDRESS" --plan
bash install.sh --user --address "nf1YOUR_PUBLIC_PAYOUT_ADDRESS"
export PATH="$HOME/.local/bin:$PATH"
mine
```

The rootless installer reports missing dependencies rather than installing
system packages. For root-only GPU rental containers, use `--system` instead
of `--user`.

**Already installed?** Do not run a fresh install over existing miner data.
Stop the old miner and follow the **Beta 3 archive's** `UPGRADE.md` to preserve
chain data, payout settings and fee counters.

**Sync note:** Mining starts automatically only after canonical network
verification. Trusted FastState import is described in the archive's
`FASTSYNC.md`.

## Key Advantages

- 🚀 **High hashrate:** Earlier results include RTX 5060 Ti ~5.92 kH/s and RTX 3070 ~4.66 kH/s (hardware dependent).
- 🔒 **Precompiled CUDA:** Architecture-specific native GPU workers; CUDA kernel source is not included and no local CUDA compiler is required.
- 🛡️ **Canonical sync guard:** Pauses mining when local chain state cannot be confirmed against peers.
- ⏩ **FastSync & FastState:** Fast bootstrap initialization and optional transfer of a recent trusted chain snapshot.
- 🖥️ **Multi-GPU:** Parallel mining across supported NVIDIA GPUs, with device-specific settings.
- 📊 **Live dashboards:** GPU/CPU hashrate, temperatures, power, blocks, rewards and developer fee status.
- ⚙️ **Autotuning:** GPU batch sizes and CPU thread counts tuned for the installed hardware.
- 💎 **Transparent fees:** 4.5% GPU developer fee, 0% CPU fee, with live fee reporting.

## Hardware Benchmarks

**Historical development measurements, not RC3 release benchmarks.** The results below come from earlier v1.3.8 development/mainnet testing. Only the separate **RC3 paired worker tests** table provides measured RC3 binary results. Speeds depend on GPU model, power limits, clock settings, drivers and network conditions.

### Multi-GPU

| Configuration | Reported hashrate | Reported GPU power |
| --- | ---: | ---: |
| Dual RTX A4000 (2 × 16 GB) | **8.90 kH/s** | 280 W combined |
| Dual GTX 1660 SUPER (2 × 6 GB) | **8.05 kH/s** | 245 W combined |

### Single NVIDIA GPUs

| GPU | Reported hashrate | Notes |
| --- | ---: | --- |
| RTX 4070 Ti SUPER 16 GB | **9.08 kH/s** | 92 W instantaneous power reading; not a sustained power average |
| RTX 5060 Ti 16 GB | **5.92 kH/s** | Blackwell (`sm_120`) |
| Quadro RTX 5000 16 GB | **5.42 kH/s** | Turing (`sm_75`) |
| GeForce RTX 2070 8 GB | **5.34 kH/s** | Turing (`sm_75`) |
| GeForce GTX 1080 Ti 11 GB | **5.28 kH/s** | Pascal (`sm_61`) |
| GeForce RTX 3070 8 GB | **4.66 kH/s** | Ampere (`sm_86`) |
| TITAN Xp 12 GB | **2.81–5.50 kH/s** | Varies substantially with power limit |

### RC3 paired worker tests

The following were measured on the same GPU in paired offline worker tests. They do **not** measure full-window live effective hashrate.

| GPU | Architecture | RC3 GPU rate | Change vs RC2 |
| --- | --- | ---: | ---: |
| GTX 1070 | sm_61 | 2.60 kH/s | −0.15% |
| RTX 2080 Ti* | sm_75 | 4.61 kH/s | +0.56% |
| RTX 3070 | sm_86 | 4.68 kH/s | +0.004% |
| Quadro RTX 5000 | sm_75 | 5.40 kH/s | +0.003% |
| RTX 4060 Ti 16 GB | sm_89 | 4.17 kH/s | −0.008% |

*The RTX 2080 Ti rental reported 22 GiB VRAM; the test should not be generalized to a stock 11 GiB model. The Quadro and RTX 4060 Ti numbers used their autotuned batches, unlike the batch-128 results above.*

In short RC3 mainnet tests, Quadro RTX 5000 and RTX 4060 Ti had **52 locally accepted GPU submissions** and no locally rejected submissions. An **RTX 5070 (Blackwell, sm_120)** separately passed an installation and synchronization smoke test, **not sustained GPU mining or a hashrate benchmark**. These results do not establish finalized rewards, long-term reliability or real mixed-GPU coverage. The Quadro/4060 Ti sessions used the developer address; ordinary-user 4.5% fee accrual was not live-tested in those sessions.

[Beta 2 compatibility and test limits](docs/BETA2_COMPATIBILITY.md). [Historical Beta 1 GPU test details](docs/COMPATIBILITY.md).

### CPU Mining

| CPU | Reported hashrate |
| --- | ---: |
| AMD EPYC 7D12 | 520–674 H/s |
| Intel Xeon E5 series | 115–635 H/s, depending on model/configuration |
| AMD EPYC 7272 | 358 H/s |
| Intel Core i7 (8th generation) | 258 H/s |

**Measured and estimated data must not be mixed.** Future architecture projections have intentionally been left out of this table.

## 🛠️ Requirements

- **OS:** Ubuntu 24.04 x86-64 recommended for Beta 3. Bundled Core 1.0.7 requires glibc 2.39 or newer. See the release archive's `COMPATIBILITY.md`.
- **GPU:** Supported NVIDIA card and compatible proprietary driver (check with `nvidia-smi`).
- **CUDA:** Beta 3 includes the same precompiled native CUDA workers as Beta 2, so no `nvcc`/CUDA Toolkit is needed on the miner host. A compatible NVIDIA driver is required.
- **Wallet:** A public `nf1...` payout address; no seed phrase or private key is required.
- **Rust:** Not needed for the recommended Ubuntu 24.04 prebuilt Core 1.0.7 path. Older Linux systems may require an explicit source build with separately installed build tools.

Windows and AMD GPU mining are not currently advertised as supported.


## 📊 Live Dashboard

Run `mine` to monitor GPU/CPU hashrate, temperatures, power, block activity and developer-fee accounting from the terminal.

## Command Reference

| Command | Function |
| --- | --- |
| `mine` | Live terminal dashboard |
| `minerctl status` | Mining and network status |
| `minerctl doctor` | Health diagnostics |
| `minerctl blocks 20` | Recent blocks and confirmations |
| `minerctl autotune --apply` | GPU/CPU tuning |
| `minerctl fastsync-info` | Current chain bootstrap / snapshot details |
| `minerctl dev-fee-status` | GPU fee accounting |
| `minerctl restart` | Restart miner services |
| `minerctl web-start` | Start local browser dashboard |

For mixed-GPU rigs, the miner supports selecting devices and configuring their batch sizes separately. **Not every mixed-generation GPU setup has been validated on Beta 3.** See `COMPATIBILITY.md` in the release archive.

## Multi-GPU Setup

Multiple supported NVIDIA GPUs can mine concurrently. Identify the cards with:

```bash
$HOME/.local/bin/minerctl hardware
```

To select specific devices on a user-mode rig, edit `~/.local/share/nightfall-miner/config.env`:

```bash
NIGHTFALL_CUDA_DEVICES="0,1"
# Optional per-device batch sizes for GPUs with different VRAM:
# NIGHTFALL_CUDA_BATCHES="256,128"
```

Then restart with `minerctl restart`. Individual GPU tuning and mixed-GPU operation should be confirmed against the final release's compatibility matrix.

## FastSync & FastState

**Default FastSync:** The installer downloads the official Nightfall chain bootstrap, verifies its SHA-256 and uses it as a trusted historical anchor. Historical blocks through that anchor are not individually reverified locally; subsequent network data is verified normally. The node still needs to catch up to the current chain tip and confirm canonical peer agreement before mining starts.

**FastState (optional):** For repeated deployments or GPU rental rigs, import a recent canonical snapshot from a fully synchronized, trusted Nightfall Miner installation. A compatible miner can export one using `minerctl faststate-create` and import it through the installer's `--faststate PATH` argument. Snapshot creation, transfer and import take time; a fresh snapshot can greatly reduce network catch-up, but fast mining start is not guaranteed.

After installing, useful checks include:

```bash
minerctl canonical-check 180 3
minerctl fastsync-info
minerctl sync-watch 2
```

The canonical guard waits for an acceptable live network state before enabling mining. Do not use arbitrary untrusted snapshots.

## Developer Fee (4.5%)

The developer fee applies **only to completed GPU mining work**. **First-party miner software is MIT-licensed**, including the separately distributed compiled binaries. MIT rights allow users to modify and redistribute covered first-party software; the fee describes how the unmodified miner operates. CPU mining remains fee-free. The miner's dashboard reports the target and observed GPU fee percentages and displays USER/DEV payout identities. The displayed percentage may fluctuate slightly around 4.5% over short periods because work is processed in batches.

The protected orchestration component is distributed as a compiled executable; surrounding tools and third-party components retain their respective licensing terms. This design makes casual source extraction more difficult, but no software running on a user's own machine can be considered impossible to reverse-engineer.

## FAQ

**Can I mine on CPU and GPU simultaneously?** Yes. CPU mining and supported NVIDIA GPU mining can run together. CPU has no developer fee.

**Do I need a new wallet?** No. You can use your existing public `nf1...` reward address. Never share a wallet seed or private key.

**Does FastSync mean mining starts in 60 seconds?** Not necessarily. Installation, chain catch-up and canonical network verification can take longer; the fastest route is a recent verified FastState snapshot on an already-prepared machine.

**What if the miner shows `SYNCING_SAFE_WAIT`?** The node is waiting for verified chain agreement. Monitor with `minerctl sync-watch 2` rather than forcing mining on an unconfirmed tip.

## License & Support

- [MIT license for first-party software and documentation](LICENSE)
- Third-party licenses and attribution are included with the actual release archive.
- [Changes](CHANGELOG.md)
- [Latest Beta 3 release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.3)
- [Beta 2 release notes (historical)](docs/RELEASE_NOTES_BETA2.md)
- [Beta 2 rootless quick start (historical)](docs/BETA2_QUICKSTART.md)
- [Beta 2 upgrade / rollback guide (historical)](docs/BETA2_UPGRADE.md)
- [Beta 2 compatibility (historical)](docs/BETA2_COMPATIBILITY.md)
- [Beta 1 historical release notes](docs/RELEASE_NOTES_RC3_BETA.md)
- [Beta 1 historical installation guide](docs/INSTALL.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Report an issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues)

The developer fee and independent-project status are disclosed above. Nightfall Core and other bundled dependencies remain subject to their original licenses. This repository contains **documentation and release links only**; approved miner archives are supplied as verified GitHub Release assets. 

**Current Beta 3 archive SHA-256:** `f7cfec8dbdbc5fc5f53a1594a3528f55a68f8f4a75df8f6930dc80be0cef9f4c`

**Previous Beta 2 archive SHA-256:** `032414655229e3396bce107d4d57cc2afe43d74b96a0ed000a315f943bf9284f`

**Previous Beta 1 archive SHA-256:** `6b94518283bd777518f0968745c509f94d16e8c46b0f01c02b4b152d55cb991f`
