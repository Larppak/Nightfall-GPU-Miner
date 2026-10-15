# Changelog

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
- Mixed physical GPU architectures, Blackwell, older drivers and extended
  continuous operation have not been hardware certified.

Distribution policy: GitHub Releases hosts the audited miner archive and
matching SHA-256 file as **Release assets**, not committed into the public
documentation-only Git history.

Original archive SHA-256: `6b94518283bd777518f0968745c509f94d16e8c46b0f01c02b4b152d55cb991f`.
