# Historical Nightfall GPU Miner Benchmarks

> **Historical data only:** These measurements were collected in earlier
> Nightfall Miner / RC3 development sessions. They do not certify the latest
> Beta 5 p2 release or imply a guaranteed hashrate, stable power consumption
> or finalized NIGHT rewards. GPU memory, tuning, thermal limits and network
> conditions materially affect results.

[Current Beta 5 p2 release](https://github.com/Larppak/Nightfall-GPU-Miner/releases/tag/v1.3.8-rc3-beta.5-p2) ·
[Main project README](https://github.com/Larppak/Nightfall-GPU-Miner#readme)

## Earlier development and RC3 measurements

**Historical development measurements, not RC3 release benchmarks.** The results below come from earlier v1.3.8 development/mainnet testing. Only the separate **RC3 paired worker tests** table provides measured RC3 binary results. Speeds depend on GPU model, power limits, clock settings, drivers and network conditions.

### Multi-GPU

| Configuration | Reported hashrate | Reported GPU power |
| --- | ---: | ---: |
| Dual RTX A4000 (2 × 16 GB) | **8.90 kH/s** | 280 W combined |
| Dual GTX 1660 SUPER (2 × 6 GB) | **8.05 kH/s** | 245 W combined |

### Single NVIDIA GPUs

| GPU | Reported hashrate | Notes |
| --- | ---: | --- |
| RTX 4070 Ti SUPER 16 GB | **9.08 kH/s** | 92 W instantaneous power reading; not a sustained power average |
| RTX 5060 Ti 16 GB | **5.92 kH/s** | Blackwell (`sm_120`) |
| Quadro RTX 5000 16 GB | **5.42 kH/s** | Turing (`sm_75`) |
| GeForce RTX 2070 8 GB | **5.34 kH/s** | Turing (`sm_75`) |
| GeForce GTX 1080 Ti 11 GB | **5.28 kH/s** | Pascal (`sm_61`) |
| GeForce RTX 3070 8 GB | **4.66 kH/s** | Ampere (`sm_86`) |
| TITAN Xp 12 GB | **2.81–5.50 kH/s** | Varies substantially with power limit |

### RC3 paired worker tests

The following were measured on the same GPU in paired offline worker tests. They do **not** measure full-window live effective hashrate.

| GPU | Architecture | RC3 GPU rate | Change vs RC2 |
| --- | --- | ---: | ---: |
| GTX 1070 | sm_61 | 2.60 kH/s | −0.15% |
| RTX 2080 Ti* | sm_75 | 4.61 kH/s | +0.56% |
| RTX 3070 | sm_86 | 4.68 kH/s | +0.004% |
| Quadro RTX 5000 | sm_75 | 5.40 kH/s | +0.003% |
| RTX 4060 Ti 16 GB | sm_89 | 4.17 kH/s | −0.008% |

*The RTX 2080 Ti rental reported 22 GiB VRAM; the test should not be generalized to a stock 11 GiB model. The Quadro and RTX 4060 Ti numbers used their autotuned batches, unlike the batch-128 results above.*

In short RC3 mainnet tests, Quadro RTX 5000 and RTX 4060 Ti had **52 locally accepted GPU submissions** and no locally rejected submissions. An **RTX 5070 (Blackwell, sm_120)** separately passed an installation and synchronization smoke test, **not sustained GPU mining or a hashrate benchmark**. These results do not establish finalized rewards, long-term reliability or real mixed-GPU coverage. The Quadro/4060 Ti sessions used the developer address; ordinary-user 4.5% fee accrual was not live-tested in those sessions.

[Beta 2 compatibility and test limits](BETA2_COMPATIBILITY.md). [Historical Beta 1 GPU test details](COMPATIBILITY.md).

### CPU Mining

| CPU | Reported hashrate |
| --- | ---: |
| AMD EPYC 7D12 | 520–674 H/s |
| Intel Xeon E5 series | 115–635 H/s, depending on model/configuration |
| AMD EPYC 7272 | 358 H/s |
| Intel Core i7 (8th generation) | 258 H/s |

**Measured and estimated data must not be mixed.** Future architecture projections have intentionally been left out of this table.


## Beta 5 field observation (separately reported)

The earlier Beta 5 was observed running a GTX 1660 Ti at **3.41 kH/s
GPU raw** and **3.31 kH/s GPU effective** with a healthy GPU fee ledger
and canonical chain consensus. These are user-observed, time-specific
measurements, not a p2 hardware validation or expected performance for
all GTX 1660 Ti cards.

**AMD HIP workers in Beta 5 p2 remain physically untested by the
publisher and are not benchmarked here.**
