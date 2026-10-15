# Changelog

## Unreleased — Nightfall GPU Miner v1.3.8 RC3 limited public beta candidate

**Preparation only.** No public executable or GitHub Release has been published.

### Candidate highlights

- Native, architecture-specific precompiled NVIDIA GPU workers instead of distributing
  proprietary CUDA kernel sources. Local `nvcc` is not required.
- Protected RC2 Nuitka hybrid controller and fee CLI retained byte-identically:
  ordinary-user GPU developer fee 4.5%; CPU developer fee 0%.
- GPU-model-specific worker selection, SHA-256 validation and multi-GPU software support.
- CPU/GPU hybrid mining, canonical chain guard, FastSync and optional trusted FastState.
- CUDA worker targets: sm_50/52/60/61/70/75/80/86/89/90/100/120.
  **Compiling a target does not certify hardware compatibility.**
- Five actual GPU models tested with short paired RC2/RC3 offline worker benchmarks:
  GTX 1070, RTX 2080 Ti, RTX 3070, Quadro RTX 5000 and RTX 4060 Ti.
- Quadro RTX 5000 and RTX 4060 Ti also observed mining together with CPU,
  service restarts and canonical recovery; 52 submissions locally accepted,
  0 locally rejected (not proof of final spendable rewards).
- Recommended first public beta installation: Ubuntu 24.04 x86-64 with compatible
  NVIDIA proprietary driver. Older distro/Core prebuilt limitations documented.
- Third-party licenses, protected binary license terms and final archive content
  must be reviewed before the **new** beta release asset can be approved.

### Open limitations

- Not a production release or unrestricted NVIDIA compatibility claim.
- Blackwell, real mixed-generation GPUs, many older drivers and long-duration
  behavior have not been hardware validated in RC3.
- Ordinary-user 4.5% fee accrual was not retested live during the two newest
  maintainer-address hardware sessions; unchanged fee controller software
  was extensively regression tested separately.
- Bundled `nightfalld` prebuilt references GLIBC_2.39; old-OS source-build Core
  path remains experimental for this first beta.

### Distribution policy

The clean distribution repository stores documentation and media only.
Only an **approved, newly packaged and audited** release archive and matching
checksum will be distributed as GitHub Release assets. Internal sources,
build history and protected implementation are not to be published.

See [draft release notes](docs/RELEASE_NOTES_RC3_BETA.md),
[installation](docs/INSTALL.md) and [compatibility](docs/COMPATIBILITY.md).
