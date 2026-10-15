# RC3 Beta 1 — simple publication checklist

**Agreed license model:** MIT for first-party Nightfall GPU Miner code/binaries.
No separately restrictive binary EULA. Vendor and other external materials
retain their applicable licenses. The 4.5% GPU fee (0% CPU fee) remains the
behavior of the unmodified miner.

## Engineering / release files

- [x] Stable, tested private RC3 preview; five paired GPU worker models.
- [x] Short live Quadro RTX 5000 and RTX 4060 Ti mainnet CPU/GPU tests.
- [x] MIT release archive generated, retaining byte-identical CUDA workers,
      native controller and fee CLI.
- [x] Archive's 141 entries, external/internal SHA-256 manifests, source leak
      scan, clean extraction and `selftest.sh` pass in Ubuntu 24.04 runner.
- [x] Add full Nightfall Core MIT/Apache, Hashcat MIT and argon2-rust MIT/NOTICE
      documents to existing NVIDIA, GCC, Nuitka, CPython and Argon2 notices.
- [x] Document GLIBC_2.39 requirement for bundled `nightfalld`.
- [x] First-party MIT README, installation guidance and draft release notes
      aligned with final archive filename and verified SHA-256.

Archive:
`nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz`

SHA-256: `6b94518283bd777518f0968745c509f94d16e8c46b0f01c02b4b152d55cb991f`

Engineering check:
https://github.com/Larppak/nightfall-miner/actions/runs/38763893508

## Remaining checks and actual publication

- [ ] Optional but recommended: final-archive clean GPU install/short FastState
      smoke on Ubuntu 24.04. Bin hashes are unchanged but packaging/docs changed.
- [ ] Review completeness of bundled transitive Rust crate notices.
      Existing and added licenses cover identified primary dependencies;
      engineering checksum validation alone is not full legal compliance.
- [ ] Make sure public distribution repository has **no private source, secrets
      or release archive committed to Git history**. All branches become
      visible if the repository is made public.
- [ ] Download `nightfall-miner-v1.3.8-rc3-beta.1-MIT-READY-FOR-UPLOAD`
      from the private Actions run (ZIP containing miner archive, sha256,
      and validation JSON). Extract that ZIP on a trusted computer.
- [ ] Publish a **pre-release** with tag `v1.3.8-rc3-beta.1` in the clean
      `Larppak/Nightfall-GPU-Miner` repository. Upload **only** the miner
      `.tar.gz` and matching `.sha256` as Release assets.
- [ ] Make the clean repository public. Never publicize the private
      `Larppak/nightfall-miner` development repository.
- [ ] Re-download the two public Release assets, verify SHA-256 and check
      that the public README and actual assets correspond.
- [ ] Collect beta issue reports with OS, GPU architecture and driver;
      clearly label untested Blackwell/mixed GPUs/older Linux as experimental.

**GitHub Release publication and visibility switching require a user/API
action and were not performed by documentation or package-check commits.**
