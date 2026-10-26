# Nightfall GPU Miner Beta 5 p2 — troubleshooting

These notes apply to the current
[Beta 5 p2 Linux pre-release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2).
Ubuntu 24.04 x86-64 is recommended for the prebuilt Core 1.0.11.

Commands below use the `/opt/nightfall-miner` prefix for root/system
installations. For rootless installations, use
`~/.local/bin/minerctl` and the corresponding user installation directory.

## Safe sync wait / no mining

```bash
/opt/nightfall-miner/minerctl status
/opt/nightfall-miner/minerctl doctor
/opt/nightfall-miner/minerctl fastsync-info
/opt/nightfall-miner/minerctl canonical-check 180 3
```

Check the number of connected peers, canonical tip agreement and local
chain height. The miner intentionally waits for a sufficiently verified
chain before enabling Mainnet work. Do **not** bypass the canonical
guard or install arbitrary untrusted snapshots.

The default FastSync imports a SHA-256-verified trusted historical anchor;
historical blocks through that anchor are not individually reverified
locally. Later blocks are validated normally.

## NVIDIA worker not available or GPU mismatch

```bash
nvidia-smi
/opt/nightfall-miner/minerctl hardware
/opt/nightfall-miner/minerctl doctor
ls -lh /opt/nightfall-miner/worker/bin/nightfall-worker-sm_*
```

Confirm that the GPU's CUDA compute capability has a matching native
worker and that the NVIDIA driver supports the device and supplied
CUDA executable. Some NVIDIA cards and mixed-generation configurations
have not been individually validated. There is no general source/PTX
fallback for an unsupported architecture in this release.

## AMD HIP experimental setup errors

**AMD is experimentally packaged but has NOT been physically tested by
the publisher.** Do not assume a ROCm compile PASS means the GPU can
mine valid Mainnet hashes.

```bash
rocminfo
/opt/nightfall-miner/minerctl status
/opt/nightfall-miner/minerctl doctor
```

Check for supported wave32 targets `gfx1030`, `gfx1100`,
`gfx1101`, or `gfx1200`, a compatible ROCm runtime and
`libamdhip64`. AMD installation supports a **fresh** app and
datadir; it is not validated as a backend switch on an existing
NVIDIA miner. The on-device hash/cancel smoke check must pass
before live mining can start.

When reporting an AMD bug, include the exact GPU model and
`gfx` identifier, ROCm version and **sanitized** diagnostic output.

## Native protection or GPU fee check fails

```bash
/opt/nightfall-miner/minerctl native-integrity-check
/opt/nightfall-miner/minerctl fee-policy-check
/opt/nightfall-miner/minerctl dev-fee-status
```

A missing or modified protected component causes a safe startup
refusal. Reinstall/restore the matching verified release package;
do not edit the checker or hashes to bypass this protection.
The ordinary-user GPU fee target is 4.5% of completed GPU work;
CPU work carries no developer fee.

`minerctl stop` and `minerctl status` remain available even with
an invalid native runtime.

## GLIBC_2.39 not found

The bundled Core 1.0.11 prebuilt requires glibc 2.39, so
Ubuntu 24.04 x86-64 is the recommended path. Ubuntu 22.04
and Debian 12 are not prebuilt-Core-supported just because
some CUDA workers themselves can load there.
Avoid manually replacing system glibc inside a working machine.

## SHA-256 download validation fails

Stop installation and re-download both files from
[Beta 5 p2 GitHub Release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2).
The Linux archive should hash to:

`bb31b66d94354e625add8030cd36824aaf9bab0afff5eb00ed9f3208633a8012`

GitHub auto-generated **Source code** archives are not miner packages.

## Hashrate lower than expected

Compare the GPU raw and effective rates, hardware temperature,
power limits, memory allocation, chain-tip interruptions,
worker cancellations and canonical guard holds. Historical
[benchmark figures](HISTORICAL_BENCHMARKS.md) are not
current p2 performance guarantees.

## Reporting issues

[Open a GitHub issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues)
with the miner version, OS, GPU model, NVIDIA driver or AMD ROCm
version, startup error, sanitized `minerctl doctor` output and whether
you installed fresh or upgraded.

Never post mnemonic phrases, wallet private keys, API credentials,
SSH keys, passwords or sensitive log contents.
