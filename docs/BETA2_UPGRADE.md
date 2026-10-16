# Safe Beta 1 upgrade and rollback

Extract Beta 2 outside the old application directory and verify its checksum.
Use the same installing account. Stop all old miner services, including an
optional web dashboard. The upgrade refuses a running installation, modified
package manifest, nonliteral configuration, different payout address, or an
unrelated destination/command link. Resolve these checks explicitly; never reset
chain data to bypass them.

For an existing user-owned default installation:

```bash
$HOME/.local/share/nightfall-miner/minerctl stop
$HOME/.local/share/nightfall-miner/minerctl web-stop
bash install.sh --user --upgrade --plan
bash install.sh --user --upgrade
$HOME/.local/bin/minerctl start
```

For a different user-owned Beta 1 location, pass `--upgrade-from /path/to/beta1`.
The application moves to the default user location; its existing chain, run state,
fee counters and logs stay in their original writable locations. Keep that old
directory: it remains the authoritative state location. No blockchain or wallet
file is overwritten or copied. CPU/GPU tuning, payout addresses, fee counters,
network configuration and synchronization guard settings are preserved.
If the old data/configuration belongs to root, first arrange a deliberate
user-owned copy or ownership migration yourself; this installer does not sudo or
change ownership. Do not run old and new application copies concurrently.

For an existing system installation, the advanced path is
`bash install.sh --system --upgrade --prefix /opt/nightfall-miner`, using the
account that owns the installation. Existing system permissions still apply.

The upgrade prints a rollback snapshot path under `.rollback/`. It saves the old
verified application, configuration and Core executable before replacing files.
Services remain stopped after upgrade. The chain format/genesis are unchanged in
upstream Core 1.0.6; data is reused without a reset.

To roll back, stop the miner/web dashboard and use the exact printed command:

```bash
python3 "$HOME/.local/share/nightfall-miner/safe_upgrade.py" rollback \
  --prefix "$HOME/.local/share/nightfall-miner" \
  --snapshot "$HOME/.local/share/nightfall-miner/.rollback/PRINTED_TIMESTAMP"
```

Rollback restores the old application and configuration, keeping the **current**
chain and fee counters. It does not rewind rewards/accounting. Start with the
full application path afterward. Preserve the snapshot while using its old Core
executable. If copying was interrupted, keep the snapshot and inspect the error
before running rollback; do not rerun a fresh installation over existing data.
