#!/usr/bin/env bash
set -Eeuo pipefail
umask 077
export PYTHONDONTWRITEBYTECODE=1

PACKAGE_VERSION="1.3.8-rc3-beta.2"
UPSTREAM_VERSION="1.0.6"
UPSTREAM_TAG="v1.0.6"
TESTED_COMMIT="c483da76f2d1db99ae3e0c4dbb2130f2be47fd39"
EXPECTED_MAINNET_GENESIS="061a052d49607ff8f4b306c75d622ebd230cff4ec3a45a6dffc2f7738d4b20de"
SRC_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${NIGHTFALL_MINER_PREFIX:-${NIGHTFALL_NVIDIA_HYBRID_PREFIX:-}}"
USER_MODE=1; UPGRADE_FROM=""; UPGRADE=0; BUILD_CORE=0
REPO="${NIGHTFALL_REPO:-}"
DATADIR="${NIGHTFALL_DATADIR:-}"
ADDRESS="${NIGHTFALL_MINER_ADDRESS:-}"
DEFAULT_DEV_ADDRESS="nf160c88295622dc9bfc640318094f68c27e211312d22500c42ae95c4f6b1226a3ef618ca42caddb4e35e9ae177cf6c56821e5a419c33101645de787d3de7c6355b56b811e4"
DEV_ADDRESS="${NIGHTFALL_DEV_ADDRESS:-$DEFAULT_DEV_ADDRESS}"
GPU_DEV_FEE_BPS="${NIGHTFALL_GPU_DEV_FEE_BPS:-450}"
CPU_THREADS="${NIGHTFALL_CPU_THREADS:-auto}"
GPU_INDEX=""
GPU_DEVICES=""
CUDA_BATCH_OVERRIDE=""
PROXY="off"
RENTAL_USD_HOUR="${NIGHTFALL_RENTAL_USD_HOUR:-0}"
NO_START=0; NONINTERACTIVE=0; INSTALL_DEPS=0; PLAN_ONLY=0; SKIP_BOOTSTRAP=0
SKIP_CPU_AUTOTUNE=0; SKIP_GPU_AUTOTUNE=0; USE_PREBUILT=0
TARGET_SECONDS="8.0"; BOOTSTRAP_URL=""; BOOTSTRAP_SHA256=""
FASTSTATE=""; SOURCE_TAR=""; FASTSYNC_TRUST_OFFICIAL=1; POST_CANONICAL_WAIT=300; FASTSYNC_MODE=none
GPU_RESERVE_MIB=768
DASHBOARD_LISTEN="${NIGHTFALL_WEB_DASHBOARD_LISTEN:-127.0.0.1:17882}"

usage(){ cat <<EOF
Usage: $0 [options]
Nightfall Miner: Nightfall Core 1.0.6 + optimized CPU + NVIDIA GPU.
  --user                   Rootless installation (default); no package installers
  --system                 Advanced existing system installation method
  --build-core             Explicit source build with already installed tools
  --upgrade                Upgrade this stopped installation, preserving state
  --upgrade-from PATH      Migrate a stopped, accessible Beta 1 installation
  --address nf1...          Public USER payout address
  --dev-address nf1...      Public DEV payout address (default: protected developer address)
  --gpu-dev-fee-bps N       GPU dev fee in basis points (default: 450 = 4.5%)
  --cpu-threads N|auto      CPU mining workers (default auto)
  --gpu-index N             Single NVIDIA device index (e.g. 0)
  --gpu-devices LIST        NVIDIA device list for multi-GPU mining (e.g. 0,1,2,3 or all)
  --cuda-batch N            Force exact CUDA batch (skips GPU batch autotune)
  --repo PATH               Existing Nightfall source tree
  --datadir PATH            Chain data directory
  --prefix PATH             Install directory (default $PREFIX)
  --proxy VALUE             off or Nightfall proxy value
  --target-seconds N        GPU outer-cycle target (default 8.0)
  --rental-usd-hour N       Optional rental price for dashboard economics
  --dashboard-listen H:P    Optional browser dashboard address (default 127.0.0.1:17882)
  --use-prebuilt            Use verified prebuilt Nightfall Core 1.0.6 binaries (skips cargo build)
  --skip-cpu-autotune       Use topology/quota default CPU workers
  --skip-gpu-autotune       Use safe free-VRAM batch without performance sweep
  --install-deps            Explicit --system only: install missing apt dependencies
  --skip-bootstrap          Do not download/install official chain bootstrap
  --faststate PATH          Import a canonical Nightfall faststate v2/v3 tar instead of bootstrap
  --source-tar PATH         Use an offline Nightfall v1.0.6 source tar instead of GitHub clone
  --full-verify-bootstrap   Keep upstream behavior: re-verify downloaded bootstrap history locally
  --canonical-wait SEC      Wait after fastsync for canonical tip (default 300)
  --bootstrap-url URL       Override bootstrap .bin URL (requires --bootstrap-sha256)
  --bootstrap-sha256 HEX    SHA256 for --bootstrap-url
  --no-start                Install but do not start services
  --plan                    Hardware/plan only
  --non-interactive         Fail instead of prompting for required values
EOF
}
while [[ $# -gt 0 ]]; do case "$1" in
  --user) USER_MODE=1; shift;;
  --system) USER_MODE=0; shift;;
  --build-core) BUILD_CORE=1; shift;;
  --upgrade) UPGRADE=1; shift;;
  --upgrade-from) UPGRADE=1; UPGRADE_FROM="${2:?}"; shift 2;;
  --address=*) ADDRESS="${1#*=}"; shift;;
  --address) ADDRESS="${2:?}"; shift 2;;
  --dev-address=*) DEV_ADDRESS="${1#*=}"; shift;;
  --dev-address) DEV_ADDRESS="${2:?}"; shift 2;;
  --gpu-dev-fee-bps=*) GPU_DEV_FEE_BPS="${1#*=}"; shift;;
  --gpu-dev-fee-bps) GPU_DEV_FEE_BPS="${2:?}"; shift 2;;
  --cpu-threads=*) CPU_THREADS="${1#*=}"; shift;;
  --cpu-threads) CPU_THREADS="${2:?}"; shift 2;;
  --gpu-index=*) GPU_INDEX="${1#*=}"; shift;;
  --gpu-index) GPU_INDEX="${2:?}"; shift 2;;
  --gpu-devices=*) GPU_DEVICES="${1#*=}"; shift;;
  --gpu-devices) GPU_DEVICES="${2:?}"; shift 2;;
  --cuda-batch=*) CUDA_BATCH_OVERRIDE="${1#*=}"; shift;;
  --cuda-batch) CUDA_BATCH_OVERRIDE="${2:?}"; shift 2;;
  --repo=*) REPO="${1#*=}"; shift;;
  --repo) REPO="${2:?}"; shift 2;;
  --datadir=*) DATADIR="${1#*=}"; shift;;
  --datadir) DATADIR="${2:?}"; shift 2;;
  --prefix=*) PREFIX="${1#*=}"; shift;;
  --prefix) PREFIX="${2:?}"; shift 2;;
  --proxy) PROXY="${2:?}"; shift 2;;
  --target-seconds) TARGET_SECONDS="${2:?}"; shift 2;;
  --rental-usd-hour) RENTAL_USD_HOUR="${2:?}"; shift 2;;
  --dashboard-listen) DASHBOARD_LISTEN="${2:?}"; shift 2;;
  --use-prebuilt) USE_PREBUILT=1; shift;;
  --skip-cpu-autotune) SKIP_CPU_AUTOTUNE=1; shift;;
  --skip-gpu-autotune) SKIP_GPU_AUTOTUNE=1; shift;;
  --install-deps) INSTALL_DEPS=1; shift;;
  --skip-bootstrap) SKIP_BOOTSTRAP=1; shift;;
  --faststate) FASTSTATE="${2:?}"; shift 2;;
  --source-tar) SOURCE_TAR="${2:?}"; shift 2;;
  --full-verify-bootstrap) FASTSYNC_TRUST_OFFICIAL=0; shift;;
  --canonical-wait) POST_CANONICAL_WAIT="${2:?}"; shift 2;;
  --bootstrap-url) BOOTSTRAP_URL="${2:?}"; shift 2;;
  --bootstrap-sha256) BOOTSTRAP_SHA256="${2:?}"; shift 2;;
  --no-start) NO_START=1; shift;;
  --plan) PLAN_ONLY=1; shift;;
  --non-interactive) NONINTERACTIVE=1; shift;;
  -h|--help) usage; exit 0;;
  *) echo "Unknown option: $1" >&2; usage >&2; exit 2;;
 esac; done
