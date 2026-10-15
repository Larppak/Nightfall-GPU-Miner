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
[![Nightfall Core](https://img.shields.io/badge/Nightfall%20Core-v1.0.5-green)](https://github.com/Instinctes/nightfall)
[![Status](https://img.shields.io/badge/status-RC3%20limited%20beta-blue)](https://github.com/Larppak/Nightfall-GPU-Miner/releases)

**Nightfall GPU Miner** is an independent, high-performance **NVIDIA CUDA + CPU** miner for **NIGHTFALLCOIN (NIGHT)**, built around Nightfall Core v1.0.5. It combines GPU acceleration, CPU mining, multi-GPU support, hardware autotuning, fast synchronization and live monitoring.

**Fees:** 4.5% of GPU hashes to support ongoing development; **CPU mining has no developer fee**. This is an independent community miner, **not an official Nightfall Core release**.

## 🌌 About NIGHTFALLCOIN (NIGHT)

[NIGHTFALLCOIN](https://nightfallcoin.org/) is a privacy-focused, fair-launch Proof-of-Work cryptocurrency with a 90 million NIGHT supply cap. It uses the memory-hard **Nighthash-v2 (Argon2id)** mining algorithm.

[Official website](https://nightfallcoin.org/) · [Web wallet](https://wallet.nightfallcoin.org/) · [Nightfall Core](https://github.com/Instinctes/nightfall)

## 📥 GPU Miner Downloads & Releases

**Nightfall GPU Miner v1.3.8 RC3 — Limited Public Beta**

**Direct downloads (Linux x86-64):**

- 📦 **[Download Nightfall GPU Miner (.tar.gz)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.1/nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz)**
- 🔐 **[Download SHA-256 checksum (.sha256)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.1/nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz.sha256)**

*The links become available when the GitHub prerelease is published.*

The miner includes precompiled NVIDIA CUDA workers, so **no CUDA Toolkit or `nvcc` is required**. A compatible NVIDIA driver is still needed. Verify the archive against the downloaded SHA-256 file before installation.

**Important:** GitHub's automatically generated **“Source code” ZIP/TAR** files are **not the executable miner**. Use the direct binary release asset above.

See the [RC3 release notes](docs/RELEASE_NOTES_RC3_BETA.md) and [installation guide](docs/INSTALL.md).

## Quickstart

**Recommended system:** Ubuntu 24.04 x86-64 with a compatible NVIDIA driver. Download both files from the **Direct downloads** links above.

1. Verify the downloaded SHA-256 checksum and extract the miner:

```bash
sha256sum -c nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz.sha256
tar -xzf nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz
cd nightfall-miner-v1.3.8-rc3-beta.1
```

2. Run the built-in self-test and review the installation plan:

```bash
bash selftest.sh
bash install.sh --address "nf1YOUR_PUBLIC_PAYOUT_ADDRESS" --plan
```

3. Install using **your own public** `nf1...` payout address (never a private key or recovery phrase):

```bash
sudo bash install.sh --use-prebuilt --install-deps \
  --address "nf1YOUR_PUBLIC_PAYOUT_ADDRESS" --non-interactive
```

4. Once installed, check the dashboard and miner status:

```bash
mine
minerctl status
minerctl doctor
minerctl blocks 20
```

**Sync note:** The miner may wait for network synchronization and canonical peer agreement before mining. A recent, **trusted and verified FastState snapshot** can shorten startup, but is optional; a one-minute first installation is not guaranteed. Older Linux distributions may require the experimental Nightfall Core source-build path rather than `--use-prebuilt`.

For FastState import, advanced options and troubleshooting, read the [complete RC3 installation guide](docs/INSTALL.md).

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

[RC3 tested GPU/OS matrix](docs/COMPATIBILITY.md).

### CPU Mining

| CPU | Reported hashrate |
| --- | ---: |
| AMD EPYC 7D12 | 520–674 H/s |
| Intel Xeon E5 series | 115–635 H/s, depending on model/configuration |
| AMD EPYC 7272 | 358 H/s |
| Intel Core i7 (8th generation) | 258 H/s |

**Measured and estimated data must not be mixed.** Future architecture projections have intentionally been left out of this table.

## 🛠️ Requirements

- **OS:** Ubuntu 24.04 x86-64 recommended for the first RC3 beta. Other distros have inherited Core prebuilt restrictions. [Compatibility](docs/COMPATIBILITY.md).
- **GPU:** Supported NVIDIA card and compatible proprietary driver (check with `nvidia-smi`).
- **CUDA:** RC3 provides verified precompiled native CUDA workers, so no `nvcc`/CUDA Toolkit is needed on the miner host. A compatible NVIDIA driver is required.
- **Wallet:** A public `nf1...` payout address; no seed phrase or private key is required.
- **Rust:** Not needed for the recommended Ubuntu 24.04 prebuilt Core path. The inherited `nightfalld` prebuilt references GLIBC_2.39; other OS versions or older CPUs may require Core built from source.

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

For mixed-GPU rigs, the miner supports selecting devices and configuring their batch sizes separately. **RC3 real mixed-generation GPU operation remains untested**. [Read compatibility](docs/COMPATIBILITY.md).

## Multi-GPU Setup

Multiple supported NVIDIA GPUs can mine concurrently. Identify the cards with:

```bash
/opt/nightfall-miner/minerctl hardware
```

To select specific devices on a rig, edit `/opt/nightfall-miner/config.env`:

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
- [RC3 limited beta release notes](docs/RELEASE_NOTES_RC3_BETA.md)
- [Installation and FastState](docs/INSTALL.md)
- [Compatibility and tested GPUs](docs/COMPATIBILITY.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Report an issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues)

The developer fee and independent-project status are disclosed above. Nightfall Core and other bundled dependencies remain subject to their original licenses. This repository contains **documentation and release links only**; approved miner archives are supplied as verified GitHub Release assets. 

**RC3 Beta 1 archive SHA-256:** `6b94518283bd777518f0968745c509f94d16e8c46b0f01c02b4b152d55cb991f`
