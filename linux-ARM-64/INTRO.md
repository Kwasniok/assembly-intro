# Linux ARM-64 Assembly

This document uses [GNU assembler][gas] and its [syntax][gas-syntax].

## Instruction
Consists of an operator code denoting the instruction and operands.
```
<operation code> [<operand> [, <operand> ...]]
```

Typically the the destination operand comes first.

### Examples
Move `42` to register `x0`.
```
mov x0, 42
```

Add `42` to register `x7` and store the result in register `r0`.
```
add x0, x7, #42
```

## Regsiter Operands

### General Purpose Registers
There are 31 64-bit general purpose registers.

| name | conventional purpose |
|------|----------------------|
|X0-X28| general usage        |
|X29   | frame pointer        |
|X30   | procedure link register |

#### Subregisters
All `X*` registers are 64 bit. Subregisters of width 32 bit can be addressed via
`W*` (formally `R*` in 32 bit mode):
```
|<-------------------------------X0------------------------------>|
|                                |<--------------W0-------------->|
+--------------------------------+--------------------------------+
|                                |                                |
+--------------------------------+--------------------------------+
63                                                               0
```
note: All write instructions clear the upper part of a register if unused
(zero extension).

### Special Registers
| name | conventional purpose |
|------|----------------------|
|PC    | program counter      |
|SP    | stack pointer        |
|XZR   | zero register        |

note: The zero register ignores all reads and holds the constant zero.
note: For each instruction, either `SP` or `XZR` is accessible since they
internally share the same register code `31`. THis explains also the absence of
a general purpose register ~`X31`~.

### Saved Program Status Register (SPSR)
Contains the program state flags.

| bit | name | purpose         |
|-----|------|-----------------|
|  31 | N    | negative result |
|  30 | Z    | zero result     |
|  29 | C    | carry           |
|  28 | V    | overflow        |
|  ...|||
|  21 | SS   | software step   |
|  20 | IL   | illegal execution|
| ... |||

### Floating-Point & Vector Registers
There are 32 128-bit floating-point registers or 64-bit `NEON` registers (SIMD).

| name | width   | float | SIMD |
|------|---------|-------|------|
|V0-V31| 128-bit | ✓     |      |
|Q0-Q31| 128-bit |       | ✓    |
|D0-D31|  64-bit | ✓     | ✓    |
|S0-S31|  32-bit | ✓     | ✓    |
|H0-H31|  16-bit | ✓     | ✓    |
|B0-B31|   8-bit |       | ✓    |

#### Register Layout
Single registers which are smaller, are embedded in larger ones in the lower
part:
```
 |<-------------------------------V0---------------------------------->|
 |<-------------------------------Q0---------------------------------->|
 |                                |<---------------D0----------------->|
 |                                |                |<--------S0------->|
 |                                |                |         |<---H0-->|
 |                                |                |         |    |<B0>|
 +--------------------------------+----------------+---------+----+----+
 |                                |                |         |    |    |
 +--------------------------------+----------------+---------+----+----+
127                               63               31        15    7  0
```

Vector registers which hold multiple smaller values, cover either 128-bit or 64-bit in total.

```
 |<------------------D0----------------->|<------------------D0----------------->| V0.2D
 |<--------S0------->|<--------S0------->|<--------S0------->|<--------S0------->| V0.4S
 |<---H0-->|<---H0-->|<---H0-->|<---H0-->|<---H0-->|<---H0-->|<---H0-->|<---H0-->| V0.8H
 |<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>| V0.16B
 +-------------------------------------------------------------------------------+
127                                                                             0
```

```
 |                                       |<------------------D0----------------->| V0.1D
 |                                       |<--------S0------->|<--------S0------->| V0.2S
 |                                       |<---H0-->|<---H0-->|<---H0-->|<---H0-->| V0.4H
 |                                       |<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>|<B0>| V0.8B
 +-------------------------------------------------------------------------------+
127                                      63                                     0
```

