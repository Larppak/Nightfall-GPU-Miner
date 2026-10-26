# Review the Beta 2 installer

> **Archived Beta 2 review material.** The currently published version is [Beta 5 p2](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2). Its installer is bundled **inside the verified Beta 5 p2 release archive**; neither script in this directory is current.

These files are **byte-for-byte review copies** of the installer and upgrade
helper shipped inside the Beta 2 archive:

| Public review copy | File inside the release archive | Expected SHA-256 |
| --- | --- | --- |
| [install.sh](install.sh) | `install.sh` | `0604521670e21ed3effee5d328cec06e33e589fb374249bd72481eb66d968680` |
| [safe_upgrade.py](safe_upgrade.py) | `safe_upgrade.py` | `ae06600920122b8c0fd7cab5f92bd742b8561538842f3d7c635a196a375af1c4` |

**These are review copies, not standalone installers.** Download and extract
the **actual miner release archive**, verify its published SHA-256, then execute
the `install.sh` from **inside that extracted archive**. The installed package
requires the bundled native Core, CUDA workers, controller and other files;
running this bare script from the documentation repository will not work.

Main Beta 2 changes:

- User installation by default; no sudo, apt or Rustup on the rootless path
- Prints an installation plan showing files, network listeners and fees
- Stores application, chain data and configuration in user-writable locations
- Private permissions (config `0600`, runtime directory `0700`)
- RPC/dashboard bound to localhost by default
- Explicit safe upgrade/rollback of a stopped installation

A process running as your ordinary Linux user **can still access that user's
other readable files**. A dedicated Linux user or mining machine is safer for
untrusted software. Precompiled native binaries are not independently audited
merely because the installer source is reviewable.

Developer fee in the **unmodified miner**: 4.5% GPU work / 0% CPU.
First-party software uses the MIT license; third-party components retain
their licenses. The public script includes the payout *public address* by
design, never a private key.

See [Beta 2 quick start](../docs/BETA2_QUICKSTART.md) and
[upgrade instructions](../docs/BETA2_UPGRADE.md).
