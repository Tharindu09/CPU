# CPU

This repository contains the source code for a 32-bit single-cycle CPU designed and implemented using Icarus Verilog HDL. The project includes the CPU's datapath, control unit, an assembler written in C, and a testbench for simulation.

## Architecture & Components

The CPU follows a MIPS-like architecture with a 32-bit instruction width and a 32-bit program counter, but it operates on 8-bit data for ALU and register file operations.

Key components are modularized into separate Verilog files:

*   **`cpu.v`**: The top-level module that integrates all other components into a functioning CPU datapath.
*   **`control_unit.v`**: Decodes the instruction's opcode to generate the necessary control signals for the datapath, such as `WRITE_ENABLE`, `ALUOP`, `OP2_SEL`, `JUMP`, and `BRANCH`.
*   **`alu.v`**: The 8-bit Arithmetic Logic Unit. It performs addition, bitwise AND/OR, forwarding (for `mov`/`loadi`), multiplication, and shift operations.
*   **`reg.v`**: An 8-bit register file containing 8 registers. It supports two asynchronous reads and one synchronous, clock-triggered write.
*   **`mult.v`**: An 8x8 signed multiplier implemented using an array of full adders.
*   **`shift.v`**: A barrel shifter that performs logical left shifts (`sll`), logical right shifts (`srl`), arithmetic right shifts (`sra`), and right rotations (`ror`).
*   **`addition_modules.v`**: A collection of utility modules, including PC adders, multiplexers, a 2's complement unit, and branch control logic.

## Instruction Set Architecture (ISA)

The CPU implements a custom instruction set. Instructions are 32 bits wide, and the format is as follows:

*   **Bits 31-24**: Opcode
*   **Bits 23-16**: Immediate value / Branch offset
*   **Bits 18-16**: Destination Register (RD)
*   **Bits 10-8**: Source Register 1 (RT)
*   **Bits 2-0**: Source Register 2 (RS)

### Supported Instructions
| Mnemonic | Opcode       | Description                                  |
|----------|--------------|----------------------------------------------|
| `loadi`  | `00000000`   | Load an 8-bit immediate value into a register. |
| `mov`    | `00000001`   | Move value from one register to another.       |
| `add`    | `00000010`   | Add two registers and store the result.        |
| `sub`    | `00000011`   | Subtract one register from another.            |
| `and`    | `00000100`   | Bitwise AND of two registers.                  |
| `or`     | `00000101`   | Bitwise OR of two registers.                   |
| `j`      | `00000110`   | Unconditional jump (address from immediate).   |
| `beq`    | `00000111`   | Branch if equal.                               |
| `bne`    | `00001000`   | Branch if not equal.                           |
| `mult`   | `00001001`   | Multiply two 8-bit signed registers.           |
| `sll`    | `00001010`   | Logical shift left by an immediate amount.     |
| `srl`    | `00001011`   | Logical shift right by an immediate amount.    |
| `sra`    | `00001100`   | Arithmetic shift right by an immediate amount. |
| `ror`    | `00001101`   | Rotate right by an immediate amount.           |

## Assembler

The repository includes a simple assembler, `CO224Assembler.c`, to convert assembly language programs into 32-bit machine code.

### Compilation
To compile the assembler, use GCC:
```sh
gcc CO224Assembler.c -o CO224Assembler
```

### Usage
Run the compiled assembler with your assembly file as an argument. An example program is provided in `sample_program.s`.

```sh
./CO224Assembler sample_program.s
```

This will generate a `sample_program.s.machine` file containing the binary instructions. This output file should be renamed to `instr_mem.mem` to be used in the simulation.

## Simulation

The project can be simulated using Icarus Verilog. The testbench (`cpu_tb.v`) loads machine code from `instr_mem.mem`, runs the CPU for a set number of clock cycles, and generates a waveform file `cpu-wavedata.vcd` for debugging.

### Running the Simulation
1.  **Compile the Verilog files:**
    ```sh
    iverilog -o cpu_tb.vvp cpu_tb.v
    ```
2.  **Run the compiled testbench:**
    ```sh
    vvp cpu_tb.vvp
    ```
3.  **View the waveform:**
    You can analyze the resulting `cpu-wavedata.vcd` file using a waveform viewer like GTKWave.
    ```sh
    gtkwave cpu-wavedata.vcd
