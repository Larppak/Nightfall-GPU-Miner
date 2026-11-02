# Nightfall GPU Miner V2 — Troubleshooting

**Current Linux release:** [Nightfall GPU Miner V2 (Core 1.1.2)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/V2)

Recommended: **Ubuntu 24.04 x86-64** and a compatible NVIDIA driver. For installing or updating, start with the [simple README](../README.md).

## First, check what's happening

In a Linux terminal, select the correct control command:

```bash
CTL="$HOME/.local/bin/minerctl"
[ "$(id -u)" -eq 0 ] && CTL=/opt/nightfall-miner/minerctl
"$CTL" status
"$CTL" doctor
```

For a custom installation (`--prefix PATH`), use that installation's `minerctl`. Don't run two installations against the same blockchain directory.

## The miner says `SYNCING_SAFE_WAIT`

**Usually normal:** the Nightfall node needs to download/verify the chain and check that peers agree before it can mine.

- Check `"$CTL" status` and `"$CTL" doctor` for sync and peer information.
- Keep the node online. Syncing can take time, especially on a fresh installation.
- Do **not** disable the canonical-chain safety check or trust an unknown FastState snapshot just to begin mining sooner.

## NVIDIA GPU not detected or no GPU mining

```bash
nvidia-smi
"$CTL" hardware
"$CTL" doctor
```

Check that the NVIDIA driver works and your GPU architecture has a compatible precompiled worker. **You do not need to install CUDA Toolkit or `nvcc`.** Support for one GPU architecture does not guarantee every card or driver has been physically tested.

## Low hashrate or frequent pauses

```bash
"$CTL" dashboard 5
"$CTL" status
```

The effective mining rate can be lower than the raw GPU rate when the node is syncing, losing peer agreement or discarding stale work after a new block. Also check GPU temperature, power limits and driver status with `nvidia-smi`.

Press `Ctrl+C` to close the dashboard only. To stop mining, use `"$CTL" stop`.

## A component or fee integrity check fails

```bash
"$CTL" native-integrity-check
"$CTL" fee-policy-check
"$CTL" dev-fee-status
```

A damaged or mismatched protected component can make the miner refuse to start safely. Restore the matching **verified V2 package**. Do not mix files from different releases or bypass the verification checks.

Developer fee: **4.5% of completed GPU work; 0% on CPU work.** Short sample windows may differ from the long-run target.

## `GLIBC_2.39 not found`

The bundled prebuilt Nightfall Core requires **glibc 2.39**. **Ubuntu 24.04** is the recommended installation target. Ubuntu 22.04 and Debian 12 do not meet this prebuilt-Core requirement.

Do not replace the system glibc manually. Use a compatible Linux installation instead.

## `sha256sum` or package self-test fails

Do not install. Re-download the actual [V2 Linux `.run` file and `.sha256` checksum](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/V2) and follow the [download-and-verify commands](../README.md#new-user-install-in-2-steps).

Expected V2 `.run` SHA-256:

```text
5d6e4935be8ab677b28502dc4f9f8494fc4f12c8dc849788cac31e64f4df5700
```

GitHub's automatically generated **Source code** ZIP/TAR files are *not* runnable miner packages.

## AMD GPU?

AMD HIP workers are included as an **experimental preview** and have **not been physically validated** by the publisher. A matching ROCm runtime and GPU architecture are required; working NVIDIA commands do not establish AMD compatibility. Do not assume successful compilation proves valid Mainnet GPU mining.

## Still need help?

[Open a GitHub issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues) with the V2 version, Linux distribution, GPU model, driver/ROCm version, whether you installed or upgraded, and the relevant *sanitized* error and `minerctl doctor` output.

**Never post wallet seeds, recovery phrases, private keys, passwords, SSH keys, API tokens or unredacted personal logs.** Windows miners are separate from this Linux release.
