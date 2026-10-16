# Beta 2 quick start

Verify the downloaded `.tar.gz` against its `.sha256`, extract it, then run as your
ordinary user:

```bash
bash install.sh --user --address "nf1YOUR_PUBLIC_PAYOUT_ADDRESS"
export PATH="$HOME/.local/bin:$PATH"
mine
```

Ubuntu 24.04 x86-64 and a working NVIDIA driver are required for the bundled Core.
The installer reports missing tools; it does not install system dependencies.
It displays paths, fees, network activity and listeners before installation.
Application: `$HOME/.local/share/nightfall-miner`; data:
`$HOME/.local/share/nightfall-miner-data/mainnet`.

Use `minerctl stop`, `start`, `restart` and `status` without sudo. `mine --once`
prints one dashboard refresh. Optional web UI: `minerctl web-start`, then
`http://127.0.0.1:17882`; `minerctl web-stop` stops it.

Only a public payout address is needed. GPU fee: 4.5%; CPU fee: 0%.
Mining waits for canonical synchronization. A short startup check does not imply
that a fresh chain has fully synchronized.

For existing installations, stop first and read [Beta 2 upgrade guide](BETA2_UPGRADE.md).

Review the [public Beta 2 installer](../installer/install.sh) and [upgrade helper](../installer/safe_upgrade.py) before installing. These are review copies; run the installer from the verified release archive, not from the documentation repository.

**Release availability:** The Beta 2 binary download URL becomes usable only after the actual GitHub Release has been published.
