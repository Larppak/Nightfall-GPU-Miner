# Changelog

## v1.3.8-rc3-beta.5-p2 — NVIDIA + Experimental AMD (2026-10-26)

- Nightfall Core **1.0.11** with canonical-peer guard, FastSync and
  safe, stopped-service upgrades / rollback.
- Same 12 architecture-specific NVIDIA CUDA GPU workers; original GPU
  calculation kernels remain unchanged from the earlier tested Beta 5.
- Added four **experimental AMD HIP GPU binaries** (gfx1030/gfx1100/gfx1101/
  gfx1200). The ROCm compiler-only builds and offline installer checks passed,
  but **no physical AMD GPU mining or accepted Mainnet AMD block has been tested**.
- CPU+GPU mining with 30-minute, 6-hour and 24-hour Dashboard history.
- Native controller / fee runtime SHA checks cover 71 bundled components.
  Lightweight, reversible obfuscation of integrity pins reduces casual
  edits. Neither this nor native compilation is tamper-proof DRM.
- GPU developer fee remains **4.5% of completed GPU work** for ordinary users;
  CPU developer fee remains **0%**.
- Tested package and isolated upgrade/rollback behavior, including direct
  migration from earlier field-tested Beta 5; user chain data, fee accounting
  and logs preserved in simulated migration tests.
- Previous NVIDIA Beta 5 showed ~3.41 kH/s GPU raw and 3.31 kH/s effective
  on a GTX 1660 Ti. The p2 launcher has not been separately GPU field-tested,
  and these are not general performance guarantees.

[Latest Beta 5 p2 release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2)

Verified Linux release archive SHA-256:
`bb31b66d94354e625add8030cd36824aaf9bab0afff5eb00ed9f3208633a8012`

---

## v1.3.8-rc3-beta.3 — NVIDIA and Core 1.0.7 (historical)

- Updated the bundled Core to **1.0.7** and improved chain IBD and
  deep-reorganization behavior.
- Additional process isolation, safe sync and release packaging changes.
- [Beta 3 release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.3)

## v1.3.8-rc3-beta.2 — Rootless installation (historical)

- Recommended installation without sudo and safer upgrade / rollback
  of stopped instances.
- [Beta 2 release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.2)

## v1.3.8-rc3-beta.1 — Limited Public Beta (MIT)

- First limited public beta for Linux x86-64 with NVIDIA CUDA and CPU mining.
- 12 architecture-specific precompiled CUDA workers, with no local `nvcc` required.
- Native-compiled hybrid controller and GPU developer-fee implementation.
- **4.5% GPU developer fee for ordinary mining work; 0% CPU fee.**
- **First-party code and compiled software are MIT-licensed.** The fee is
  the default behavior of unmodified software, not a restriction of the
  MIT permission to modify/redistribute covered software.
- Third-party attributions and original licenses are supplied in the
  executable release archive: `LICENSE-MANIFEST.md`,
  `THIRD_PARTY_NOTICES.md`, `licenses/`, `worker/licenses/` and
  `bin/NOTICES/`.
- Original GPU/CPU mining code, the compiled CUDA architecture workers,
  protected controller and fee CLI were retained byte-identically from
  the tested private RC3 preview. No mining algorithm/fee change.
- Offline paired GPU tests passed on GTX 1070, RTX 2080 Ti, RTX 3070,
  Quadro RTX 5000 and RTX 4060 Ti.
- Short CPU+GPU mainnet trials passed on Quadro RTX 5000 and RTX 4060 Ti;
  52 local GPU submissions were accepted, zero locally rejected.
- Recommended initial prebuilt node configuration: Ubuntu 24.04 x86-64,
  because `nightfalld` requires GLIBC_2.39.
- RTX 5070 (Blackwell, sm_120) installation and synchronization checks passed; continuous GPU mining and hashrate on this card have not been validated.
- Other Blackwell models, mixed-generation GPU rigs, older drivers and extended operation have not been certified.

Distribution policy: GitHub Releases hosts the audited miner archive and
matching SHA-256 file as **Release assets**, not committed into the public
documentation-only Git history.

Original archive SHA-256: `6b94518283bd777518f0968745c509f94d16e8c46b0f01c02b4b152d55cb991f`.
