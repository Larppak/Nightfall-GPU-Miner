#!/usr/bin/env python3
"""Stopped, user-owned installation upgrades. Never replace chain data or ledgers.

Public installer support; contains no fee scheduler or CUDA implementation.
Rollback restores application/configuration, retaining current chain and accounting.
"""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shlex
import shutil
import subprocess
import tempfile
import time


def require(ok, message):
    if not ok:
        raise ValueError(message)


def owned_file(path):
    require(path.is_file() and not path.is_symlink(), f"Not a regular file: {path}")
    require(path.stat().st_uid == os.geteuid(), f"Not owned by this account: {path}")


def contained(root, name):
    rel = PurePosixPath(name)
    require(not rel.is_absolute() and '..' not in rel.parts and str(rel) == name,
            f"Unsafe package path: {name}")
    dest = root / name
    require(dest.resolve().is_relative_to(root.resolve()), f"Path escapes installation: {name}")
    require(not any(p.is_symlink() for p in [dest, *dest.parents] if p != root.parent),
            f"Symlink in application path: {dest}")
    return dest


def package(root):
    names = (root / 'PACKAGE_FILES.txt').read_text().splitlines()
    require(len(names) == len(set(names)) and names, 'Duplicate/empty package inventory')
    hashes = {}
    for line in (root / 'MANIFEST.sha256').read_text().splitlines():
        digest, name = line.split('  ', 1)
        require(re.fullmatch('[0-9a-f]{64}', digest) and name not in hashes, 'Invalid manifest')
        hashes[name] = digest
    require(set(hashes) == set(names) - {'MANIFEST.sha256'}, 'Manifest/inventory mismatch')
    for name in names:
        p = contained(root, name)
        require(p.is_file(), f"Missing package file: {name}")
        if name in hashes:
            require(hashlib.sha256(p.read_bytes()).hexdigest() == hashes[name], f"Checksum mismatch: {name}")
    return names


def config(path):
    owned_file(path)
    text = path.read_text()
    values = {}
    for line in text.splitlines():
        if not line.strip() or line.lstrip().startswith('#'):
            continue
        match = re.fullmatch(r'([A-Za-z_][A-Za-z0-9_]*)=(.*)', line)
        require(match is not None, 'Configuration must contain literal KEY=value assignments only')
        raw = match[2]
        # Installer-generated values are shell quoted. Never execute a config while migrating it.
        require('$' not in raw and '`' not in raw, 'Expand shell expressions in configuration before upgrading')
        tokens = shlex.split(raw, comments=True)
        require(len(tokens) <= 1, f"Non-literal configuration: {match[1]}")
        require(match[1] not in values, f"Duplicate configuration key: {match[1]}")
        values[match[1]] = tokens[0] if tokens else ''
    return text, values


def rewrite(text, updates):
    seen = set()
    lines = []
    for line in text.splitlines():
        key = line.split('=', 1)[0]
        if key in updates:
            line = key + '=' + shlex.quote(str(updates[key]))
            seen.add(key)
        lines.append(line)
    lines += [k + '=' + shlex.quote(str(v)) for k, v in updates.items() if k not in seen]
    return '\n'.join(lines) + '\n'


def stopped(root, values):
    # Check all same-account command lines, not only possibly stale/missing PID files.
    needles = [str(root) + '/', values.get('NIGHTFALL_BIN', '')]
    for p in Path('/proc').glob('[0-9]*/cmdline'):
        try:
            if p.parent.name == str(os.getpid()) or p.stat().st_uid != os.geteuid():
                continue
            args = p.read_bytes().split(b'\0')
            # Only service executable/script arguments. Parent installer commands are harmless.
            for arg in args[:2]:
                value = arg.decode(errors='replace')
                if any(n and value.startswith(n) for n in needles):
                    if any(x in value for x in ('nightfalld', 'nightfall-hybrid-loop', 'nightfall_worker_service', 'sync_guard.py', 'web_dashboard.py', 'nightfall-worker-sm_')):
                        raise ValueError(f"Stop miner services first: process {p.parent.name}")
        except (FileNotFoundError, PermissionError):
            continue


def copy_file(source, dest):
    require(not dest.is_symlink(), f"Refusing symlink: {dest}")
    dest.parent.mkdir(parents=True, exist_ok=True)
    temp = dest.with_name(dest.name + '.upgrade-new')
    require(not temp.exists() and not temp.is_symlink(), f"Stale upgrade temporary file: {temp}")
    shutil.copy2(source, temp)
    os.replace(temp, dest)


