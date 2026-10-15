# Nightfall GPU Miner v1.3.8 RC3 Beta 1 — Limited Public Beta

Independent NVIDIA GPU + CPU miner for NIGHTFALLCOIN (NIGHT),
based on Nightfall Core v1.0.5. **Not an official Nightfall Core release.**

### Features

- Ready-to-run **precompiled NVIDIA CUDA workers** for 12 GPU compute
  capability targets. The local CUDA Toolkit and `nvcc` are not required.
- Protected, native-compiled GPU + CPU hybrid control plane.
- GPU batch autotuning, multi-GPU configuration, canonical network guard,
  FastSync and optional trusted FastState import.
- Terminal dashboard, worker diagnostics and CPU mining.
- **GPU developer fee: 4.5% of completed GPU work. CPU fee: 0%.**
- **MIT license for first-party miner code and binaries.** Users retain
  MIT rights to modify and redistribute covered code/software; the developer
  fee describes the behavior of the unmodified distributed miner.
  Third-party and vendor components retain their own licenses.

### GPU testing

Paired RC2 versus RC3 offline worker validation was performed on:
GTX 1070, RTX 2080 Ti (rental reported nonstandard 22 GiB VRAM),
RTX 3070, Quadro RTX 5000 and RTX 4060 Ti 16 GB.

The Quadro RTX 5000 and RTX 4060 Ti also passed short live
CPU+GPU mainnet trials, graceful restarts and automatic canonical-guard
recovery. Together, 52 GPU submissions were locally accepted and none
locally rejected. These are **local node acceptances**, not independently
verified final/spendable wallet rewards. The latest live sessions used the
maintainer's developer address, so normal-user 4.5% fee accrual was not
live retested in these specific sessions; protected fee logic has separate
software regression evidence.

An RTX 5070 (Blackwell, `sm_120`) additionally passed a reported RC3
**installation and node synchronization smoke test**. This was not a sustained
GPU mining or throughput test, and no RTX 5070 hashrate is claimed here.

### System requirements / scope

- **Recommended: Ubuntu 24.04 x86-64** with a compatible NVIDIA driver.
- No local `nvcc` required for GPU worker.
- Bundled Nightfall Core prebuilt `nightfalld` requires **GLIBC_2.39**.
  The prebuilt node is not compatible with Ubuntu 22.04 or Debian 12.
- Workers included for sm_50/52/60/61/70/75/80/86/89/90/100/120;
  availability of a build target is **not** GPU-model hardware validation.
- RTX 5070 installation/sync is confirmed by the test report, but sustained
  Blackwell GPU mining, other Blackwell models, mixed-generation physical rigs,
  older driver branches and long-duration uptime remain unverified. Other OSs
  may require an experimental source-built Nightfall Core.

### Downloads / checksum

**Download the .tar.gz and .tar.gz.sha256 from this GitHub Release's
asset section, NOT GitHub's auto-generated Source code archives.**

`nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz`

SHA-256: `6b94518283bd777518f0968745c509f94d16e8c46b0f01c02b4b152d55cb991f`

`nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz.sha256`

After download:
```bash
sha256sum -c nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz.sha256
tar -xzf nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz
cd nightfall-miner-v1.3.8-rc3-beta.1
bash selftest.sh
```

Then follow [installation and trusted FastState guide](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/INSTALL.md).
Use a **public** `nf1...` payout address, never a private key or seed phrase.

### Licenses and support

The main software is MIT-licensed. The release archive includes
original third-party license texts and notices. NVIDIA CUDA components
are covered by NVIDIA's redistribution terms; see the included
`LICENSE-MANIFEST.md` and `THIRD_PARTY_NOTICES.md`.

[Installation](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/INSTALL.md) ·
[Compatibility](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/COMPATIBILITY.md) ·
[Troubleshooting](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/TROUBLESHOOTING.md) ·
[Issues](https://github.com/Larppak/Nightfall-GPU-Miner/issues)

Beta software is provided without guarantees of hashrate, rewards,
profitability, uptime or hardware support.
