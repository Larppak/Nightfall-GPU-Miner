# Nightfall GPU Miner

![Nightfall GPU Miner banner](https://raw.githubusercontent.com/Larppak/Nightfall-GPU-Miner/main/assets/nightfall-miami-vice-banner.svg)

Mine **NIGHT** with your NVIDIA GPU on Windows or Linux. On Linux, Lmux also offers **Pearl Solo** and **NIGHT + Pearl** on supported cards. Both miners are independent community builds and include prebuilt GPU workers.

| Choose your platform | Download | Release |
|---|---|---|
| **Windows 10/11 x64** | [Windows ZIP][win-zip] · [SHA-256][win-sha] | [Alpha 1 RC1 · Nightfall Core 1.1.6][win] |
| **Linux x86-64** | [Online installer (140 KiB)][linux-online] · [SHA-256][linux-online-sha] | [Lmux 2.6.1 · Build 26109 D1 · Nightfall Core 1.1.5][linux] |

## Start on Windows

1. Download the Windows ZIP and its SHA-256 file. In PowerShell, run `Get-FileHash .\Nightfall-Windows.zip -Algorithm SHA256` and compare the hash with the one in the checksum file.
2. Extract the entire ZIP to a new folder and open **Nightfall.cmd**. Under **Setup & Devices**, enter your public `nf1…` receiving address, choose a Mainnet data folder and select your NVIDIA GPU.
3. Choose **Start mining**. When you finish, choose **Stop mining** and wait for cleanup before closing the app or switching versions.

The Windows miner runs NIGHT on the GPU with CPU mining disabled. It includes CUDA workers for SM 6.1, 7.5, 8.6, 8.9 and 12.0. For a first chain sync, the release notes explain how to import the official FastSync snapshot. [Windows release notes][win]

![Windows miner dashboard during a mining session][win-dashboard]

## Start on Linux

**Requirements:** Ubuntu 24.04 x86-64, NVIDIA driver, Python 3.10+ and OpenSSL. No CUDA Toolkit or compilation required.

Download the online installer to `/workspace` and run:

```bash
cd /workspace &&
chmod +x LMUX-26109-Linux-Online.run &&
./LMUX-26109-Linux-Online.run
```

The installer automatically detects your GPUs and downloads the required runtime.

1. Choose an idle GPU and your mining mode.
2. Enter your public payout address for each selected coin.
3. Confirm with `y` to install and start mining.

NIGHT supports single-GPU and eligible multi-GPU rigs with up to eight GPUs. Pearl Solo and NIGHT + Pearl Dual mining are available on supported individual GPUs. NIGHT setup may calibrate the GPU and synchronize the chain before mining begins.

**Dashboard:** Open a second terminal and run the dashboard command displayed during setup.

**Check GPU compatibility:**

```bash
./LMUX-26109-Linux-Online.run --list-gpus
```

**Optional but recommended — verify download integrity before running the installer:**

Download the SHA-256 checksum from the table above into the same directory and run:

```bash
sha256sum -c LMUX-26109-Linux-Online.run.sha256
```

If direct execution is unavailable, use `python3 LMUX-26109-Linux-Online.run` from the download directory.

[Linux release notes and GPU benchmarks][linux]

During NIGHT setup the installer shows elapsed time and the detected activity. Long steps refresh roughly every 15 seconds. If it cannot identify a specific stage, it shows a general setup message.

### Open the Linux dashboard

**Using the original build 26109?** Download the D1 online installer and checksum from the table above into a separate directory. Verify the checksum, then run the new installer with `--prefix "/actual/install/path" --dashboard` to open D1 against the existing installation. Add `--multi-gpu` for a multi-GPU rig. Keep the original launcher for starting that rig.

**Terminal:** Open a second terminal on the miner (a second SSH session on Vast). Copy the complete command printed after **Dashboard in a second SSH terminal** during setup. It ends in `--dashboard` and already includes the correct installer path, installation directory and any `--multi-gpu` flag. The display refreshes every five seconds. Press **Ctrl+C** in this terminal to close the viewer while mining continues.

**Browser on the Linux machine:** In a second terminal, run the command printed after **Browser dashboard on the miner**. It ends in `--web-dashboard`. Leave it running and open [the dashboard on localhost](http://127.0.0.1:17882/) in a browser on that machine.

**Browser on your own computer (Vast or another SSH host):**

1. On the **remote miner**, start the `--web-dashboard` command above and leave it running.
2. On **your own computer**, open PowerShell or a terminal. Copy the SSH connection details from Vast **Connect**. In the command below, replace `PORT`, `USER` and `HOST` with the SSH port, username and host from that connection. If your connection uses `-i` for a key file, include the same option here.

   ```sh
   ssh -N -o ExitOnForwardFailure=yes -L 127.0.0.1:17882:127.0.0.1:17882 -p PORT USER@HOST
   ```

3. Leave the SSH tunnel running and open **http://127.0.0.1:17882/** on your own computer. A quiet SSH window is normal. If local port 17882 is busy, change the forwarding argument to `127.0.0.1:17883:127.0.0.1:17882` and open **http://127.0.0.1:17883/**. The remote dashboard listens on loopback, so the miner needs no public dashboard port.

### Check status, get a support report or stop mining

On the miner, reuse the terminal dashboard command printed during setup. Keep the same installer path, `--prefix` value and, for a multi-GPU installation, `--multi-gpu`. Replace the final `--dashboard` option with the action you want.

| Action | Option |
|---|---|
| View the installed miner’s status | `--status` |
| Print a single privacy-filtered JSON snapshot for troubleshooting | `--support-report` |
| Stop mining for this installation | `--stop` |

If you closed the setup terminal, run the following from the directory containing the online installer. Replace `/actual/install/path` with the **INSTALL PATH** shown during setup. For a multi-GPU installation, add `--multi-gpu`. If you installed from the ZIP, run `bash lmux.sh` from the extracted directory with the same options.

```bash
python3 LMUX-26109-Linux-Online.run --prefix "/actual/install/path" --dashboard
```

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
[linux]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/lmux-linux-26109-setup-progress
[linux-dashboard]: https://raw.githubusercontent.com/Larppak/Nightfall-GPU-Miner/main/assets/nightfall-dashboard-example.webp
[linux-online]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/lmux-linux-26109-setup-progress/LMUX-26109-Linux-Online.run
[linux-online-sha]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/lmux-linux-26109-setup-progress/LMUX-26109-Linux-Online.run.sha256
[linux-zip]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/lmux-linux-26109-setup-progress/LMUX-26109-Linux.zip
[linux-sha]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/lmux-linux-26109-setup-progress/LMUX-26109-Linux.zip.sha256
[bench]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/lmux-linux-26109-setup-progress#night-performance-on-real-gpus
[issues]: https://github.com/Larppak/Nightfall-GPU-Miner/issues
[v2]: https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/V2
[license]: https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/LICENSE
