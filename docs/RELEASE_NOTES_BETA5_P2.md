# Nightfall GPU Miner v1.3.8 RC3 Beta 5 p2 — NVIDIA + Experimental AMD

**Independent community miner for NIGHTFALLCOIN (NIGHT).** This is a Linux x86-64 **pre-release**, not an official Nightfall Core release.

**Release tag:** `v1.3.8-rc3-beta.5-p2`  
**Bundled Nightfall Core:** `1.0.11` (upstream commit `ed7deb7c683661783afe02415a9f4ad499fe369f`)  
**Platform:** Ubuntu 24.04 LTS / Linux x86-64, prebuilt Core requires glibc 2.39.  
**GPU developer fee:** 4.5% of completed GPU work for ordinary users; **CPU developer fee: 0%**. The fee is based on GPU work, not guaranteed block-reward splitting.

## Highlights

- **NVIDIA CUDA:** 12 precompiled architecture-specific workers, `sm_50, sm_52, sm_60, sm_61, sm_70, sm_75, sm_80, sm_86, sm_89, sm_90, sm_100, sm_120`. No local CUDA Toolkit or `nvcc` is required to run supported prebuilts; an appropriate NVIDIA driver is required.
- **AMD HIP — EXPERIMENTAL / NOT GPU-TESTED:** four compiler-built ROCm/HIP workers for `gfx1030, gfx1100, gfx1101, gfx1200`, requiring a compatible wave32 AMD GPU, the correct installed ROCm driver/runtime and `rocminfo`. **No physical AMD GPU Mainnet hashing, accepted AMD block, driver compatibility, hashrate or stable operation has been verified by the publisher.** Multi-AMD and mixed CUDA/HIP pools are not certified. The AMD installer tests exact nonce/hash and cancellation vectors **on the user's AMD GPU** before allowing mining.
- **Optimized CPU + GPU hybrid mining:** NVIDIA or opt-in AMD combined with CPU mining and the same protected developer-fee accounting.
- **Terminal and local browser dashboards:** effective GPU/CPU/total hashrates and locally accepted block counts over 30 minutes, 6 hours and 24 hours, including actual data coverage.
- **Core 1.0.11, canonical-chain guard and safe upgrades:** mining pauses when chain verification or peer agreement is insufficient; stopped-service upgrades preserve the chain, payout address, fee accounting and logs.
- **Lightweight executable protection:** production NVIDIA and AMD workers are provided as native GPU binaries with ordinary debug/symbol metadata removed. The GPU fee controller and 71 native runtime components are protected by local SHA-256 integrity checks. This p2 update includes reversible XOR-masked checksum constants and checks the integrity verifier itself. **This is not encryption, licensing, a digital signature or tamper-proof DRM.** A privileged machine owner can modify local software. No mining GPU kernel or native fee-controller binary was changed compared with protected p1.

### NVIDIA validation status

An earlier GTX 1660 Ti field test confirmed **six locally submitted GPU blocks (five USER, one DEV) matched canonical-chain block hashes**. The combined Beta 5 CUDA miner subsequently ran on GTX 1660 Ti at approximately 3.41 kH/s raw and 3.31 kH/s effective with a healthy 4.5% GPU fee ledger. These are device-specific field observations, not guaranteed performance.

**This p2 release has passed static binary, package, simulated native-integrity and upgrade/rollback tests, but its revised launch wrapper has not been retested on physical NVIDIA hardware.** All 12 previously working CUDA binaries remain byte-for-byte unchanged.

## Download and verify — Linux x86-64

Download **both** release assets, rather than GitHub's auto-generated source ZIP:

- `nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz`
- `nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz.sha256`

**SHA-256 of the exact Linux `.tar.gz` release asset:**

```text
bb31b66d94354e625add8030cd36824aaf9bab0afff5eb00ed9f3208633a8012
```

```bash
sha256sum -c nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz.sha256
tar -xzf nightfall-miner-v1.3.8-rc3-beta.5-p2-linux-x86_64.tar.gz
cd nightfall-miner-v1.3.8-rc3-beta.5-p2
bash selftest.sh
```

### Fresh NVIDIA installation (ordinary Linux user)

```bash
bash install.sh --user --address 'nf1YOUR_PUBLIC_PAYOUT_ADDRESS' --plan
bash install.sh --user --address 'nf1YOUR_PUBLIC_PAYOUT_ADDRESS'
export PATH="$HOME/.local/bin:$PATH"
mine
```

On an explicitly authorized root/system installation, use `--system` instead of `--user`.

### AMD experimental installation (new, empty installation only)

First install compatible ROCm drivers/runtime and confirm the actual GPU target using `rocminfo`. **The AMD worker is untested and must pass the installer’s on-device GPU correctness check before any Mainnet mining.**

```bash
bash install.sh --gpu-backend amd --user --address 'nf1YOUR_PUBLIC_PAYOUT_ADDRESS' --plan
bash install.sh --gpu-backend amd --user --address 'nf1YOUR_PUBLIC_PAYOUT_ADDRESS'
```

You may need `--gpu-arch gfx1100` for an ambiguous but supported GPU model. This does **not** install ROCm drivers.

### Upgrade an existing Linux installation

**Stop the existing miner first. Do not run a fresh install over the current chain or fee state.** From the verified, extracted p2 package:

```bash
minerctl stop
bash install.sh --system --upgrade --prefix /opt/nightfall-miner --plan
bash install.sh --system --upgrade --prefix /opt/nightfall-miner
/opt/nightfall-miner/minerctl native-integrity-check
/opt/nightfall-miner/minerctl fee-policy-check
/opt/nightfall-miner/minerctl start
/opt/nightfall-miner/minerctl doctor
```

Use `--user --upgrade` and the existing user prefix for a rootless installation. Review the upgrade plan and save its rollback instructions. Isolated Beta 5 → p2 → Beta 5 and p1 → p2 → p1 tests preserved chain, test wallet data, logs and persistent GPU fee counters.

## Known limitations and safety

- AMD GPU functionality is **experimental and not physically tested**. Bug reports with AMD model, exact `gfx` ID, ROCm version and sanitized logs are welcome.
- Locally accepted blocks and dashboard reward estimates are not mature or spendable wallet balances; Mainnet reorganizations are possible.
- The default RPC and browser dashboard are bound to localhost. Use SSH forwarding for remote access; do not expose unauthenticated RPC publicly.
- Only a **public payout address** is required. Never enter wallet seed phrases or private keys.
- The FastSync bootstrap uses a checksum-verified trusted historical anchor instead of re-verifying all history locally; blocks received after the anchor are validated normally.
- SHA-256 ensures integrity against the published digest; it does not independently authenticate the publisher. The software has no online activation, external DRM or cryptocurrency wallet-key access.
- First-party miner components remain under the existing **MIT license**, and bundled third-party dependencies retain their own notices and terms.

**Independent community project. Pre-release software; provided AS IS without warranties or guaranteed mining proceeds.**