## Endianness
ARM is in general bi-endian but defaults to little endian.

## Instructions

## No Operation
| mnemonic | semantics | example    |
|----------|-----------|------------|
| NOP      | do nothing| `nop`      |

### Data Management Operations
| mnemonic | semantics | example    |
|----------|-----------|------------|
| MOV      | move      | `mov x0, x2`,`mov x0, #42` |
| LDR      | load from memory | `ldr x0, 0x4000c8`, `ldr x0, =0xFF`|
| MRS      | **R**ead **S**ystem register | `msr x0, nzcv` |
| MSR      | write system register | `mrs nzcv, x0` |
| ADR      | load address of label | `adr x0, buffer` |

note: `MOV` can also load a small immediate via the `#` prefix.
note: `LDR` can also load an immediate via the `=` prefix. The
      assembler stores the value in the memory nearby and it will
      be loaded via a proper `LDA` instruction. Instructions with
      immediates may be automatically converted to `MOV`
      instructions for efficiency.

### Arithmetic Operations
| mnemonic | semantics | sets flags | uses carry | example |
|----------|-----------|------------|------------|---------|
| ADD      | addition  |   |   | `add x0, x0, x1` |
| ADC      | addition  |   | ✓ | `adc x0, x0, x1` |
| ADDS     | addition  | ✓ |   | `adds x0, x0, x1` |
| ADCS     | addition  | ✓ | ✓ | `adcs x0, x0, x1` |
| SUB      | subtraction|   |   | `sub x0, x0, x1` |
| SBC      | subtraction|   | ✓ | `sbc x0, x0, x1` |
| SUBS     | subtraction| ✓ |   | `subs x0, x0, x1` |
| SBCS     | subtraction| ✓ | ✓ | `sbcs x0, x0, x1` |

### Logic Operations
| mnemonic | semantics | sets flags | uses carry | example |
|----------|-----------|------------|------------|---------|
| AND      | bitwise and|   |   | `and x0, x0, x1` |
| ANDS     | bitwise and| ✓ |   | `ands x0, x0, x1` |
| BIC      | bit clear (bitwise and with complement) |   |   | `bic x0, x0, x1` |
| BICS     | bit clear (bitwise and with complement) | ✓ |   | `bics x0, x0, x1` |
| ORR      | bitwise or|   |   | `orr x0, x0, x1` |
| ORN      | bitwise negated or|   |   | `orn x0, x0, x1` |
| EOR      | bitwise exclusive or|   |   | `eor x0, x0, x1` |
| EON      | bitwise negated exclusive or|   |   | `eon x0, x0, x1` |

### Comparison Operations
| mnemonic | semantics | sets flags | uses carry | example |
|----------|-----------|------------|------------|---------|
| CMP      | SUBS with result discarded | ✓ |   | `cmp x0, x1` |
| CMN      | ADDS with result discarded | ✓ |   | `cmp x0, x1` |
| TST      | ANDS with result discarded | ✓ |   | `sts x0, x1` |

## Branch/Call Operations

| mnemonic | semantics | example    |
|----------|-----------|------------|
| B        | unconditional branch (jump)| `b loop` |
| BL       | unconditional branch with link (call) | `bl printf` |
| RET      | set program counter (return) | `ret x30`

note: `BL` puts address of next instruction into `X30`.

## Pseudo-Instructions
| syntax | semantics | example |
|--------|-----------|---------|
|.global | define a global | `.global _start`, `.global main` |
|.text   | begin text section (code) | `.text` |
|.data   | begin initialized data section | `.data` |
|.bss    | begin uninitialized data section | `.bss` |
|.ascii  | store ASCII string | `.ascii "ABC"` |
|.asciz  | store null terminated ASCII string | `.asciz "ABC" ` |
|.equ    | define a symbolic constant | `.equ SUCCESS, 0` |


## Linux ARM64 Calling Convention
This is a shortened description of the Linux ARM64 calling convention based on the recommended [ARM64 calling convention][procedure call standard for ARM64].

