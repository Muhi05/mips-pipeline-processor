# 5-Stage Pipelined MIPS Processor

## Description
A classic 5-stage pipelined MIPS processor with hazard detection
and forwarding logic, implemented in Verilog HDL for computer
architecture study and SoC design learning.

## Project Info
- **Difficulty:** Advanced
- **Tech Used:** Verilog HDL
- **Tool:** JDoodle Online Verilog Compiler
- **Estimated Time:** 18–25 days

## Pipeline Architecture
| Stage | Full Name | What It Does |
|-------|-----------|-------------|
| IF | Instruction Fetch | Gets instruction from memory |
| ID | Instruction Decode | Reads registers, decodes opcode |
| EX | Execute | ALU performs operation |
| MEM | Memory Access | Load/Store data memory |
| WB | Write Back | Writes result to register |

## Modules
| File | Description |
|------|-------------|
| `program_counter.v` | PC register with stall support |
| `instr_memory.v` | Instruction ROM (64 words) |
| `reg_file.v` | 32 general-purpose registers |
| `alu_control.v` | Funct-field based ALU decoder |
| `alu.v` | ADD / SUB / AND / OR / SLT |
| `control_unit.v` | Opcode decoder (R-type, LW, SW, BEQ) |
| `data_memory.v` | Data RAM (64 words) |
| `pipeline_registers.v` | IF/ID, ID/EX, EX/MEM, MEM/WB |
| `hazard_forwarding.v` | Hazard detection + forwarding unit |
| `mips_pipeline.v` | Top-level integration module |
| `tb_mips_pipeline.v` | Simulation testbench |

## Key Features
- Full 5-stage pipeline with pipeline registers
- **Hazard Detection Unit** — detects load-use hazards, inserts stalls
- **Forwarding Unit** — EX-EX and MEM-EX data forwarding paths
- **ALU Control** — decodes funct field for R-type instructions
- Supports: R-type (ADD, SUB, AND, OR, SLT), LW, SW, BEQ

## Test Program
```verilog
// Pre-loaded: R2 = 10, R3 = 5
ADD R1, R2, R3  // R1 = 10 + 5  = 15
ADD R4, R1, R2  // R4 = 15 + 10 = 25  ← needs forwarding
SUB R5, R4, R3  // R5 = 25 - 5  = 20  ← needs forwarding
```

## Simulation Results
| Register | Expected | Result |
|----------|----------|--------|
| R1 | 15 | ✅ PASS |
| R4 | 25 | ✅ PASS (forwarding) |
| R5 | 20 | ✅ PASS (forwarding) |

## Learning Outcomes
- Pipeline execution understanding
- Hazard handling (stall + forwarding)
- CPU datapath analysis
- FSM-based RTL design in Verilog
