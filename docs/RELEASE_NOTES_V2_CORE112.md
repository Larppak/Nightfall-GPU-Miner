# Nightfall GPU Miner V2 — Core 1.1.2 (Linux)

**New Linux pre-release · NVIDIA CUDA + CPU · AMD HIP experimental**

A simpler, single-file NIGHTFALLCOIN (NIGHT) miner, now based on **Nightfall Core 1.1.2**. V2 is the release name; the verified package's internal version is **1.3.8-rc3-beta.6-p1**.

### What's changed?

- **Core 1.1.1 → 1.1.2:** improvements to initial blockchain synchronization (short IBD pages), peer-specific reorganization recovery, on-disk chain safety and light API handling.
- **Same GPU mining implementation:** NVIDIA CUDA workers, PoW algorithm and consensus activation at Mainnet block 500,000 remain unchanged.
- **GPU developer fee 4.5% of completed GPU work; CPU developer fee 0%.**
- **Safe update from the previous Beta 6:** keeps the existing chain, public payout address, settings, mining history and GPU-fee ledger; rollback support retained.
- **One Linux file** to download and run. No CUDA Toolkit, Rust compilation or new wallet required for normal installation.

### Download (Linux x86-64)

Download these **two release assets** (not the automatically generated source ZIP):

- [Linux V2 miner (.run)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.6-p1/nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run)
- [SHA-256 checksum (.run.sha256)](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.6-p1/nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run.sha256)

**Expected SHA-256 of the .run:**

`5d6e4935be8ab677b28502dc4f9f8494fc4f12c8dc849788cac31e64f4df5700`

**Download and verify:**

```bash
mkdir -p "$HOME/nightfall-download" && cd "$HOME/nightfall-download"
FILE=nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run
BASE=https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.6-p1
curl -fL --retry 3 -o "$FILE" "$BASE/$FILE" &&
curl -fL --retry 3 -o "$FILE.sha256" "$BASE/$FILE.sha256" &&
sha256sum -c "$FILE.sha256" &&
bash "$FILE" --verify
```

Expected: `ONEFILE_BETA6_PACKAGE_SELFTEST_PASS`.

### Already running Nightfall GPU Miner Beta 6?

Update **without resetting the blockchain**. Run in the same directory as the downloaded file, using the same Linux account as the current installation:

```bash
FILE=nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run
CTL="$HOME/.local/bin/minerctl"
[ "$(id -u)" -eq 0 ] && CTL=/opt/nightfall-miner/minerctl
"$CTL" stop
bash "$FILE" --upgrade --plan
```

Review the displayed existing installation and blockchain paths **before** applying the update:

```bash
bash "$FILE" --upgrade
"$CTL" start
"$CTL" doctor
```

For a nonstandard installation prefix, include your original `--prefix PATH` in both upgrade commands and use that installation's `minerctl`.

### New installation

```bash
FILE=nightfall-miner-v1.3.8-rc3-beta.6-p1-linux-x86_64.run
read -r -p "Your PUBLIC NIGHT address (nf1...): " ADDR
bash "$FILE" --install --address "$ADDR"
```

Only provide your **public payout address**; never enter a seed phrase or private key. Mining starts after the node catches up and agrees with canonical peers.

### Testing and limitations

The patched Core 1.1.2 passed private Linux build, node/consensus/crypto/storage/IBD/reorg regressions, pre-/post-fork DEVNET GPU USER/DEV RPC tests, package selftest, and a stopped-upgrade/rollback test. NVIDIA GTX 1660 SUPER passed real-machine startup and integrity diagnostics; extended GPU Mainnet performance and DEV-fee convergence have not been independently documented.

**AMD HIP is experimental and has not been tested on real AMD hardware.** No accepted canonical Mainnet block is claimed for this Core 1.1.2 release. Windows builds are separate and **not** included.

This is an **independent beta miner**, not the official Nightfall Core software. GPU models, drivers, network availability, mining rewards and performance vary.

[Project README](https://github.com/Larppak/Nightfall-GPU-Miner) · [Report an issue](https://github.com/Larppak/Nightfall-GPU-Miner/issues) · [Previous Beta 6 release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.6)