### Function Calls
The convention for function calls in Linux is:
- Stack must be aligned to 16 byte right before the function is called via `bl`.
- Arguments are stored from left to right in the registers `X0`-`X7` resp. `V0`-`V7` and the remaining arguments are pushed on the stack right to left. (Data which must have an address - e.g. class instances in C++ - are always pushed onto the stack.)
- `X0` and `X1` or `V0` and `V1` hold(s) the return value
- The callee may advance the stack temporarily to allocate space for local variables.
- The frame pointer is stored in `X29`.
- The link register is `X30` (return address).

| registers | purpose | caller-saved | callee-saved |
|-----------|---------|--------------|--------------|
| `X30`     | link register | ✓ |   |
| `X29`     | frame pointer | ✓ |   |
| `X19`-`X28` | callee-saved register |   | ✓ |
| `X18`     | platform or temporary register | ✓ |   |
| `X17` and `X16` | intra-procedure call registers | ✓ |   |
| `X9`-`X15`| temporary registers | ✓ |   |
| `X8`      | indirect result location register | ✓ |   |
| `X0`-`X7` | parameter and result registers | ✓ |   |

### Linux Syscalls
The convention for syscalls in Linux is:
- `w8` contains the system call number.
- `x0` to `x5` contain the arguments
- `x0` and `x1` hold the return values

(See `man 2 syscall`.)

**note: The numbers differ from the 32bit conventions.**

| nr  | description | x0      | x1      | x2      | x3      |
|-----|-------------|---------|---------|---------|---------|
|  93 | exit        | exit code | -     | -       | -       |
|  63 | read        | file descriptor | buffer  | size    | -       |
|  64 | write       | file descriptor | buffer  | size    | -       |

## Example Code
Hello World in GNU assembler.
```as
// Syscall write.

.global _start

.text
_start:
    mov     x0, #1      // file descriptor: stdout
    adr     x1, message // buffer
    mov     x2, #15     // count
    mov     w8, #64     // syscall code
    svc     #0          // syscall
_exit:
    mov     x0, #0      // exit code
    mov     w8, #93     // exit
    svc     #0          // syscall

.data
message:
    .asciz  "Hello there!\n"
```

## Compile and Run
### Pure Assembly
```bash
as -o $filename.o -g $filename.s
ld -o $filename -g $filename.o
./$filename
```
note: Use `-g` for debug symbols (or `-ggdb` for ideal symbols
      for `gdb`).

### Assembly with Embedded `libc` Calls
```bash
as -o $filename.o -g $filename.s
gcc -o $filename -g $filename.o
./$filename
```
note: Use `-g` for debug symbols (or `-ggdb` for ideal symbols
      for `gdb`).

## Read ELF
Read ELF headers of executable (or object file).
```bash
readelf -h $filename
```

## Disassemble
Disassemble executable (or object file).
```bash
objdump -xds $filename
```

## References
- [gas]
- [gas-syntax]
- [Cortex-A series programmers guide]
- [guide to ARM64]
- [ARM64 instruction reference]
- [KEIL arm32 instruction reference]
- [ELF for AArch64]

[gas]: https://sourceware.org/binutils/docs/as/
[gas-syntax]: https://sourceware.org/binutils/docs/as/AArch64-Syntax.html
[guide to ARM64]: https://modexp.wordpress.com/2018/10/30/arm64-assembly/
[Cortex-A series programmers guide]: https://developer.arm.com/documentation/den0024/a/
[ARM64 instruction reference]: https://developer.arm.com/documentation/ddi0602/2022-03/Base-Instructions?lang=en
[KEIL arm32 instruction reference]: https://www.keil.com/support/man/docs/armasm/armasm_dom1361289850039.htm
[procedure call standard for ARM64]: https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst
[ELF for Aarch64]: https://github.com/ARM-software/abi-aa/blob/main/aaelf64/aaelf64.rst