# Resolve user-owned paths before any network access or system modification.
if [[ $USER_MODE -eq 1 ]]; then
  (( EUID != 0 )) || { echo "Run --user as your ordinary account, without sudo." >&2; exit 2; }
  PREFIX="${PREFIX:-$HOME/.local/share/nightfall-miner}"
  DATADIR="${DATADIR:-$HOME/.local/share/nightfall-miner-data/mainnet}"
  COMMAND_DIR="$HOME/.local/bin"
  (( INSTALL_DEPS == 0 )) || { echo "--user never installs system packages. Remove --install-deps; install dependencies separately." >&2; exit 2; }
  for location in "$PREFIX" "$DATADIR" "$COMMAND_DIR"; do
    resolved="$(realpath -m -- "$location")"
    case "$resolved" in /opt|/opt/*|/usr|/usr/*|/etc|/etc/*|/var|/var/*) echo "--user refuses system path: $resolved" >&2; exit 2;; esac
  done
  case "$DASHBOARD_LISTEN" in 127.0.0.1:*|localhost:*|\[::1\]:*) ;; *) echo "User dashboard must bind to localhost." >&2; exit 2;; esac
else
  PREFIX="${PREFIX:-/opt/nightfall-miner}"
  DATADIR="${DATADIR:-/workspace/nightfall-miner/mainnet}"
  COMMAND_DIR=/usr/local/bin
fi
PREFIX="$(realpath -m -- "$PREFIX")"; DATADIR="$(realpath -m -- "$DATADIR")"
REPO="${REPO:-$PREFIX/src/nightfall-1.0.6}"
USE_PREBUILT=1
(( BUILD_CORE == 0 )) || USE_PREBUILT=0
if (( UPGRADE )); then
  [[ -z "$FASTSTATE" && -z "$BOOTSTRAP_URL" ]] || { echo "An upgrade reuses chain data; snapshot replacement is not allowed." >&2; exit 2; }
  upgrade_args=(upgrade --source "$SRC_DIR" --from "${UPGRADE_FROM:-$PREFIX}" --prefix "$PREFIX" --commands "$COMMAND_DIR")
  [[ -z "$ADDRESS" ]] || upgrade_args+=(--address "$ADDRESS")
  (( USER_MODE == 0 )) || upgrade_args+=(--user)
  (( PLAN_ONLY == 0 )) || upgrade_args+=(--plan)
  exec python3 "$SRC_DIR/safe_upgrade.py" "${upgrade_args[@]}"
fi
if [[ -e "$PREFIX/config.env" || ( -d "$PREFIX" && -n "$(ls -A -- "$PREFIX")" ) ]]; then
  echo "Existing installation/directory preserved: $PREFIX. Stop it and use --upgrade (or select an empty prefix)." >&2; exit 2
fi
if [[ -d "$DATADIR" && -n "$(ls -A -- "$DATADIR")" ]]; then
  echo "Existing data preserved at $DATADIR. Use --upgrade-from to reuse it safely." >&2; exit 2
fi
required=(bash python3 curl sha256sum tar flock pgrep timeout nvidia-smi)
(( USE_PREBUILT == 1 )) || required+=(git make g++ cmake pkg-config cargo rustc rustfmt)
missing=(); for tool in "${required[@]}"; do command -v "$tool" >/dev/null 2>&1 || missing+=("$tool"); done
cat <<EOF
Installation plan (before changes)
mode=$([[ $USER_MODE == 1 ]] && echo 'user / no root privileges' || echo 'system / explicit advanced mode')
application=$PREFIX
data=$DATADIR
commands=$COMMAND_DIR/{mine,minerctl,nightfall-dashboard}
dependencies=${required[*]}
missing_dependencies=${missing[*]:-none}
modifies=verified package files under application; config.env; run/; logs/; data; three command links
system_modifications=$([[ $USER_MODE == 1 || $INSTALL_DEPS == 0 ]] && echo none || echo 'explicit --install-deps apt packages')
network=api.github.com/repos/Instinctes/nightfall/releases/tags/chain-bootstrap; github.com/Instinctes/nightfall release assets and GitHub asset CDN; https://nightfallcoin.org/peers; seed.nightfallcoin.org:17891, seed2.nightfallcoin.org:17891, seed3.nightfallcoin.org:17891 and discovered P2P peers
source_network=$([[ $BUILD_CORE == 1 ]] && echo 'GitHub pinned source, crates.io Rust dependencies' || echo none)
listeners=P2P 0.0.0.0:17891; RPC 127.0.0.1:17881; optional web $DASHBOARD_LISTEN
GPU_developer_fee=4.5% of completed GPU work (existing developer-address exemption retained)
CPU_developer_fee=0%
secrets=public payout address only; no wallet seed/private key
EOF
if (( ${#missing[@]} > 0 )); then
  if [[ $USER_MODE == 0 && $INSTALL_DEPS == 1 && $PLAN_ONLY == 0 ]]; then
    echo "Explicit system dependency installation will run below."
  else
    echo "Missing dependencies: ${missing[*]}. Install the corresponding Ubuntu packages (python3, curl, coreutils, util-linux, procps; NVIDIA driver) separately, then rerun. Source builds additionally need Rust and build tools." >&2
    exit 2
  fi
fi
# Verify every allowlisted file before executing bundled components or creating paths.
python3 - "$SRC_DIR" <<'PY'
import sys
from pathlib import Path
sys.path.insert(0, sys.argv[1])
from safe_upgrade import package
package(Path(sys.argv[1]))
PY
for name in mine minerctl nightfall-dashboard; do
  link="$COMMAND_DIR/$name"
  if [[ -e "$link" || -L "$link" ]]; then
    [[ -L "$link" && "$(readlink -- "$link")" == "$PREFIX/$name" ]] || { echo "Existing command preserved: $link. Choose another account or remove/rename it yourself." >&2; exit 2; }
  fi
done

# Always query the latest official bootstrap for a fresh install. An existing
# /workspace/nightfall-faststate-v3.tar is not chosen implicitly: an old copied
# snapshot must never silently override newest official bootstrap selection.
# Use --faststate PATH explicitly when that trust model is intended.
if [[ "$GPU_DEV_FEE_BPS" == "auto" || -z "$GPU_DEV_FEE_BPS" ]]; then
  GPU_DEV_FEE_BPS=450
fi
DEV_ADDRESS="${DEV_ADDRESS:-$DEFAULT_DEV_ADDRESS}"
if [[ -n "$ADDRESS" && "${ADDRESS,,}" == "${DEFAULT_DEV_ADDRESS,,}" ]]; then
  echo "Notice: Developer payout address detected. 100% of mining rewards will be credited directly to your address."
  GPU_DEV_FEE_BPS=0
  DEV_ADDRESS=""
fi
[[ "$GPU_DEV_FEE_BPS" =~ ^[0-9]+$ && "$GPU_DEV_FEE_BPS" -ge 0 && "$GPU_DEV_FEE_BPS" -le 1000 ]] || { echo "--gpu-dev-fee-bps must be between 0 and 1000" >&2; exit 2; }
[[ "$GPU_DEV_FEE_BPS" == "0" || ( -n "$DEV_ADDRESS" && "${DEV_ADDRESS,,}" != "${ADDRESS,,}" ) ]] || { echo "GPU dev fee requires a distinct --dev-address" >&2; exit 2; }
[[ "$TARGET_SECONDS" =~ ^[0-9]+([.][0-9]+)?$ ]] || { echo "Invalid --target-seconds" >&2; exit 2; }
[[ "$RENTAL_USD_HOUR" =~ ^[0-9]+([.][0-9]+)?$ ]] || { echo "Invalid --rental-usd-hour" >&2; exit 2; }
[[ "$POST_CANONICAL_WAIT" =~ ^[0-9]+([.][0-9]+)?$ ]] || { echo "Invalid --canonical-wait" >&2; exit 2; }
[[ -z "$FASTSTATE" || -f "$FASTSTATE" ]] || { echo "--faststate not found: $FASTSTATE" >&2; exit 2; }
[[ -z "$SOURCE_TAR" || -f "$SOURCE_TAR" ]] || { echo "--source-tar not found: $SOURCE_TAR" >&2; exit 2; }
[[ "$CPU_THREADS" == "auto" || "$CPU_THREADS" =~ ^[1-9][0-9]*$ ]] || { echo "--cpu-threads must be auto or positive integer" >&2; exit 2; }
[[ -z "$CUDA_BATCH_OVERRIDE" || "$CUDA_BATCH_OVERRIDE" =~ ^[1-9][0-9]*$ ]] || { echo "--cuda-batch must be positive integer" >&2; exit 2; }

prompt(){ local var="$1" text="$2" def="${3:-}" val=""; if [[ $NONINTERACTIVE -eq 1 ]]; then [[ -n "${!var:-}" ]] || { echo "Missing required value: $var" >&2; exit 2; }; return; fi; if [[ -n "$def" ]]; then read -r -p "$text [$def]: " val; val="${val:-$def}"; else read -r -p "$text: " val; fi; printf -v "$var" '%s' "$val"; }

install_basic_deps(){
  command -v apt-get >/dev/null 2>&1 || { echo "Automatic package installation requires apt-get. Please install git, build-essential, cmake, pkg-config, curl, libssl-dev manually." >&2; return 1; }
  echo "=== Installing required system build packages via apt ==="
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y git build-essential cmake pkg-config ca-certificates curl python3 python3-venv util-linux pciutils libssl-dev
}

ensure_rust(){
  for tool in cargo rustc rustfmt; do
    command -v "$tool" >/dev/null || { echo "Source build requires $tool. Install it separately; no Rustup is run by this installer." >&2; exit 2; }
  done
}

check_upstream_version(){
  if command -v git >/dev/null 2>&1; then
    local latest_tag
    latest_tag="$(git ls-remote --tags https://github.com/Instinctes/nightfall.git 2>/dev/null | grep -o 'refs/tags/v[0-9.]*' | sed 's#refs/tags/##' | sort -V | tail -1 || true)"
    if [[ -n "$latest_tag" ]]; then
      echo "=== Upstream Nightfall check: latest remote release is $latest_tag (miner target: $UPSTREAM_TAG) ==="
      if [[ "$latest_tag" != "$UPSTREAM_TAG" ]]; then
        echo "INFO: A newer upstream Nightfall release ($latest_tag) exists beyond current target ($UPSTREAM_TAG)."
      fi
    fi
  fi
}


if [[ $PLAN_ONLY -eq 0 && $USER_MODE -eq 0 && $INSTALL_DEPS -eq 1 && ${#missing[@]} -gt 0 ]]; then
  install_basic_deps
fi
[[ $USE_PREBUILT -eq 1 ]] || ensure_rust
command -v nvidia-smi >/dev/null 2>&1 || { echo "nvidia-smi missing: NVIDIA GPU/driver is required" >&2; exit 1; }

HW_JSON="$(mktemp)"; CAL_PID=""
cleanup_install(){
  if [[ -n "$CAL_PID" ]]; then kill -TERM "$CAL_PID" 2>/dev/null || true; wait "$CAL_PID" 2>/dev/null || true; fi
  rm -f "$HW_JSON"
}
trap cleanup_install EXIT
python3 "$SRC_DIR/detect_hardware.py" >"$HW_JSON"
jv(){ python3 - "$HW_JSON" "$1" <<'PY'
import json,sys
v=json.load(open(sys.argv[1]))
for p in sys.argv[2].split('.'):
    if p: v=v[int(p)] if isinstance(v,list) else v.get(p)
if v is None: print('')
elif isinstance(v,bool): print('1' if v else '0')
else: print(v)
PY
}
CPU_MODEL="$(jv cpu_model)"; LOGICAL_CPUS="$(jv logical_cpus)"; PHYSICAL_CORES="$(jv physical_cores)"; MEMORY_MIB="$(jv memory_available_mib)"; SUGGESTED_CPU_THREADS="$(jv suggested_cpu_threads_hybrid)"; CPU_QUOTA="$(jv cgroup_cpu_quota_cores)"
GPU_COUNT="$(python3 -c 'import json,sys; print(len(json.load(open(sys.argv[1]))["nvidia_gpus"]))' "$HW_JSON")"
(( GPU_COUNT > 0 )) || { echo "No NVIDIA GPU detected" >&2; exit 1; }
cat <<EOF
Nightfall Miner $PACKAGE_VERSION
--------------------------------------------
CPU:      $CPU_MODEL
Topology: $PHYSICAL_CORES physical / $LOGICAL_CPUS logical CPU(s)
CPU quota:${CPU_QUOTA:- unlimited/unknown}
Memory:   $MEMORY_MIB MiB available
EOF
python3 - "$HW_JSON" <<'PY'
import json,sys
for g in json.load(open(sys.argv[1]))['nvidia_gpus']:
 print(f"NVIDIA {g['index']}: {g['name']} | {g['memory_mib']} MiB total / {g['memory_free_mib']} MiB free | compute {g.get('compute_cap') or 'unknown'} | driver {g.get('driver_version')}")
PY
if [[ -z "$GPU_INDEX" && -z "$GPU_DEVICES" ]]; then
  if (( GPU_COUNT > 1 )); then
    GPU_DEVICES="$(seq -s, 0 $((GPU_COUNT-1)))"
    GPU_INDEX="0"
    echo "=== Multi-GPU system detected ($GPU_COUNT GPUs): automatically enabling all GPUs ($GPU_DEVICES) ==="
  else
    DEFAULT_GPU="$(jv selected_nvidia.index)"
    GPU_INDEX="${DEFAULT_GPU:-0}"
    GPU_DEVICES="$GPU_INDEX"
  fi
elif [[ -n "$GPU_DEVICES" ]]; then
  if [[ "$GPU_DEVICES" == "all" ]]; then
    GPU_DEVICES="$(seq -s, 0 $((GPU_COUNT-1)))"
  fi
  GPU_INDEX="${GPU_DEVICES%%,*}"
else
  GPU_DEVICES="$GPU_INDEX"
fi
GPU_INFO="$(python3 - "$HW_JSON" "$GPU_INDEX" <<'PY'
import json,sys
h=json.load(open(sys.argv[1])); idx=int(sys.argv[2])
for g in h['nvidia_gpus']:
 if g['index']==idx: print(json.dumps(g)); break
else: raise SystemExit(1)
PY
)" || { echo "GPU index $GPU_INDEX not found" >&2; exit 1; }
GPU_NAME="$(python3 -c 'import json,sys; print(json.load(sys.stdin)["name"])' <<<"$GPU_INFO")"; GPU_MEMORY_MIB="$(python3 -c 'import json,sys; print(json.load(sys.stdin)["memory_mib"])' <<<"$GPU_INFO")"; GPU_CAP="$(python3 -c 'import json,sys; print(json.load(sys.stdin).get("compute_cap") or "")' <<<"$GPU_INFO")"
[[ -n "$GPU_CAP" ]] || { echo "Could not detect NVIDIA compute capability" >&2; exit 1; }; CUDA_ARCH="sm_${GPU_CAP/./}"
python3 "$SRC_DIR/cuda_workers.py" --verify-devices "$GPU_DEVICES"
SAFE_PLAN="$(python3 "$SRC_DIR/select_cuda_batch.py" --device "$GPU_INDEX" --reserve-mib "$GPU_RESERVE_MIB" 2>/dev/null || true)"
SAFE_BATCH_PLAN=0
if [[ -n "$SAFE_PLAN" ]]; then
  SAFE_BATCH_PLAN="$(python3 -c 'import json,sys; print(json.load(sys.stdin).get("batch",0))' <<<"$SAFE_PLAN" 2>/dev/null || echo 0)"
fi

if [[ -z "$ADDRESS" ]]; then
  [[ $NONINTERACTIVE -eq 1 ]] && { echo "--address required in non-interactive mode" >&2; exit 2; }
  echo ""
  echo "========================================================================"
  echo "            Nightfall Miner $PACKAGE_VERSION â€” Interactive Setup"
  echo "========================================================================"
  echo "[+] Detected CPU: $CPU_MODEL"
  echo "    Topology: $PHYSICAL_CORES physical cores / $LOGICAL_CPUS threads (Hybrid optimal: $SUGGESTED_CPU_THREADS threads)"
  echo "[+] Detected GPU: $GPU_NAME ($CUDA_ARCH)"
  echo "    VRAM: $((GPU_MEMORY_MIB)) MiB | Safe initial batch: $SAFE_BATCH_PLAN"
  echo "========================================================================"
  echo ""
  prompt ADDRESS "Enter your Nightfall mining payout address (public nf1... address)"
fi
while [[ ! "$ADDRESS" =~ ^nf1[0-9A-Fa-f]{136}$ ]]; do
  echo "Bad nf1 address format. A Nightfall address starts with 'nf1' followed by 136 hex characters." >&2
  ADDRESS=""
  [[ $NONINTERACTIVE -eq 1 ]] && exit 2
  prompt ADDRESS "Enter your Nightfall mining payout address (public nf1... address)"
done
if [[ -z "$DATADIR" ]]; then
  if [[ -d /workspace ]]; then
    DATADIR="/workspace/nightfall-miner/mainnet"
  else
    DATADIR="$(pwd)/nightfall-data/mainnet"
  fi
  echo "Using Nightfall chain data directory: $DATADIR"
fi
# Rental-friendly source fallback. A prepared local source tree/tar avoids a paid
# instance waiting on GitHub if the provider has broken outbound connectivity.
if [[ -z "$REPO" ]]; then
  if [[ -f /workspace/nightfall-src-offline/Cargo.toml ]]; then
    REPO="/workspace/nightfall-src-offline"
  else
    REPO="$PREFIX/src/nightfall-1.0.6"
    if [[ -z "$SOURCE_TAR" && -f /workspace/nightfall-v1.0.6-offline.tar.gz ]]; then
      SOURCE_TAR="/workspace/nightfall-v1.0.6-offline.tar.gz"
    fi
  fi
fi

cat <<EOF
Selected plan
-------------
mode=hybrid-required
payout=$ADDRESS
dev_payout=${DEV_ADDRESS:-not-configured}
cpu_backend=argon2-rust-1.1-nozeroize + official RustCrypto winner recheck
cpu_threads=${CPU_THREADS} (topology suggestion $SUGGESTED_CPU_THREADS)
gpu=$GPU_NAME device=$GPU_INDEX arch=$CUDA_ARCH
gpu_kernel=fixedschedule-v1
gpu_safe_batch_now=$SAFE_BATCH_PLAN
gpu_batch=${CUDA_BATCH_OVERRIDE:-autotune}
repo=$REPO
datadir=$DATADIR
prefix=$PREFIX
faststate=${FASTSTATE:-none}
source_tar=${SOURCE_TAR:-none}
official_bootstrap_mode=$([[ $FASTSYNC_TRUST_OFFICIAL -eq 1 ]] && echo fastsync-trusted-sha || echo full-local-verification)
EOF
if [[ $USE_PREBUILT -eq 1 ]]; then
  "$SRC_DIR/prebuilt/nightfalld" --version >/dev/null || { echo "Bundled Core cannot run here. Ubuntu 24.04 x86-64 is supported; use --build-core only with separately installed build tools." >&2; exit 2; }
fi
[[ $PLAN_ONLY -eq 1 ]] && { echo NIGHTFALL_MINER_PLAN_PASS; exit 0; }

mkdir -p "$PREFIX" "$PREFIX/src" "$PREFIX/build" "$PREFIX/run" "$PREFIX/logs" "$DATADIR"
chmod 700 "$PREFIX" "$PREFIX/run" "$PREFIX/logs" "$DATADIR"
# Install only the verified production file list, including nested runtime libraries.
(cd "$SRC_DIR" && sha256sum -c MANIFEST.sha256 >/dev/null)
while IFS= read -r rel; do
  case "$rel" in ""|/*|*..*|*\\*) echo "Invalid production manifest path" >&2; exit 1;; esac
  [[ -f "$SRC_DIR/$rel" && ! -L "$SRC_DIR/$rel" ]] || { echo "Package file missing: $rel" >&2; exit 1; }
  mkdir -p "$PREFIX/$(dirname -- "$rel")"
  cp -f "$SRC_DIR/$rel" "$PREFIX/$rel"
done < "$SRC_DIR/PACKAGE_FILES.txt"
chmod +x "$PREFIX"/*.py "$PREFIX/install.sh" "$PREFIX/minerctl" "$PREFIX/nightfall-dashboard" "$PREFIX/mine" "$PREFIX/selftest.sh" "$PREFIX/worker"/*.py "$PREFIX/bin/nightfall-hybrid-loop" "$PREFIX/bin/fee-cli/nightfall-fee-cli"
mkdir -p "$PREFIX/build/nightfall-target-1.0.6/release/examples"
cp -f "$PREFIX/prebuilt/nightfall-fastpowbench" "$PREFIX/build/nightfall-target-1.0.6/release/examples/nightfall-fastpowbench"
chmod +x "$PREFIX/build/nightfall-target-1.0.6/release/examples/nightfall-fastpowbench"
echo "=== Package self-test ==="; "$PREFIX/selftest.sh"
if [[ ! -f "$REPO/Cargo.toml" && -n "$SOURCE_TAR" ]]; then
  echo "=== Extracting offline Nightfall source ==="
  TMP_SRC="$(mktemp -d)"
  tar -xzf "$SOURCE_TAR" -C "$TMP_SRC"
  FOUND_SRC="$(find "$TMP_SRC" -maxdepth 3 -type f -name Cargo.toml -printf '%h\n' | head -1)"
  [[ -n "$FOUND_SRC" ]] || { rm -rf "$TMP_SRC"; echo "Offline source tar contains no Cargo.toml" >&2; exit 43; }
  rm -rf "$REPO"; mkdir -p "$(dirname "$REPO")"; mv "$FOUND_SRC" "$REPO"
  rm -rf "$TMP_SRC"
fi
TARGET_DIR="$PREFIX/build/nightfall-target-1.0.6"
mkdir -p "$TARGET_DIR/release" "$TARGET_DIR/release/examples"
if [[ $USE_PREBUILT -eq 1 || ( ! -x "$(command -v cargo)" && -f "$SRC_DIR/prebuilt/nightfalld" ) ]]; then
  echo "=== Using verified prebuilt Nightfall Core 1.0.6 binaries ==="
  [[ -f "$SRC_DIR/prebuilt/nightfalld" ]] || { echo "Prebuilt nightfalld not found in $SRC_DIR/prebuilt" >&2; exit 1; }
  cp -f "$SRC_DIR/prebuilt/nightfalld" "$TARGET_DIR/release/nightfalld"
  cp -f "$SRC_DIR/prebuilt/nightfall-address-check" "$TARGET_DIR/release/nightfall-address-check"
  cp -f "$SRC_DIR/prebuilt/nightfall-fastpowbench" "$TARGET_DIR/release/examples/nightfall-fastpowbench"
  chmod +x "$TARGET_DIR/release/nightfalld" "$TARGET_DIR/release/nightfall-address-check" "$TARGET_DIR/release/examples/nightfall-fastpowbench"
else
  if [[ ! -f "$REPO/Cargo.toml" ]]; then
    echo "=== Cloning pinned Nightfall source ==="; rm -rf "$REPO"; git clone --depth 1 --branch "$UPSTREAM_TAG" https://github.com/Instinctes/nightfall.git "$REPO"; HEAD_COMMIT="$(git -C "$REPO" rev-parse HEAD)"; [[ "$HEAD_COMMIT" == "$TESTED_COMMIT" ]] || { echo "Nightfall tag $UPSTREAM_TAG resolved to $HEAD_COMMIT, expected $TESTED_COMMIT" >&2; exit 43; }
  else
    echo "=== Existing/offline source: $REPO ==="
    HEAD_COMMIT="$(git -C "$REPO" rev-parse HEAD 2>/dev/null || true)"
    [[ "$HEAD_COMMIT" == "$TESTED_COMMIT" ]] || { echo "Existing source HEAD=$HEAD_COMMIT, expected Nightfall $UPSTREAM_VERSION commit $TESTED_COMMIT" >&2; exit 43; }
  fi
  python3 "$PREFIX/patch_nightfall.py" --repo "$REPO"
  python3 "$PREFIX/patch_fast_cpu.py" --repo "$REPO"
  python3 "$PREFIX/patch_ibd_io.py" --repo "$REPO"
  rustfmt --edition 2021 "$REPO/crates/nightfall-node/src/gpu_worker.rs" "$REPO/crates/nightfall-node/src/bin/nightfall-address-check.rs" "$REPO/crates/nightfall-node/src/lib.rs" "$REPO/crates/nightfall-node/src/rpc.rs" "$REPO/crates/nightfall-node/src/runtime.rs" "$REPO/crates/nightfall-node/src/main.rs" "$REPO/crates/nightfall-crypto/src/pow.rs" "$REPO/crates/nightfall-crypto/examples/nightfall-fastpowbench.rs"
  echo "=== Building Nightfall for current CPU ==="
  (cd "$REPO"; CARGO_TARGET_DIR="$TARGET_DIR" RUSTFLAGS="${RUSTFLAGS:--C target-cpu=x86-64}" cargo build --release -p nightfall-node --bin nightfalld --bin nightfall-address-check)
  (cd "$REPO"; CARGO_TARGET_DIR="$TARGET_DIR" RUSTFLAGS="${RUSTFLAGS:--C target-cpu=x86-64}" cargo build --release -p nightfall-crypto --example nightfall-fastpowbench)
  echo "=== CPU cross-backend correctness gate ==="
  (cd "$REPO"; CARGO_TARGET_DIR="$TARGET_DIR" RUSTFLAGS="${RUSTFLAGS:--C target-cpu=x86-64}" cargo test --release -p nightfall-crypto fast_backend_matches_official_with_dirty_arena --lib -- --nocapture)
fi
NIGHTFALL_BIN="$TARGET_DIR/release/nightfalld"; ADDRESS_CHECK="$TARGET_DIR/release/nightfall-address-check"; CPU_BENCH="$TARGET_DIR/release/examples/nightfall-fastpowbench"
[[ -x "$NIGHTFALL_BIN" && -x "$ADDRESS_CHECK" && -x "$CPU_BENCH" ]] || { echo "Nightfall build output missing" >&2; exit 1; }
ADDRESS="$($ADDRESS_CHECK "$ADDRESS")"; echo "USER address accepted by Nightfall: $ADDRESS"
if [[ -n "$DEV_ADDRESS" ]]; then
  DEV_ADDRESS="$($ADDRESS_CHECK "$DEV_ADDRESS")"
  echo "DEV address accepted by Nightfall: $DEV_ADDRESS"
fi
VERIFY_DIR="$(mktemp -d)"; "$NIGHTFALL_BIN" --network mainnet --datadir "$VERIFY_DIR" init >/dev/null; ACTUAL_GENESIS="$("$NIGHTFALL_BIN" --network mainnet --datadir "$VERIFY_DIR" status 2>/dev/null | awk '/^genesis/ {print $NF; exit}')"; rm -rf "$VERIFY_DIR"; [[ "$ACTUAL_GENESIS" == "$EXPECTED_MAINNET_GENESIS" ]] || { echo "Mainnet genesis mismatch" >&2; exit 42; }; echo "Mainnet genesis verified: $ACTUAL_GENESIS"

# CPU autotune uses the actual patched Nightfall mining function.
CPU_AUTOTUNE_JSON="$PREFIX/run/cpu-autotune.json"
CPU_HPS=0
if [[ "$CPU_THREADS" == "auto" ]]; then
  if [[ $SKIP_CPU_AUTOTUNE -eq 0 ]]; then
    echo "=== CPU mining autotune ==="
    CPU_TUNE_LOG="$PREFIX/logs/cpu-autotune.log"
    python3 "$PREFIX/cpu_autotune.py" --binary "$CPU_BENCH" --physical "$PHYSICAL_CORES" --logical "$LOGICAL_CPUS" --seconds 3 --reps 2 | tee "$CPU_TUNE_LOG"
    CPU_LINE="$(grep '^CPU_AUTOTUNE_JSON=' "$CPU_TUNE_LOG" | tail -1 | cut -d= -f2-)"
    [[ -n "$CPU_LINE" ]] || { echo "CPU autotune produced no result" >&2; exit 1; }
    printf '%s\n' "$CPU_LINE" > "$CPU_AUTOTUNE_JSON"
    CPU_THREADS="$(python3 -c 'import json,sys; j=json.load(sys.stdin); print(j["selected_threads"])' <<<"$CPU_LINE")"
    CPU_HPS="$(python3 -c 'import json,sys; j=json.load(sys.stdin); print(j["selected_hps"])' <<<"$CPU_LINE")"
  else
    CPU_THREADS="$SUGGESTED_CPU_THREADS"
  fi
fi
[[ "$CPU_THREADS" =~ ^[1-9][0-9]*$ ]] || { echo "CPU thread selection failed" >&2; exit 1; }
(( CPU_THREADS <= LOGICAL_CPUS )) || { echo "CPU threads exceed visible CPUs" >&2; exit 1; }
echo "CPU selected: threads=$CPU_THREADS measured=${CPU_HPS} H/s"

echo "=== Verifying protected workers and CUDA correctness ==="
python3 "$PREFIX/cuda_workers.py" --verify-devices "$GPU_DEVICES"
IFS=',' read -ra GATE_DEVICES <<< "$GPU_DEVICES"
for gate_device in "${GATE_DEVICES[@]}"; do
  python3 "$PREFIX/worker/protocol_gate_v4.py" "$PREFIX/worker/nightfall-fast-worker" --device "$gate_device"
  python3 "$PREFIX/worker/bridge_stack_gate.py" --device "$gate_device"
done

GPU_AUTOTUNE_JSON="$PREFIX/run/gpu-autotune.json"; GPU_TUNE_HPS=0
if [[ -n "$CUDA_BATCH_OVERRIDE" ]]; then
  SAFE_OVERRIDE="$(python3 "$PREFIX/select_cuda_batch.py" --device "$GPU_INDEX" --upper "$CUDA_BATCH_OVERRIDE" --reserve-mib "$GPU_RESERVE_MIB")"
  CUDA_BATCH="$(python3 -c 'import json,sys; print(json.load(sys.stdin)["batch"])' <<<"$SAFE_OVERRIDE")"
  [[ "$CUDA_BATCH" == "$CUDA_BATCH_OVERRIDE" ]] || { echo "Requested CUDA batch does not fit current free VRAM" >&2; exit 1; }
elif [[ $SKIP_GPU_AUTOTUNE -eq 0 ]]; then
  echo "=== GPU performance autotune ==="
  GPU_TUNE_LOG="$PREFIX/logs/gpu-autotune.log"
  python3 "$PREFIX/gpu_autotune.py" --worker "$PREFIX/worker/nightfall-fast-worker" --service "$PREFIX/worker/nightfall_worker_service.py" --device "$GPU_INDEX" --reserve-mib "$GPU_RESERVE_MIB" --out "$GPU_AUTOTUNE_JSON" | tee "$GPU_TUNE_LOG"
  GPU_LINE="$(grep '^GPU_AUTOTUNE_JSON=' "$GPU_TUNE_LOG" | tail -1 | cut -d= -f2-)"
  [[ -n "$GPU_LINE" ]] || { echo "GPU autotune produced no result" >&2; exit 1; }
  CUDA_BATCH="$(python3 -c 'import json,sys; j=json.load(sys.stdin); print(j["selected_batch"])' <<<"$GPU_LINE")"
  GPU_TUNE_HPS="$(python3 -c 'import json,sys; j=json.load(sys.stdin); print(j["selected_hps"])' <<<"$GPU_LINE")"
else
  SAFE_JSON="$(python3 "$PREFIX/select_cuda_batch.py" --device "$GPU_INDEX" --reserve-mib "$GPU_RESERVE_MIB")"; CUDA_BATCH="$(python3 -c 'import json,sys; print(json.load(sys.stdin)["batch"])' <<<"$SAFE_JSON")"
fi

echo "GPU selected: batch=$CUDA_BATCH autotune_hps=$GPU_TUNE_HPS"

q(){ printf '%q' "$1"; }
cat >"$PREFIX/config.env.tmp" <<EOF
# Generated by Nightfall Miner $PACKAGE_VERSION on $(date -Is)
AUTO_MINER_PACKAGE_VERSION=$(q "$PACKAGE_VERSION")
NIGHTFALL_UPSTREAM_VERSION=$(q "$UPSTREAM_VERSION")
NIGHTFALL_UPSTREAM_TAG=$(q "$UPSTREAM_TAG")
NIGHTFALL_UPSTREAM_COMMIT=$(q "$TESTED_COMMIT")
NIGHTFALL_MODE=hybrid-required
NIGHTFALL_MINER_ADDRESS=$(q "$ADDRESS")
NIGHTFALL_DEV_ADDRESS=$(q "$DEV_ADDRESS")
NIGHTFALL_GPU_DEV_FEE_BPS=$GPU_DEV_FEE_BPS
NIGHTFALL_CPU_MODEL=$(q "$CPU_MODEL")
NIGHTFALL_CPU_BACKEND=argon2-rust-1.1-nozeroize
NIGHTFALL_CPU_AUTOTUNE_FILE=$(q "$CPU_AUTOTUNE_JSON")
NIGHTFALL_CPU_AUTOTUNE_HPS=$CPU_HPS
NIGHTFALL_CPU_QUOTA_CORES=$(q "${CPU_QUOTA:-}")
NF_CPU_MINING=1
NF_CPU_FAST_BACKEND=1
NF_MINING_THREADS=$CPU_THREADS
NIGHTFALL_REPO=$(q "$REPO")
NIGHTFALL_BIN=$(q "$NIGHTFALL_BIN")
NIGHTFALL_DATADIR=$(q "$DATADIR")
NIGHTFALL_NETWORK=mainnet
NIGHTFALL_EXPECTED_GENESIS=$(q "$EXPECTED_MAINNET_GENESIS")
NIGHTFALL_P2P_LISTEN=0.0.0.0:17891
NIGHTFALL_RPC_LISTEN=127.0.0.1:17881
NIGHTFALL_RPC_HOST=127.0.0.1
NIGHTFALL_RPC_PORT=17881
NIGHTFALL_PROXY=$(q "$PROXY")
NIGHTFALL_GPU_ENABLED=1
NIGHTFALL_GPU_NAME=$(q "$GPU_NAME")
NIGHTFALL_GPU_MEMORY_MIB=$GPU_MEMORY_MIB
NIGHTFALL_GPU_KERNEL=fixedschedule-v1
NIGHTFALL_GPU_AUTOTUNE_FILE=$(q "$GPU_AUTOTUNE_JSON")
NIGHTFALL_GPU_AUTOTUNE_HPS=$GPU_TUNE_HPS
NIGHTFALL_CUDA_DEVICE=$GPU_INDEX
NIGHTFALL_CUDA_DEVICES=$(q "$GPU_DEVICES")
NIGHTFALL_CUDA_ARCH=$(q "$CUDA_ARCH")
NIGHTFALL_CUDA_BATCH_PROFILE_MAX=$CUDA_BATCH
NIGHTFALL_CUDA_BATCH=$CUDA_BATCH
NIGHTFALL_CUDA_RESERVE_MIB=$GPU_RESERVE_MIB
NIGHTFALL_WORKER_SOCKET=$(q "$PREFIX/run/nightfall-fast-worker.sock")
NIGHTFALL_WORKER_REQUEST_TIMEOUT=45
NIGHTFALL_WORKER_RESPONSE_TIMEOUT_MS=60000
NIGHTFALL_GPU_STARTUP_WAIT_SECONDS=15
NIGHTFALL_GPU_STARTUP_ATTEMPTS=5
NIGHTFALL_GPU_BATCH_STEP=16
NF_LEGACY_HASHES_PER_BATCH=28
NIGHTFALL_TARGET_CYCLE_SECONDS=$TARGET_SECONDS
NIGHTFALL_WORK_ONE_BATCHES=128
NIGHTFALL_LOOP_TIMEOUT=60
NIGHTFALL_MONITOR_INTERVAL=5
NIGHTFALL_GPU_STALE_SECONDS=20
NIGHTFALL_DEFAULT_REWARD_NIGHT=6.0
NIGHTFALL_RENTAL_USD_HOUR=$RENTAL_USD_HOUR
NIGHTFALL_BOOTSTRAP_HEIGHT=0
NIGHTFALL_BOOTSTRAP_FILE=''
NIGHTFALL_BOOTSTRAP_SHA256=''
NIGHTFALL_FASTSYNC_MODE=none
NIGHTFALL_FASTSYNC_CANONICAL_WAIT=$POST_CANONICAL_WAIT
NIGHTFALL_SYNC_GUARD_INTERVAL=3
NIGHTFALL_SYNC_GUARD_MAX_GAP=2
NIGHTFALL_SYNC_GUARD_MIN_PEERS=3
NIGHTFALL_SYNC_GUARD_MAX_TIP_AGE=300
NIGHTFALL_SYNC_GUARD_BAD_POLLS=3
NIGHTFALL_SYNC_GUARD_GOOD_POLLS=5
NIGHTFALL_WEB_DASHBOARD_LISTEN=$(q "$DASHBOARD_LISTEN")
NIGHTFALL_WALLET_STATUS_FILE=''
RUN_DIR=$(q "$PREFIX/run")
LOG_DIR=$(q "$PREFIX/logs")
RUST_LOG=info
EOF
mv -f "$PREFIX/config.env.tmp" "$PREFIX/config.env"; chmod 600 "$PREFIX/config.env"

# Final selected-batch worker startup with free-VRAM fallback, then a longer
# calibration to tune the cancellable outer work range.
echo "=== Final GPU calibration ==="; SOCKET="$PREFIX/run/nightfall-fast-worker.sock"; rm -f "$SOCKET"; CAL_PID=""; WORKING_BATCH="$CUDA_BATCH"
start_cal_worker(){ local b="$1"; : >"$PREFIX/logs/install-calibration-worker.log"; python3 -u "$PREFIX/worker/nightfall_worker_service.py" --worker "$PREFIX/worker/nightfall-fast-worker" --socket "$SOCKET" --device "$GPU_INDEX" --batch "$b" --request-timeout 120 >>"$PREFIX/logs/install-calibration-worker.log" 2>&1 & CAL_PID=$!; for _ in $(seq 1 75); do NIGHTFALL_WORKER_SOCKET="$SOCKET" "$PREFIX/worker/runner_bridge.py" --ping >/dev/null 2>&1 && return 0; kill -0 "$CAL_PID" 2>/dev/null || return 1; sleep .2; done; return 1; }
CAL_ATTEMPT=0; CAL_OK=0
while (( WORKING_BATCH >= 32 && CAL_ATTEMPT < 5 )); do
  CAL_ATTEMPT=$((CAL_ATTEMPT+1))
  SAFE_NOW="$(python3 "$PREFIX/select_cuda_batch.py" --device "$GPU_INDEX" --upper "$WORKING_BATCH" --reserve-mib "$GPU_RESERVE_MIB" 2>/dev/null || true)"; [[ -n "$SAFE_NOW" ]] && WORKING_BATCH="$(python3 -c 'import json,sys; print(json.load(sys.stdin)["batch"])' <<<"$SAFE_NOW")"
  rm -f "$SOCKET"; if start_cal_worker "$WORKING_BATCH"; then CAL_OK=1; break; fi; kill -TERM "$CAL_PID" 2>/dev/null || true; wait "$CAL_PID" 2>/dev/null || true; rm -f "$SOCKET"; echo "CUDA worker startup failed at batch=$WORKING_BATCH attempt=$CAL_ATTEMPT/5; reducing by 16"; WORKING_BATCH=$((WORKING_BATCH-16)); done
(( CAL_OK == 1 )) || { tail -n 120 "$PREFIX/logs/install-calibration-worker.log" >&2; echo "No safe CUDA batch found after $CAL_ATTEMPT startup attempts" >&2; exit 1; }
sed -i "s/^NIGHTFALL_CUDA_BATCH=.*/NIGHTFALL_CUDA_BATCH=$WORKING_BATCH/" "$PREFIX/config.env"
CAL_JSON="$PREFIX/run/calibration.json"; python3 "$PREFIX/calibrate_gpu.py" --socket "$SOCKET" --target-seconds "$TARGET_SECONDS" --hashes-per-legacy-batch 28 >"$CAL_JSON"; WORK_ONE_BATCHES="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["suggested_work_one_batches"])' "$CAL_JSON")"; HPS="$(python3 -c 'import json,sys; print("%.1f"%json.load(open(sys.argv[1]))["hps"])' "$CAL_JSON")"; sed -i "s/^NIGHTFALL_WORK_ONE_BATCHES=.*/NIGHTFALL_WORK_ONE_BATCHES=$WORK_ONE_BATCHES/" "$PREFIX/config.env"; kill -TERM "$CAL_PID" 2>/dev/null || true; wait "$CAL_PID" 2>/dev/null || true; CAL_PID=""; rm -f "$SOCKET"; echo "GPU final: batch=$WORKING_BATCH ${HPS} H/s outer_batches=$WORK_ONE_BATCHES"

