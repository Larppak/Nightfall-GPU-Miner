# Nightfall GPU Miner

![Nightfall GPU Miner banner](https://raw.githubusercontent.com/Larppak/Nightfall-GPU-Miner/main/assets/nightfall-miami-vice-banner.svg)

Mine **NIGHT** with your NVIDIA GPU on Windows or Linux. On Linux, Lmux also offers **Pearl Solo** and **NIGHT + Pearl** on supported cards. Both miners are independent community builds and include prebuilt GPU workers.

| Choose your platform | Download | Release |
|---|---|---|
| **Windows 10/11 x64** | [Windows ZIP][win-zip] · [SHA-256][win-sha] | [Alpha 1 RC1 · Nightfall Core 1.1.6][win] |
| **Linux x86-64** | [Online installer (135 KiB)][linux-online] · [SHA-256][linux-online-sha] | [Lmux 2.6.1 · Build 26109 · Nightfall Core 1.1.5][linux] |

## Start on Windows

1. Download the Windows ZIP and its SHA-256 file. In PowerShell, run `Get-FileHash .\Nightfall-Windows.zip -Algorithm SHA256` and compare the hash with the one in the checksum file.
2. Extract the entire ZIP to a new folder and open **Nightfall.cmd**. Under **Setup & Devices**, enter your public `nf1…` receiving address, choose a Mainnet data folder and select your NVIDIA GPU.
3. Choose **Start mining**. When you finish, choose **Stop mining** and wait for cleanup before closing the app or switching versions.

The Windows miner runs NIGHT on the GPU with CPU mining disabled. It includes CUDA workers for SM 6.1, 7.5, 8.6, 8.9 and 12.0. For a first chain sync, the release notes explain how to import the official FastSync snapshot. [Windows release notes][win]

![Windows miner dashboard during a mining session][win-dashboard]

## Start on Linux

On Ubuntu 24.04 x86-64, use a working NVIDIA driver, Python 3.10 or later and OpenSSL. Download the online installer and its checksum from the table above. Run these commands in the download directory. The installer detects your GPU and fetches the matching runtime.

```bash
sha256sum -c LMUX-26109-Linux-Online.run.sha256 &&
  python3 LMUX-26109-Linux-Online.run
```

Choose an idle GPU and one of the modes shown for it. Enter the public payout address for each coin, then confirm with `y`. NIGHT setup may calibrate the GPU and synchronize the chain. To monitor mining, open a second terminal and run the dashboard command printed by the installer.

To inspect your GPUs before starting, run `python3 LMUX-26109-Linux-Online.run --list-gpus`. NIGHT supports eligible rigs with 2–8 GPUs. Pearl Solo and dual mining use one supported GPU. [Linux release notes and GPU benchmarks][linux]

![Linux miner dashboard from the V2 release][linux-dashboard]

*Linux dashboard example from the earlier V2 release.*

For an offline installation, download the [all-in-one ZIP (293 MiB)][linux-zip] and its [SHA-256 file][linux-sha]. The [Linux release notes][linux] include extraction and setup commands.

## How fast is it?

On an **RTX 3060 12 GB**, Lmux NIGHT Solo reported **4,410 H/s** and the Night Core GPU reference reported **2,930 H/s**. Across 15 GPU models with paired results, Lmux reported **93.5% higher H/s on average**. These five-minute Linux tests used builds 26104–26105. The reference counts completed GPU hashes, while the Lmux counter may include other work. The full table gives per-card results, dual-mining rates and the measurement method. [See the benchmark table][bench]

## Fees and support

Both miners charge a **4.5% developer fee on completed NIGHT GPU work**. Lmux charges a **0% application fee on Pearl**.

[Report an issue][issues] · [Earlier Linux V2 release][v2] · [License][license]

[win]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/windows-alpha-1-rc1
[win-zip]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/windows-alpha-1-rc1/Nightfall-Windows.zip
[win-sha]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/windows-alpha-1-rc1/Nightfall-Windows.zip.sha256
[win-dashboard]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/windows-alpha-1-rc1/Nightfall-Dashboard-Session.png
[linux]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/untagged-f42a0b37911f0fceccb2
[linux-dashboard]: https://raw.githubusercontent.com/Larppak/Nightfall-GPU-Miner/main/assets/nightfall-dashboard-example.webp
[linux-online]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/untagged-f42a0b37911f0fceccb2/LMUX-26109-Linux-Online.run
[linux-online-sha]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/untagged-f42a0b37911f0fceccb2/LMUX-26109-Linux-Online.run.sha256
[linux-zip]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/untagged-f42a0b37911f0fceccb2/LMUX-26109-Linux.zip
[linux-sha]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/untagged-f42a0b37911f0fceccb2/LMUX-26109-Linux.zip.sha256
[bench]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/untagged-f42a0b37911f0fceccb2#night-performance-on-real-gpus
[issues]: https://github.com/Larppak/Nightfall-GPU-Miner/issues
[v2]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/V2
[license]: https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/LICENSE
