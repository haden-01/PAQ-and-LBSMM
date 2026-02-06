# PAQ-and-LBSMM
This repository open-sources the PAQ algorithm and LBSMM multiplier for efficient CNN acceleration with 4-bit quantization and N:M structured sparsity. It enables high compression and FPGA-friendly deployment by combining pruning-after-quantization with a lightweight LUT-based multiplier for compact, high-throughput accelerators.

# Efficient 4-bit CNN Acceleration via PAQ and LBSMM

This repository contains the core implementation of the paper: **"Efficient FPGA Acceleration for 4-bit CNNs via Quantization-Induced Structured Sparsity and LUT-based Multiplication"**. 

Our work introduces a unified algorithm-hardware co-design that leverages the natural sparsity emerging from 4-bit quantization to achieve high-performance CNN inference on FPGAs.



## Overview

Modern CNN accelerators face challenges in balancing compression ratios with hardware efficiency. This project addresses these by:
1. **PAQ Algorithm**: A "Pruning-After-Quantization" strategy that transforms unstructured quantization-induced zeros into strict N:M structured sparsity.
2. **LBSMM Architecture**: A hardware-efficient, LUT-based multiplier designed for 4-bit sign-magnitude arithmetic, only consuming 11 LUTs.

## Key Features

- **N:M Structured Pruning**: Enforces 4:8 (or other N:M) patterns with minimal accuracy recovery, ensuring 100% hardware utilization.
- **Sign-Magnitude Arithmetic**: Optimized hardware logic for low-bit multiplication using FPGA's native Look-Up Tables.

## Repository Structure

| File | Description |
| :--- | :--- |
| `PAQ.py` | PyTorch implementation of the Pruning-After-Quantization algorithm. |
| `LBSMM.v` | Verilog RTL for the 4-bit LUT-based Sign-Magnitude Multiplier. |
| `tb_LBSMM.v` | Comprehensive testbench for validating the LBSMM hardware logic. |

---

## Technical Details

### 1. PAQ Algorithm (`PAQ.py`)
The algorithm utilizes a DoReFa-like quantization scheme. It analyzes the distribution of weights after 4-bit quantization and enforces an N:M constraint (default is 4:8).
- **Process**: Tanh-based normalization -> Symmetric Quantization -> Zero-count check per group -> Minimal-weight pruning for N:M compliance.
- **Requirement**: PyTorch 1.7+

### 2. LBSMM Hardware (`LBSMM.v`)
Instead of using power-hungry DSP slices for low-bit multiplication, we implement the multiplication logic via a optimized 3-bit magnitude LUT.
- **Encoding**: 4-bit Sign-Magnitude format (`[3]: Sign, [2:0]: Magnitude`).
- **Optimization**: The magnitude product is pre-computed in a combinatorial LUT, while the sign bit is handled by a simple XOR gate.



## Getting Started

### Algorithm Simulation
To verify the sparsity induction and N:M pruning:
```bash
python PAQ.py