# Chain startup. Default path is official snapshot fastsync: the archive from the
# official Nightfall chain-bootstrap release is SHA256-verified and then bound
# to this local install-id. This deliberately changes the trust boundary: the
# historical prefix through the official anchor is not re-verified locally.
# Use --full-verify-bootstrap to retain upstream's slower full local replay.
if [[ -n "$FASTSTATE" ]]; then
  echo "=== Canonical faststate import ==="
  FAST_SHA_FILE=""
  [[ -f "${FASTSTATE}.sha256" ]] && FAST_SHA_FILE="${FASTSTATE}.sha256"
  if [[ -z "$FAST_SHA_FILE" ]]; then
    alt="${FASTSTATE%.tar}.tar.sha256"
    [[ -f "$alt" ]] && FAST_SHA_FILE="$alt"
  fi
  args=(import-faststate --datadir "$DATADIR" --snapshot "$FASTSTATE" --prefix "$PREFIX" --expected-commit "$TESTED_COMMIT")
  [[ -n "$FAST_SHA_FILE" ]] && args+=(--sha256-file "$FAST_SHA_FILE")
  python3 "$PREFIX/fastsync.py" "${args[@]}"
  FASTSYNC_MODE=canonical-faststate
  ANCHOR_HEIGHT="$(python3 - "$DATADIR/fastsync-installed.json" <<'PY'
