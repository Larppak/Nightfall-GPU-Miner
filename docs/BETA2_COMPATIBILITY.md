# Beta 2 compatibility

Ubuntu 24.04 x86-64 with a working NVIDIA proprietary driver is the recommended
prebuilt environment. Core 1.0.6 is customized for this miner and compiled for
generic x86-64, not the build machine's CPU. The prebuilt Core requires glibc 2.39;
older systems need the explicit source-build option and separately installed
tools. No additional mandatory runtime libraries are introduced.

| Component | Beta 2 status |
| --- | --- |
| Customized Core 1.0.6 and helpers | Built on Ubuntu 24.04, generic x86-64 |
| CUDA workers and bridges | Byte-identical to Beta 1 |
| Native protected controller and fee CLI | Byte-identical to Beta 1 |
| Ubuntu 24.04 rootless install | PASS on local WSL with a fresh user HOME; start/stop/restart/web/sync checked |
| Ubuntu 20.04/22.04, Debian 11/12 bundled Core | Unsupported loader; glibc 2.39 is required |
| Older Linux explicit Core source build | Retained option, not revalidated for Beta 2 |

CUDA workers target sm_50/52/60/61/70/75/80/86/89/90/100/120. No readable PTX
fallback or CUDA kernel source is shipped. A suitable NVIDIA driver is required;
CUDA Toolkit is not required at runtime. Keeping the binaries unchanged preserves
the compiled architecture set but does not establish fresh hardware validation.

Beta 1 had installer/synchronization smoke evidence on RTX 5070 (Blackwell).
That is not a long-duration mining/performance claim. Beta 2 does not add new
Blackwell or physical mixed-generation validation. No AMD, ARM/Jetson or native
Windows runtime support is advertised. WSL validation is not a clean bare-metal
Ubuntu installation test. Full network effective-hashrate parity requires a
longer comparable chain-state measurement than a short smoke check.