def write_config(dest, text):
    with tempfile.NamedTemporaryFile(mode='w', prefix='.config-upgrade-', dir=dest.parent, delete=False) as f:
        temp = Path(f.name)
        f.write(text)
        f.flush()
        os.fsync(f.fileno())
    temp.chmod(0o600)
    os.replace(temp, dest)


def links(commands, prefix, old):
    for name in ('mine', 'minerctl', 'nightfall-dashboard'):
        p = commands / name
        if p.exists() or p.is_symlink():
            require(p.is_symlink() and p.resolve() in {(prefix / name).resolve(), (old / name).resolve()},
                    f"Existing unrelated command preserved: {p}")


def upgrade(args):
    source, old, dest, commands = map(lambda p: Path(p).expanduser().resolve(),
                                     (args.source, args.old, args.prefix, args.commands))
    names = package(source)
    old_names = package(old)
    text, values = config(old / 'config.env')
    require(not args.address or args.address == values.get('NIGHTFALL_MINER_ADDRESS'),
            'Upgrade preserves payout address; omit --address or use the existing address')
    require(dest == old or not dest.exists() or not any(dest.iterdir()), 'Destination must be empty')
    require(source != dest and not source.is_relative_to(dest), 'Extract upgrade outside the installed application')
    data = Path(values['NIGHTFALL_DATADIR']).resolve()
    require(data.is_dir() and os.access(data, os.W_OK), f"Existing data must be writable: {data}")
    run = Path(values.get('RUN_DIR', str(old / 'run'))).resolve()
    if args.user:
        require(os.geteuid() != 0, 'Run --user without sudo')
        for p in (dest, commands, data, run, Path(values.get('LOG_DIR', str(old / 'logs'))).resolve()):
            require(not any(p == Path(x) or p.is_relative_to(x) for x in ('/opt', '/usr', '/etc', '/var')),
                    f"User installation refuses system path: {p}")
        require(values.get('NIGHTFALL_RPC_HOST', '127.0.0.1') in ('localhost', '127.0.0.1', '::1'),
                'Configure RPC on localhost before upgrading')
        require(values.get('NIGHTFALL_RPC_LISTEN', '127.0.0.1:17881').startswith(('localhost:', '127.0.0.1:', '[::1]:')),
                'Configure the RPC listener on localhost before upgrading')
        require(values.get('NIGHTFALL_WEB_DASHBOARD_LISTEN', '127.0.0.1:17882').startswith(('localhost:', '127.0.0.1:', '[::1]:')),
                'Configure web dashboard on localhost before upgrading')
    stopped(old, values)
    links(commands, dest, old)
    subprocess.run([str(source / 'prebuilt/nightfalld'), '--version'], check=True)
    print(f"Upgrade plan: {'user / no sudo' if args.user else 'system'}\napplication={dest}\ndata={data} (reuse, never replace)\ncommands={commands}\nconfiguration/payout/accounting=preserved\nmodifies=application files, configuration version/paths, command links, rollback snapshot\nnetwork=none during upgrade; existing P2P and localhost RPC/web when started\nGPU fee=4.5%; CPU fee=0%; existing developer-address exemption retained\nservices=remain stopped")
    if args.plan:
        return
    run.mkdir(parents=True, exist_ok=True)
    with (run / 'minerctl.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        stopped(old, values)
        dest.mkdir(parents=True, exist_ok=True)
        snapshot = dest / '.rollback' / time.strftime('%Y%m%d-%H%M%S')
        snapshot.mkdir(parents=True, exist_ok=False)
        for name in old_names:
            copy_file(contained(old, name), contained(snapshot / 'files', name))
        copy_file(old / 'config.env', snapshot / 'config.env')
        old_core = Path(values['NIGHTFALL_BIN'])
        owned_file(old_core)
        copy_file(old_core, snapshot / 'nightfalld')
        metadata = {'old_prefix': str(old), 'names': old_names, 'new_names': names,
                    'data': str(data), 'run': str(run),
                    'core_sha256': hashlib.sha256((snapshot / 'nightfalld').read_bytes()).hexdigest()}
        (snapshot / 'snapshot.json').write_text(json.dumps(metadata, indent=2) + '\n')
        print(f"Rollback snapshot ready: {snapshot}\nRecovery: python3 {shlex.quote(str(source / 'safe_upgrade.py'))} rollback --prefix {shlex.quote(str(dest))} --snapshot {shlex.quote(str(snapshot))}", flush=True)
        for name in names:
            copy_file(contained(source, name), contained(dest, name))
        core_dir = dest / 'build/nightfall-target-1.0.6/release'
        for name, rel in [('nightfalld', 'nightfalld'), ('nightfall-address-check', 'nightfall-address-check'),
                          ('nightfall-fastpowbench', 'examples/nightfall-fastpowbench')]:
            copy_file(dest / 'prebuilt' / name, contained(core_dir, rel))
        # Keep existing state/data/log locations, including during migration to a new prefix.
        # This avoids copying stale accounting and preserves a single authoritative ledger.
        updates = {'AUTO_MINER_PACKAGE_VERSION': '1.3.8-rc3-beta.2',
                   'NIGHTFALL_UPSTREAM_VERSION': '1.0.6', 'NIGHTFALL_UPSTREAM_TAG': 'v1.0.6',
                   'NIGHTFALL_UPSTREAM_COMMIT': 'c483da76f2d1db99ae3e0c4dbb2130f2be47fd39',
                   'NIGHTFALL_BIN': str(core_dir / 'nightfalld'), 'RUN_DIR': str(run),
                   'LOG_DIR': values.get('LOG_DIR', str(old / 'logs'))}
        for key in ('NIGHTFALL_GPU_AUTOTUNE_FILE', 'NIGHTFALL_CPU_AUTOTUNE_FILE'):
            if key in values and values[key].startswith(str(old) + '/'):
                # Existing autotuning state remains valid and is deliberately reused.
                updates[key] = values[key]
        write_config(dest / 'config.env', rewrite(text, updates))
        run.chmod(0o700)
        for p in run.iterdir():
            if p.is_file() and not p.is_symlink() and p.stat().st_uid == os.geteuid():
                p.chmod(0o600)
        subprocess.run(['bash', str(dest / 'selftest.sh'), '--installed', str(dest)], check=True)
        commands.mkdir(parents=True, exist_ok=True)
        for name in ('mine', 'minerctl', 'nightfall-dashboard'):
            p = commands / name
            if p.is_symlink():
                p.unlink()
            p.symlink_to(dest / name)
        print(f"Upgrade complete. Start: {commands / 'minerctl'} start\nRollback (stop first): python3 {shlex.quote(str(dest / 'safe_upgrade.py'))} rollback --prefix {shlex.quote(str(dest))} --snapshot {shlex.quote(str(snapshot))}")


def rollback(args):
    dest = Path(args.prefix).resolve()
    snap = Path(args.snapshot).resolve()
    require(snap.is_relative_to(dest / '.rollback'), 'Snapshot must be inside this installation')
    owned_file(snap / 'snapshot.json')
    metadata = json.loads((snap / 'snapshot.json').read_text())
    package(snap / 'files')
    old_text, old_values = config(snap / 'config.env')
    require(hashlib.sha256((snap / 'nightfalld').read_bytes()).hexdigest() == metadata['core_sha256'],
            'Rollback Core checksum mismatch')
    # A migration interrupted before configuration creation can still be rolled back.
    current = config(dest / 'config.env')[1] if (dest / 'config.env').exists() else old_values
    stopped(dest, current)
    run = Path(current.get('RUN_DIR', str(dest / 'run')))
    with (run / 'minerctl.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        stopped(dest, current)
        for name in metadata['names']:
            copy_file(contained(snap / 'files', name), contained(dest, name))
        # Keep current authoritative data and counters, even after mining under Beta 2.
        updates = {'NIGHTFALL_BIN': str(snap / 'nightfalld'), 'RUN_DIR': str(run),
                   'LOG_DIR': current.get('LOG_DIR', str(dest / 'logs')),
                   'NIGHTFALL_DATADIR': current['NIGHTFALL_DATADIR']}
        write_config(dest / 'config.env', rewrite(old_text, updates))
        print('Rollback complete; chain data and current fee counters retained. Services remain stopped.')


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='action', required=True)
    up = sub.add_parser('upgrade')
    for name in ('source', 'prefix', 'commands'):
        up.add_argument('--' + name, required=True)
    up.add_argument('--from', dest='old', required=True)
    up.add_argument('--user', action='store_true')
    up.add_argument('--plan', action='store_true')
    up.add_argument('--address')
    back = sub.add_parser('rollback')
    back.add_argument('--prefix', required=True)
    back.add_argument('--snapshot', required=True)
    args = parser.parse_args()
    try:
        (upgrade if args.action == 'upgrade' else rollback)(args)
    except (ValueError, OSError, subprocess.CalledProcessError) as exc:
        parser.exit(2, f"Preservation check failed: {exc}\nNo chain reset or accounting rollback is performed. If application copying was interrupted, use the printed rollback snapshot.\n")


if __name__ == '__main__':
    main()