import json,sys
print(int(json.load(open(sys.argv[1])).get('anchor_height') or 0))
PY
)"
  sed -i "s/^NIGHTFALL_FASTSYNC_MODE=.*/NIGHTFALL_FASTSYNC_MODE=canonical-faststate/; s/^NIGHTFALL_BOOTSTRAP_HEIGHT=.*/NIGHTFALL_BOOTSTRAP_HEIGHT=$ANCHOR_HEIGHT/" "$PREFIX/config.env"
elif [[ $SKIP_BOOTSTRAP -eq 0 ]]; then
  echo "=== Official Nightfall chain bootstrap ==="
  BOOT_DIR="$PREFIX/bootstrap"; mkdir -p "$BOOT_DIR"
  OFFICIAL_AUTO=0; COMP=""
  if [[ -n "$BOOTSTRAP_URL" ]]; then
    [[ "$BOOTSTRAP_SHA256" =~ ^[0-9A-Fa-f]{64}$ ]] || { echo "--bootstrap-url requires --bootstrap-sha256" >&2; exit 2; }
    BOOT_NAME="$(basename "${BOOTSTRAP_URL%%\?*}")"
    BOOT_HEIGHT="$(sed -nE 's/.*nightfall-chain-([0-9]+)-.*/\1/p' <<<"$BOOT_NAME")"
    BOOT_SHA="$BOOTSTRAP_SHA256"; BOOT_JSON_URL=""
  else
    OFFICIAL_AUTO=1
    BOOT_META="$BOOT_DIR/latest.json"
    python3 "$PREFIX/bootstrap.py" >"$BOOT_META"
    BOOT_NAME="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["name"])' "$BOOT_META")"
    BOOT_HEIGHT="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["height"])' "$BOOT_META")"
    BOOTSTRAP_URL="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["url"])' "$BOOT_META")"
    BOOT_SHA="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("sha256") or "")' "$BOOT_META")"
    BOOT_JSON_URL="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("json_url") or "")' "$BOOT_META")"
  fi
  BOOT_FILE="$BOOT_DIR/$BOOT_NAME"
  echo "latest bootstrap height=$BOOT_HEIGHT file=$BOOT_NAME"
  # A repeated install must not roll a healthy/advanced local chain backward.
  # A running node is still rejected before changing any chain state.
  LOCAL_HEIGHT="$(python3 - "$DATADIR/chain-meta.json" <<'PYLOCAL'
