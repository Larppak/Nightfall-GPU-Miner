# Nightfall GPU Miner v1.3.8 RC3 Beta 6 — Linux

**Linux x86-64 · Core 1.1.1 · NVIDIA CUDA · Experimental AMD HIP**

A limited **pre-release** of the independent Nightfall GPU + CPU miner. This is **not official NIGHTFALLCOIN Core software**.

Beta 6 upgrades the included Nightfall Core from **1.0.11 → 1.1.1** for the mandatory binding consensus change at **Mainnet block 500,000**. Previously published Beta 5 p2 and other Core 1.0.x miners will not follow the correct Mainnet after that change.

The 12 NVIDIA CUDA GPU workers and mining algorithm are retained. GPU developer work fee: **4.5%**. CPU developer work fee: **0%**.

## Download (Linux x86-64)

Download **both** files from this release's **Assets**:

- `nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.tar.gz`
- `nightfall-miner-v1.3.8-rc3-beta.6-linux-x86_64.tar.gz.sha256`

**Expected SHA-256 for the .tar.gz:**
`369ff5b1e41157adc532ced255a2afbcb9d774d7e62822b076c7ce9dc95b2f52`

Or download and verify directly in Linux:

```bash
mkdir -p "$HOME/nightfall-download" && cd "$HOME/nightfall-download"
TAG=v1.3.8-rc3-beta.6
FILE="nightfall-miner-${TAG}-linux-x86_64.tar.gz"
URL="https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/${TAG}"
curl -fL --retry 3 -o "$FILE" "$URL/$FILE" &&
curl -fL --retry 3 -o "$FILE.sha256" "$URL/$FILE.sha256" &&
sha256sum -c "$FILE.sha256" &&
tar -xzf "$FILE" &&
cd "nightfall-miner-${TAG}" &&
bash selftest.sh
```

Expected: `NIGHTFALL_MINER_PACKAGE_SELFTEST_PASS`. Run subsequent commands **from that extracted Beta 6 directory**.

## Upgrade from Beta 5 p2 (recommended)

The normal update is **stop → review upgrade plan → upgrade → start → doctor**. It preserves the existing blockchain, public payout address, settings, GPU developer-fee ledger and logs. **No new wallet, blockchain reset, source compilation or FastSync download required.**

```bash
MODE=--user; CTL="$HOME/.local/bin/minerctl"
if [ "$(id -u)" -eq 0 ]; then MODE=--system; CTL=/opt/nightfall-miner/minerctl; fi
"$CTL" stop
bash install.sh "$MODE" --upgrade --plan
```

Check that the plan shows your **existing installation and chain paths**, and that fee/payout state is preserved. Only then:

```bash
bash install.sh "$MODE" --upgrade
"$CTL" start
"$CTL" doctor
```

If you used a custom installation prefix, supply your existing `--prefix PATH` to **both** upgrade commands and use the installed `minerctl` at that path. The upgrade has a documented rollback path in the included `UPGRADE.md`.

## Fresh install (no previous Nightfall miner)

```bash
read -r -p "Public NIGHT payout address (nf1...): " ADDR
MODE=--user; [ "$(id -u)" -eq 0 ] && MODE=--system
bash install.sh "$MODE" --address "$ADDR"
```

Provide only your **public** `nf1...` payout address. Never provide a wallet seed or private key. Mining begins after sufficient canonical Mainnet peer agreement.

## What was tested

- Core **1.1.1** pinned upstream; CPU/consensus and pre-/post-fork tests on isolated DEVNET.
- A real **NVIDIA GTX 1650**: CUDA correctness, persistent worker and socket bridge.
- Canonical real Mainnet sync, actual CUDA **USER and DEV** work and one **automatically scheduled DEV** GPU work batch on GTX 1650.
- Protected native component checks, SHA-256/package self-tests and a stopped **published Beta 5 p2 → Beta 6** upgrade/rollback that preserved chain and accounting state.

## Known limitations

- **Beta software.** Physical Mainnet validation was before block 500,000. The post-fork rules passed DEVNET tests, not live post-fork Mainnet validation.
- No canonically accepted Mainnet block was observed in the short hardware test. Rewards and performance are never guaranteed.
- 4.5% is the target share of **completed GPU work over time**, not necessarily each job; multi-cycle fee convergence remains unverified.
- Only GTX 1650 has this exact Beta 6 physical Mainnet validation; other NVIDIA models vary by GPU and driver.
- **AMD ROCm/HIP is EXPERIMENTAL**; the included AMD workers have **not been physically tested** with this release.
- Windows GPU mining is a separate project and **is not included in this Linux release**.

[Linux compatibility notes](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/docs/RELEASE_NOTES_BETA5_P2.md) (previous Beta 5 p2) · [Source & licensing](https://github.com/Larppak/Nightfall-GPU-Miner/blob/main/LICENSE)

**Important:** download the attached release archive, **not** GitHub's automatically generated source-code ZIP, which is not the precompiled miner.
