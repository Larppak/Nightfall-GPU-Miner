# GPU Mining Concept — Nighthash-v2 on NVIDIA GPUs

**Why GPU mining is possible, and a starting point for anyone curious about building their own miner.**

NIGHTFALLCOIN's Nighthash-v2 uses the memory-hard **Argon2id** algorithm. Being memory-hard makes hashing expensive in RAM, but it does **not** mean that only CPUs can mine. GPUs can run many *independent nonce candidates* concurrently, provided each candidate has its own working memory.

This is an **educational explanation and original pseudocode**, not the source code of the released Nightfall GPU Miner, a working miner, or a security audit of its binaries.

## 1. What the official algorithm requires

Nightfall Core v1.0.5 defines these **mainnet** proof-of-work parameters:

| Parameter | Mainnet value |
| --- | --- |
| Algorithm | Argon2id, version 0x13 |
| Working memory per hash | **32,768 KiB = 32 MiB** |
| Iterations | 1 |
| Argon2 lanes | 1 |
| Output | 32 bytes (256 bits) |
| Nonce | 64-bit integer encoded little-endian |

In simplified form, the official hashing flow is:

```text
header_preimage = the exact consensus-defined header bytes
salt            = first 16 bytes of the official
                  Blake3-based Nighthash-v2 salt derivation
password        = header_preimage || nonce_as_le_u64

digest = Argon2id(
    password, salt,
    memory = 32768 KiB, iterations = 1, lanes = 1,
    output = 32 bytes
)

if digest satisfies network difficulty:
    submit the nonce as a candidate block solution
```

**Important:** This description omits the actual header serialization and exact salt-generation implementation. Those, and the difficulty comparison, **must match Nightfall Core byte-for-byte**. Follow the [official PoW implementation](https://github.com/Instinctes/nightfall/blob/v1.0.5/crates/nightfall-crypto/src/pow.rs) and [mainnet parameters](https://github.com/Instinctes/nightfall/blob/v1.0.5/crates/nightfall-types/src/lib.rs) as the reference, rather than treating this sketch as a consensus specification.

## 2. Where a GPU helps

Each nonce is an independent hash attempt. That makes it possible to evaluate multiple candidates in parallel on a GPU. Their Argon2id memory workspaces must remain separate.

| Concurrent candidates | Argon2id working memory |
| ---: | ---: |
| 1 | 32 MiB |
| 8 | 256 MiB |
| 32 | **1 GiB** |
| 128 | 4 GiB |

These are **minimum working-memory totals**, not total GPU VRAM requirements. Additional memory is needed for program state, driver allocations, outputs, and other buffers.

Memory bandwidth matters, but so do latency, Argon2id's data dependencies, memory capacity, and the efficiency of the implementation. More concurrent hashes do **not** automatically produce proportionally more hashrate.

## 3. A tiny CUDA-style example

The following is **pseudocode**, deliberately not a complete CUDA kernel. It shows the *work distribution*, not the internal Argon2id algorithm or optimizations.

```cpp
// CUDA-like pseudocode — not directly compilable
// One cooperating GPU thread block handles one nonce candidate.

candidate = blockIdx.x;
nonce = first_nonce + candidate;

// Each candidate gets its own 32 MiB region in GPU global memory.
workspace = scratch_base + candidate * (32 * MiB);

digest = consensus_correct_argon2id_gpu(
    password = header_preimage || little_endian_u64(nonce),
    salt = official_nighthash_v2_salt(header_preimage),
    workspace = workspace,
    memory_kib = 32768,
    iterations = 1,
    lanes = 1,
    output_bytes = 32
);

if (digest_meets_official_difficulty(digest, difficulty)) {
    report_candidate(nonce);
}
```

The real challenge is implementing **correct Argon2id on the GPU**, coordinating threads without breaking its memory dependencies, and obtaining valid block templates from a synchronized Nightfall node. A GPU implementation still has to produce *exactly the same 32-byte output* as the official CPU verifier for every test vector.

## 4. If you want to build your own

A practical learning path is to:

1. Start with the [official Nightfall Core PoW implementation](https://github.com/Instinctes/nightfall/blob/v1.0.5/crates/nightfall-crypto/src/pow.rs). Understand its salt, password, nonce encoding, parameters and difficulty check.
2. Implement a basic, **correct** Argon2id GPU candidate first; optimize only after testing results against the official CPU code.
3. Add separate GPU workspaces for multiple nonces and experiment with modest candidate batches that fit in VRAM.
4. Connect your miner to valid node work templates; cancel stale work when the chain tip changes. Always let the node perform normal consensus verification.

You can also study the [Argon2 specification (RFC 9106)](https://www.rfc-editor.org/rfc/rfc9106) and open-source GPU Argon2 implementations as learning resources, while respecting their respective licenses.

**A memory-hard PoW is not a hardware ban.** Any device producing a valid proof can mine; the economics depend on efficiency, power consumption, and network difficulty.

## About the released Nightfall GPU Miner

[My GPU miner](https://github.com/Larppak/Nightfall-GPU-Miner) uses precompiled NVIDIA GPU workers and a native controller. This conceptual example **does not reveal or reproduce its optimized implementation**, and it **does not establish that the distributed binaries are safe**. The released first-party software is MIT-licensed, with third-party terms retained; the distribution does not include the optimized CUDA kernel source.

If you try an unfamiliar miner, use a dedicated machine, provide **only your public `nf1...` payout address**, and import FastState snapshots only from a source you trust.