import json,sys
try:
    n=json.load(open(sys.argv[1])).get('block_count')
    print(n-1 if type(n) is int and n>0 else -1)
except (OSError, ValueError, TypeError, json.JSONDecodeError):
    print(-1)
PYLOCAL
)"
  if [[ "$LOCAL_HEIGHT" =~ ^[0-9]+$ ]] && (( LOCAL_HEIGHT >= BOOT_HEIGHT )); then
    echo "Existing local chain height=$LOCAL_HEIGHT >= newest official bootstrap=$BOOT_HEIGHT; preserving current chain."
    FASTSYNC_MODE=existing-chain-preserved
  else
    curl -fL --retry 5 --retry-delay 2 -C - -o "$BOOT_FILE" "$BOOTSTRAP_URL"
    if [[ -n "$BOOT_JSON_URL" ]]; then
      COMP="$BOOT_DIR/${BOOT_NAME%.bin}.json"
      curl -fL --retry 3 --retry-delay 2 -o "$COMP" "$BOOT_JSON_URL"
      COMP_SHA="$(python3 - "$COMP" <<'PY'
import json,sys
j=json.load(open(sys.argv[1])); print(j.get('blocks_bin_sha256') or j.get('sha256') or '')
PY
)"
      [[ -z "$BOOT_SHA" ]] && BOOT_SHA="$COMP_SHA"
    fi
    [[ "$BOOT_SHA" =~ ^[0-9A-Fa-f]{64}$ ]] || { echo "No authoritative SHA256 available for bootstrap" >&2; exit 1; }
    ACTUAL="$(sha256sum "$BOOT_FILE"|awk '{print $1}')"
    [[ "${ACTUAL,,}" == "${BOOT_SHA,,}" ]] || { echo "Bootstrap SHA256 mismatch expected=$BOOT_SHA actual=$ACTUAL" >&2; exit 1; }
    echo "bootstrap SHA256 OK"
    if pgrep -x nightfalld >/dev/null 2>&1; then echo "A nightfalld is running; stop it before bootstrap install" >&2; exit 1; fi

    if [[ $FASTSYNC_TRUST_OFFICIAL -eq 1 && $OFFICIAL_AUTO -eq 1 && -n "$COMP" && -f "$COMP" ]]; then
      echo "=== FASTSYNC: trust verified official release anchor ==="
      echo "Trust boundary: historical blocks through the official anchor are NOT re-verified locally."
      python3 "$PREFIX/fastsync.py" bind-official \
        --datadir "$DATADIR" \
        --archive "$BOOT_FILE" \
        --companion "$COMP" \
        --expected-sha "$BOOT_SHA" \
        --expected-height "$BOOT_HEIGHT" \
        --prefix "$PREFIX"
      FASTSYNC_MODE=official-release-sha-trust
    else
      [[ $FASTSYNC_TRUST_OFFICIAL -eq 1 ]] && echo "Official trusted fastsync unavailable for this override; using full local verification."
      STAMP="$(date -u +%Y%m%d-%H%M%S)"; BK="$DATADIR/pre-bootstrap-$STAMP"; mkdir -p "$BK"
      for f in blocks.bin blocks.jsonl chain-meta.json headers.jsonl utxo-horizon.json install-id fastsync-installed.json; do [[ -e "$DATADIR/$f" ]] && mv "$DATADIR/$f" "$BK/$f"; done
      restore_chain_backup(){ rm -f "$DATADIR/blocks.bin.new" "$DATADIR/blocks.bin"; for f in blocks.bin blocks.jsonl chain-meta.json headers.jsonl utxo-horizon.json install-id fastsync-installed.json; do [[ -e "$BK/$f" ]] && mv "$BK/$f" "$DATADIR/$f"; done; }
      if ! cp "$BOOT_FILE" "$DATADIR/blocks.bin.new"; then echo "Bootstrap copy failed; restoring previous chain state" >&2; restore_chain_backup; exit 1; fi
      COPY_SHA="$(sha256sum "$DATADIR/blocks.bin.new"|awk '{print $1}')"
      if [[ "${COPY_SHA,,}" != "${BOOT_SHA,,}" ]]; then echo "Bootstrap copy verification failed; restoring previous chain state" >&2; restore_chain_backup; exit 1; fi
      mv "$DATADIR/blocks.bin.new" "$DATADIR/blocks.bin"
      cat > "$DATADIR/official-bootstrap-installed.json" <<EOF
{"height":$BOOT_HEIGHT,"file":"$BOOT_NAME","sha256":"$BOOT_SHA","installed_at":"$(date -Is)","fastsync":false}
EOF
      python3 "$PREFIX/fastsync.py" session-reset --prefix "$PREFIX" >/dev/null || true
      FASTSYNC_MODE=full-local-verification
    fi
    sed -i "s/^NIGHTFALL_FASTSYNC_MODE=.*/NIGHTFALL_FASTSYNC_MODE=$FASTSYNC_MODE/; s/^NIGHTFALL_BOOTSTRAP_HEIGHT=.*/NIGHTFALL_BOOTSTRAP_HEIGHT=$BOOT_HEIGHT/; s|^NIGHTFALL_BOOTSTRAP_FILE=.*|NIGHTFALL_BOOTSTRAP_FILE=$(q "$BOOT_NAME")|; s/^NIGHTFALL_BOOTSTRAP_SHA256=.*/NIGHTFALL_BOOTSTRAP_SHA256=$BOOT_SHA/" "$PREFIX/config.env"
    echo "chain bootstrap installed -> $DATADIR/blocks.bin (anchor $BOOT_HEIGHT, mode $FASTSYNC_MODE)"
  fi

