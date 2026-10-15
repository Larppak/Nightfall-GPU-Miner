# Nightfall GPU Miner RC3 beta — installation

> **PREPARATION ONLY:** The RC3 public beta has not been published yet. These
> commands apply **after** a release with the exact asset names below is approved
> and published on [GitHub Releases](https://github.com/Larppak/Nightfall-GPU-Miner/releases).
> Do not download GitHub's automatically generated Source code ZIP/TAR archive:
> that archive contains documentation, not the executable miner.

## First beta: recommended environment

- Ubuntu 24.04 x86-64, NVIDIA GPU and functioning NVIDIA proprietary driver.
- Public NIGHTFALLCOIN payout address (`nf1...`), **never** your seed phrase or private key.
- Compatible GPU architectures are selected automatically from precompiled native workers.
  No CUDA Toolkit or `nvcc` is required for the GPU worker.
- An internet connection for the Nightfall node or a recent, **trusted** FastState snapshot.
- The bundled prebuilt Nightfall Core is only recommended on Ubuntu 24.04 at first.
  See [compatibility](COMPATIBILITY.md) before using another distribution.

## 1. Download the approved GitHub Release

After the maintainer publishes tag `v1.3.8-rc3-beta.1` and its assets:

```bash
cd /workspace
ASSET="nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz"
BASE="https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.1"
curl -fL --retry 3 -o "$ASSET" "$BASE/$ASSET"
curl -fL --retry 3 -o "$ASSET.sha256" "$BASE/$ASSET.sha256"
sha256sum -c "$ASSET.sha256"
```

Expected checksum output: `...tar.gz: OK`. The SHA-256 must correspond to the
**approved beta artifact**; the older private RC3 preview's hash is **not**
the checksum of a repackaged final beta. SHA-256 detects accidental alteration;
it does not authenticate a maliciously replaced file and checksum pair.
Only trust the maintainer's actual GitHub release.

## 2. Extract and self-test

```bash
tar -xzf "$ASSET"
cd nightfall-miner-v1.3.8-rc3-beta.1
bash selftest.sh
nvidia-smi
```

Confirm that the archived top-level folder matches the release notes.
Do not extract archives received from untrusted third parties.

## 3. Plan the installation

```bash
bash install.sh --address "nf1YOUR_PUBLIC_PAYOUT_ADDRESS" --plan
```

Use the public **receiving** address, not a mnemonic, seed, wallet file, or
private key. Check the detected GPU compute capabilities and driver.

## 4. Install without a FastState

On the recommended Ubuntu 24.04 system, as root or using sudo:

```bash
sudo bash install.sh \
  --address "nf1YOUR_PUBLIC_PAYOUT_ADDRESS" \
  --use-prebuilt \
  --install-deps \
  --non-interactive
```

The node still needs to obtain and verify current network chain state.
An official FastSync bootstrap does **not** guarantee a one-minute time to mining.

## 5. Alternative: install with a recent trusted FastState

If you already have `/workspace/nightfall-faststate-v3.tar` from your own
fully synchronized compatible node, verify its checksum **against a value
obtained independently from that trusted source** before importing it.
For example, when the accompanying checksum file exists:

```bash
cd /workspace
sha256sum -c nightfall-faststate-v3.tar.sha256
```

Then, from the extracted miner folder:

```bash
sudo bash install.sh \
  --address "nf1YOUR_PUBLIC_PAYOUT_ADDRESS" \
  --use-prebuilt \
  --install-deps \
  --faststate /workspace/nightfall-faststate-v3.tar \
  --non-interactive
```

The snapshot is an explicit trusted-chain shortcut. It is not a replacement
for peer and canonical-chain checks. Do not import arbitrary snapshots or
overwrite newer chain data with older snapshots.

## 6. Check mining

```bash
/opt/nightfall-miner/minerctl status
/opt/nightfall-miner/minerctl doctor
/opt/nightfall-miner/minerctl fastsync-info
/opt/nightfall-miner/minerctl dev-fee-status
/opt/nightfall-miner/mine
```

The miner may initially pause with `SYNCING_SAFE_WAIT` until the node catches
up and peers agree. Do not disable the chain guard to force mining.

## 7. Multi-GPU and existing installations

- The installer accepts `--gpu-devices all` or a selected list of CUDA logical
  device IDs. The launcher selects the matching verified binary per GPU.
- Real mixed-generation rigs have **not** yet been hardware validated in RC3.
  Keep GPU visibility settings consistent between install and service startup.
- If RC2 is already running, keep its data/configuration and fee ledger backed
  up. Do **not** run RC2 and RC3 against the same data/run directory at once.
- Review [troubleshooting](TROUBLESHOOTING.md) before changing any installed
  configuration or reusing a chain snapshot.

**Fees:** Ordinary-user GPU mining is subject to the disclosed 4.5% developer
fee, applied to GPU work. CPU mining has 0% developer fee. Your observed reward
share can vary with block-finding luck. This miner is independent of Nightfall
Core and is provided without a profitability or uptime guarantee.
