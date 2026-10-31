# Nightfall GPU Miner v1.3.8 RC3 Beta 6 — Linux

**Core 1.1.1 · NVIDIA CUDA + CPU · AMD HIP experimental**

This is a limited Linux x86-64 pre-release of an independent NIGHTFALLCOIN (NIGHT) miner. Not an official Nightfall Core release.

**What's new:** Nightfall Core upgraded from 1.0.11 to **1.1.1**, ready for the mandatory consensus change at Mainnet block **500,000**. The GPU mining algorithm and precompiled NVIDIA workers are unchanged. GPU developer fee **4.5%**; CPU fee **0%**.

## Download

[**Linux one-file miner (.run)**](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.6/nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.run) · [**SHA-256 checksum**](https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.6/nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.run.sha256)

SHA-256 of the `.run`: `9e7e2c7f143c5d2d61b22f6493f00760894c73af44d721fc36ea4bbaf79251fd`

Download, verify and check the package on Linux:

```bash
mkdir -p "$HOME/nightfall-download" && cd "$HOME/nightfall-download"
FILE=nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.run
BASE=https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.6
curl -fL --retry 3 -o "$FILE" "$BASE/$FILE" &&
curl -fL --retry 3 -o "$FILE.sha256" "$BASE/$FILE.sha256" &&
sha256sum -c "$FILE.sha256" &&
chmod +x "$FILE" &&
./"$FILE" --verify
```

## Fresh install

```bash
read -r -p "Your PUBLIC NIGHT payout address (nf1...): " ADDR
./"$FILE" --install --address "$ADDR"
```

The installer selects user or system mode as appropriate. Only your public payout address is needed. **Never provide wallet seeds or private keys.** Mining starts after canonical peer agreement.

## Upgrade from Beta 5 p2

No new wallet, blockchain redownload or source build is required. Keep the existing chain, payout configuration and GPU fee ledger.

```bash
CTL="$HOME/.local/bin/minerctl"
[ "$(id -u)" -eq 0 ] && CTL=/opt/nightfall-miner/minerctl
"$CTL" stop
./"$FILE" --upgrade --plan
```

Check the displayed installation path, chain path and fee settings before proceeding:

```bash
./"$FILE" --upgrade
"$CTL" start
"$CTL" doctor
```

For a nonstandard installation use the original `--prefix PATH` with both upgrade commands and the matching installed `minerctl`.

## Tested and limitations

- Physical **GTX 1650** CUDA correctness, real canonical Mainnet USER/DEV work and one automatically scheduled DEV work batch: **PASS**.
- Core 1.1.1 consensus and fork-height tests: **PASS on isolated DEVNET**.
- Package self-test, protected components and stopped Beta 5 p2 → Beta 6 upgrade/rollback: **PASS**.
- **Beta:** no accepted Mainnet block was observed; live post-500,000 Mainnet validation, longer fee convergence and every GPU model remain untested. Hashrate and rewards are not guaranteed.
- **AMD HIP remains experimental and has not been verified on physical AMD GPUs.**
- **Windows is not included** in this Linux release.

Download the `.run` file in Assets, **not** GitHub's automatically generated source-code ZIP. The installer is a self-extracting package, not encryption.