else
  if [[ ! -e "$DATADIR/blocks.bin" && ! -e "$DATADIR/blocks.jsonl" ]]; then "$NIGHTFALL_BIN" --network mainnet --datadir "$DATADIR" init >/dev/null; fi
fi

echo "=== Installed package self-test ==="; "$PREFIX/selftest.sh" --installed "$PREFIX"
mkdir -p "$COMMAND_DIR"
for name in mine minerctl nightfall-dashboard; do ln -sfn "$PREFIX/$name" "$COMMAND_DIR/$name"; done
echo "Commands installed in $COMMAND_DIR. If needed: export PATH=\"$COMMAND_DIR:\$PATH\""

cat <<EOF
Installation complete
---------------------
Install dir: $PREFIX
Datadir:     $DATADIR
USER payout: $ADDRESS
DEV payout:  ${DEV_ADDRESS:-not-configured}
CPU:         argon2-rust no-zeroize, threads=$CPU_THREADS, autotune=${CPU_HPS} H/s
GPU:         fixedschedule-v1, $GPU_NAME, batch=$WORKING_BATCH, final=${HPS} H/s
FastSync:    $FASTSYNC_MODE
Quick dashboard & miner launch:
  mine
  nightfall-dashboard
  $PREFIX/mine
Optional browser dashboard (not started automatically):
  $PREFIX/minerctl web-start
  browser listen: $DASHBOARD_LISTEN
Control:
  $PREFIX/minerctl start
  $PREFIX/minerctl status
  $PREFIX/minerctl blocks 20
  $PREFIX/minerctl canonical-check 180 3
  $PREFIX/minerctl fastsync-info
  $PREFIX/minerctl doctor
EOF
if [[ $NO_START -eq 0 ]]; then
  echo "=== Start Nightfall Miner 1.3.5 reliability canonical-safe supervisor ==="
  "$PREFIX/minerctl" start
  echo "If live peers are not canonical yet, 1.3 remains in SYNCING_SAFE_WAIT and promotes mining automatically."
fi
echo NIGHTFALL_MINER_INSTALL_PASS
