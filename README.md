# 🔷 Synchronous FIFO Design & Verification (SystemVerilog)

## 📌 Overview
This project implements and verifies a **Synchronous FIFO (First-In First-Out)** using **SystemVerilog (without UVM)**.

The objective is to design a reliable FIFO and validate its behavior through a structured testbench including assertions and checking mechanisms.

---

## 🧠 FIFO Concept
FIFO operates on the principle:
> **First In → First Out**

The first data written into the FIFO is the first to be read out.

---

## 🏗️ Design Features

- Parameterized FIFO:
  - `FIFO_WIDTH = 16`
  - `FIFO_DEPTH = 8`

- Internal Architecture:
  - Memory array
  - Write pointer (`wr_ptr`)
  - Read pointer (`rd_ptr`)
  - Counter (`count`)

- Output Signals:
  - `data_out`
  - `wr_ack`
  - `overflow`
  - `underflow`

- Status Flags:
  - `full`
  - `empty`
  - `almostfull`
  - `almostempty`

---

## 🧪 Verification Approach

The verification is done using a **SystemVerilog testbench** (no UVM), which includes:

- Directed and randomized stimulus
- Assertions (SVA)
- Reference model (Golden Model)
- Functional checking

---

## 🧾 Testbench Components

- **Stimulus Generator**
  - Generates write, read, and mixed operations

- **Driver Logic**
  - Drives signals to the DUT

- **Monitor**
  - Observes DUT outputs

- **Scoreboard**
  - Compares DUT outputs with expected values

- **Assertions**
  - Check correctness of protocol and signals

---

## 🔄 Test Scenarios

The following cases were verified:

- Reset behavior  
- Write only operations  
- Read only operations  
- Simultaneous read & write  
- FIFO full condition  
- FIFO empty condition  
- Overflow scenario  
- Underflow scenario  

---

## ✅ Assertions (SVA)

Assertions were used to verify:

- Reset clears outputs  
- Write acknowledge correctness  
- Overflow condition  
- Underflow condition  
- Valid data output  
- Flag correctness (full / empty / almost)

---

## 📊 Results Summary

- ✔ Correct functionality verified  
- ✔ FIFO ordering maintained  
- ✔ No data corruption  
- ✔ Assertions passed  

---

## 📷 Waveform Analysis

Waveforms confirm correct FIFO behavior:

- Write phase: data stored correctly  
- Read phase: data retrieved in correct order  
- Simultaneous operations handled correctly  

FIFO correctness verified by:
data_in → data_out (same order)
