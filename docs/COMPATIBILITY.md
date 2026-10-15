# RC3 beta compatibility and validation

**Status: candidate documentation; not yet a public release or a certification.**

## Recommended operating system

The recommended first beta path is **Ubuntu 24.04 x86-64** with a compatible
NVIDIA driver, sufficient VRAM, and the package's `--use-prebuilt` Nightfall
Core 1.0.5 option. Other Linux distributions require separate validation.

| Linux distribution | Protected CUDA workers / fee controller | Bundled Core `--use-prebuilt` | First-beta recommendation |
| --- | --- | --- | --- |
| Ubuntu 24.04 | Loader tests PASS | Loader tests PASS | Recommended |
| Ubuntu 22.04 | Loader tests PASS | `nightfalld` loader test FAIL | Experimental source-build path only |
| Debian 12 | Loader tests PASS | `nightfalld` loader test FAIL | Experimental source-build path only |
| Ubuntu 20.04 | Loader tests PASS | Node and helper loader tests FAIL | Experimental source-build path only |
| Debian 11 | Loader tests PASS | Node and helper loader tests FAIL | Experimental source-build path only |

**Important detail:** The inherited `nightfalld` prebuilt references
`GLIBC_2.39`; the old helper executables have additional lower-version
requirements (including `GLIBC_2.34`). Describing the entire prebuilt Core
bundle simply as “glibc 2.34 compatible” would be misleading. This limitation
already existed before the RC3 precompiled GPU change. Source-building Core on
older distributions is an existing option but was not fully installer-tested
for this release candidate.

The native RC3 workers, controller and fee CLI passed their component/loader
checks in all five tested distribution roots. Those root tests do **not**
certify a complete GPU installation on every listed OS.

## GPU architecture coverage

The package builds an architecture-specific **native cubin/SASS** worker for
each of: `sm_50`, `sm_52`, `sm_60`, `sm_61`, `sm_70`, `sm_75`, `sm_80`,
`sm_86`, `sm_89`, `sm_90`, `sm_100` and `sm_120`.

Only the following **hardware models have RC3 measurements**:

| GPU | Compute capability | RC3 offline-worker median (H/s) | Status |
| --- | --- | ---: | --- |
| GTX 1070 | sm_61 | 2,604.83 | Offline GPU validation |
| RTX 2080 Ti | sm_75 | 4,609.32 | Offline GPU validation; rental reported 22 GiB |
| RTX 3070 | sm_86 | 4,676.82 | Offline GPU, service/autotune and installer-plan validation |
| Quadro RTX 5000 | sm_75 | 5,400.09 | Offline and short mainnet CPU/GPU validation |
| RTX 4060 Ti 16 GB | sm_89 | 4,174.60 | Offline and short mainnet CPU/GPU validation |

Offline results used batch 128 for the first three models; the last two are
their paired *autotuned-batch* medians (batch 288 and 136 respectively).
Different batches, GPU clocks, memory capacity and power limits make
cross-model comparisons unsuitable for declaring general GPU rankings.

These figures are measured reference results, **not guaranteed speeds**.

## Mainnet coverage

Two short RC3 mainnet validations on October 15, 2026:

- Quadro RTX 5000: 31 locally accepted GPU submissions, 0 not accepted.
- RTX 4060 Ti: 21 locally accepted GPU submissions, 0 not accepted.
- Both resumed simultaneous CPU/GPU mining after graceful service restarts and
  recovered automatically from canonical-guard pauses.

“Accepted” means accepted by the local Nightfall node, not independent proof
of final/spendable rewards. These machines used the maintainer's developer
address, so the **ordinary-user 4.5% live fee was not tested there**; it remains
covered by unchanged protected controller logic and software tests. RC3 still
needs wider uptime testing.

## Driver and other limitations

- NVIDIA proprietary driver required; the CUDA Toolkit/`nvcc` is **not**
  required to use the shipped GPU worker.
- `sm_50` through `sm_90` are built with CUDA 11.8; `sm_100` and `sm_120`
  with CUDA 12.8.1. Actual minimum driver also depends on GPU model.
- Blackwell needs an appropriate model-capable driver (R570 or newer, subject
  to vendor-specific restrictions). **Blackwell was not hardware tested**.
- Exact SM matching; no PTX/JIT fallback for unknown architectures.
- Real mixed-generation multi-GPU rigs and older NVIDIA driver branches have
  not been fully validated.
- Linux x86-64 only; no Windows, AMD GPU, or ARM/Jetson support is advertised.
- CPU prebuilts might have separate CPU instruction-set requirements; older
  CPUs may need Core to be built from source.

See [installation](INSTALL.md), [troubleshooting](TROUBLESHOOTING.md) and the
release's included third-party notices. All currently untested configurations
should be presented as experimental rather than broadly certified.
