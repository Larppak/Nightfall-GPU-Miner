# RC3 Public Beta — publication acceptance checklist

**This is a maintainer checklist, not publication authorization.**
No binary archive, tag, GitHub Release, PR merge or repository visibility
change is approved merely because the documentation exists.

## A. License and ownership — BLOCKING

- [ ] Review whether the earlier broadly scoped MIT license applies to any
  executable or source components. **Do not assume rights already granted can
  be revoked retroactively.** Confirm original authorship and contributor rights.
- [ ] Resolve the conflict between the existing preview archive's unqualified
  `LICENSE` (MIT) and the proposed, separately scoped proprietary binary terms
  in `BINARY-LICENSE.md`. If distinct terms are legally supportable, incorporate
  clear, consistent scopes into the **newly packaged** beta itself.
- [ ] Keep mandatory Argon2, Hashcat (MIT), GCC runtime and NVIDIA CUDA runtime
  attributions/licenses, as well as Nightfall upstream and CPython/Nuitka notices.
  Audit additional included components; a license file's mere presence is not
  proof of full compliance.
- [ ] Remove “DRAFT” from the binary terms only **after** actual approval,
  and confirm public README, `LICENSE`, package `LICENSE`, binary terms and
  third-party notices do not contradict each other.

## B. Prepare a NEW release archive — BLOCKING

- [ ] Start from the unchanged, hardware-tested RC3 worker/controller binaries.
  Do not make an unrelated algorithm, CUDA kernel, wallet, or fee change.
- [ ] Proposed tag: `v1.3.8-rc3-beta.1`.
- [ ] Proposed archive name:
  `nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz`.
- [ ] The archive's top-level folder and `VERSION` must match the approved
  release naming. Keep `install.sh`, included README/QUICKSTART/MANUAL and
  actual supported GPU list consistent.
- [ ] Include approved binary license/third-party notices **inside** the archive.
- [ ] Generate a fresh exact file inventory, internal manifest and SHA-256 file.
  **Never reuse the private PREVIEW hash after repackaging.**
- [ ] Audit the complete extracted archive for secret material, development
  folders, credentials, fee/controller source, CUDA `.cu`/`.cuh` source,
  `.ptx` files and project bytecode. Preserve legally required third-party
  source and notices rather than blindly deleting everything that looks like code.
- [ ] Verify the set of GPU cubins and `cuobjdump --dump-ptx` results, ELF loader
  dependencies, worker hash selector and package self-test.
- [ ] Check that the new archive *actually* carries the corrected files (not
  merely a GitHub README change).

## C. Minimum first-beta acceptance

- [x] RC3 offline correctness/performance comparison passed on five GPU models.
- [x] RC3 short live CPU/GPU mainnet trials on Turing and Ada passed, with
  local submission acceptance and restart/canonical recovery.
- [x] Existing controller and fee binary regression and differential tests
  passed; no changes to those protected components.
- [ ] Validate the **newly repackaged** artifact: checksum, self-test and a
  clean Ubuntu 24.04 x86-64 prebuilt install with a compatible NVIDIA GPU.
- [ ] Check a fresh `--faststate` installation and its trust/canonical behavior,
  or explicitly defer it in public release notes if new-artifact testing is
  not possible. Do not hide a limitation.
- [ ] Review the ordinary-user 4.5% developer fee caveat: previous live fee
  results exist, latest RC3 hardware sessions used the maintainer address.
  A brief distinct-address RC3 check is recommended, but avoid calling
  ordinary-user mainnet fee *revalidated* until actually tested.
- [ ] Test/read confirmed Ubuntu 24.04 loader compatibility and prebuilt
  `nightfalld` GLIBC_2.39 requirement. Do not advertise Ubuntu 22.04 / Debian
  12 prebuilt support.
- [ ] Mark Blackwell, older drivers, physical mixed GPUs, unsupported Linux
  distributions and longer-term reliability as **untested/experimental**, not
  as certified.

## D. GitHub publication (only after explicit approval)

- [ ] Ensure the distribution repo's full branch history is public-safe;
  visibility changes can expose *all* branches and commit history.
- [ ] Merge or apply only public-safe docs to `main` after review.
- [ ] Finalize `docs/RELEASE_NOTES_RC3_BETA.md` with the actual asset names
  and *new* archive SHA-256; remove pending markers.
- [ ] Upload approved archive and `.sha256` as **GitHub Release assets**,
  NOT git commits or git-lfs blobs in distribution history.
- [ ] Verify downloading both Release assets as a user and running
  `sha256sum -c` against the actual newly packaged archive.
- [ ] Mark GitHub Release as `pre-release`, not stable/production.
- [ ] Add hardware/support limitations and clear 4.5% GPU / 0% CPU fee
  disclosure to release text.
- [ ] Change repository visibility to public and publish the release
  **only when the maintainer explicitly authorizes it**.
- [ ] Preserve the original RC3 private preview/checkpoint for rollback.

## Acceptance decision

**Currently: DOCUMENTATION PREPARED / PUBLICATION BLOCKED.**
Mandatory remaining work is a license-consistent *new artifact*, matching
documentation and a clean test of that final repack. Broad production
certification is *not* required for a clearly scoped public beta.
