# Linux x86-64 Assembly

This document uses [NASM][nasm] and the [intel syntax][intel vs atnt syntax].

## Instruction
Consists of an operator code denoting the instruction and operands.
```
<operation code> [<operand> [, <operand> ...]]
```
example:
Move `42` to register `rdx`.
```
mov rdx, 42
```
## Regsiter Operands
### Instrution Pointer Register
The is one instruction pointer.

| name | purpose             |
|------|---------------------|
| RIP  | instruction pointer |

### General Purpose Registers
There are 16 general purpose registers.

| name | conventional purpose |
|------|-------------|
|R0/RAX| accumulator |
|R1/RCX| counter     |
|R2/RBX| base        |
|R3/RDX| data        |
|R4/RSP| stack pointer |
|R5/RBP| base pointer/stack frame pointer |
|R6/RSI| source index |
|R7/RDI| destination index |
|R8-R15| - |

### Subregisters
All `R**` registers are 64 bit. Sub 32/16/8 bit registers can be adressed via:
```
|<-----------------------------R0/RAX------------------------------>|
|                                |<-------------R0D/EAX------------>|
|                                |                |<-----R0W/AX---->|
|                                |                |<-(AH)->|<R0B/AL>|
+--------------------------------+----------------+--------+--------+
|                                |                |        |        |
+--------------------------------+----------------+--------+--------+
63                                                                 0
```
note: The suffixes relate to.

| suffix | name   | size    |
|---|-------------|---------|
| - | quad word   | 64 bits |
| D | double word | 32 bits |
| W | word        | 16 bits |
| B | byte        | 8 bits  |

note: The alternative notation exists for historic reasons as are the AH, CH, BH and DH subregisters.

### Advanced Vector Extension Registers
All `AVX` registers can be used for floating point or vector/pack operations. The `SIMD` (single instruction multiple data) operations divide a register into equal parts and act on each part simultaneously with the same operation.

| prefix | size     | extension |
|--------|----------|-----------|
| ZMM    | 512 bits | AVX-512   |
| YMM    | 256 bits | AVX       |
| XMM    | 128 bits | AVX       |

AVX-512 defines 32 registers (ZMM0-ZMM31) whereas AVX defines only 16 registers (YMM0-YMM15).

Just like the general purpose registers, smaller registers are subregisters of the larger ones.
```
|<------------------------------ZMM0------------------------------->|
|                                |<--------------YMM0-------------->|
|                                |                |<------XMM0----->|
+--------------------------------+----------------+-----------------+
|                                |                |                 |
+--------------------------------+----------------+-----------------+
511                                                                 0
```

## Memory Operands
Memory operands appear in brackets.

| syntax | semantics |
|--------|-----------|
| [< number >] | memory with address < number > |
| [< regsiter >] | memory with address stored in < register > |
| [< regsiter1 > + < register2 > * < scale >] | memory with address < register1 > plus offset of < register2 > times < scale > where < scale = 1,2,4,8 > |
| [< register > + < number >] | |
| < register1 > + < register2 > * < scale > + number] | |

## Common Instructions
| syntax | semantics |
|--------|----------|
| nop | do nothing |
| mov x, y | x <- y |
| movzx x, y | x <- y with zero extension |
| and x, y | x <- bitwise x and y |
| xor x, y | x <- bitwise x xor y |
| or x, y | x <- bitwise x or y |
| add x, y | x <- x + y |
| sub x, y | x <- x - y |
| inc x | x <- x + 1 |
| dec x | x <- x - 1 |
| jmp x | jump to symbol x |
| call x | jump to symbol x and push the return address onto the stack |
| syscall | initiate system call |

## Pseudo-Instructions
| syntax | semantics | example |
|--------|-----------|---------|
| global x | export symbol x | `global _start` |
| section x | switch to section x e.g. `.text` (code), `.data` (initialized data), `.bss` (unititialized data) | `section .text`
| align x | ensure alignment of x byte for the following data | `align 16` |
| db x [, y ...] | store bytes | `db 0xFF`, `db "Hello", 10, 0`, `db 1, 2, 3` |
| dw x [, y ...] | store words | `dw 0xFFFF` |
| dd x [, y ...] | store double words | `dd 0xFFFFFFFF`, `dd 1.23e45` |
| dq x [, y ...] | store quad words | `dq OxFFFFFFFFFFFFFFFF`, `dq 1.23e45` |
| resb x | reserve space for x bytes | `resb 8` |
| resw x | reserve space for x words | `resw 4` |
| resd x | reserve space for x double words | `resd 2`  |
| resq x | reserve space for x quad words | `resq 1`  |
| times n < instruction > | macro: repeat instructions n times | `times 10 nop` |

## AVX Instructions
| syntax | semantics | note |
|--------|----------|------|
| vmovaps x, y | x <- y | one of them must be a memory location |
| vpaddsb x, y | x <- clamp(x + y) | add pack of 64 byte-integers with saturation |
| vpaddsw x, y | x <- clamp(x + y) | add pack of 16 word-integers with saturation |

## System V x86_64 Calling Convention
This is a shortened description of the System V ABI calling convention based on the recommended amd64 calling convention [amd64 manual].

### Function Calls (Fixed Arity)
The convention for function calls in Linux is:
- Stack must be aligned to 16 byte right before the function is called via `call`.
- Arguments are stored from left to right in the registers `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9` resp. `YMM0`-`YMM7` and the remaining arguments are pushed on the stack right to left. (Data which must have an address - e.g. class instances in C++ - are always pushed onto the stack.)
- `[rdx:]rax` or `YMM0[:YMM1]` hold(s) the return value
- The callee may advance the stack temporarily to allocate space for local variables.
- The next 128 bytes beyond the current stack position form the so-called **red zone**. It is reserved as scratch space for the current function and will not be modified by interrupts etc.
- Updating the base pointer `rbp` to indicate the beginning of the frame is optional.

| registers | preserved/restored by |
|----------|--------------|
| `rax`, `rdi`, `rsi`, `rdx`, `rcd`, `r8`-`r11`, `*MM*`  | caller |
| `rbx`, `rsp`, `rbp`, `r12`-`r15`| callee |


### Function Calls (Variable Arity)
- In addition to the usual conventions `al` indicates how many `*MM*` registers occupied by arguments.

### Linux Syscalls
The convention for syscalls in Linux is:
- `rax` contains the system call number.
- `rdi`, `rsi`, `rdx`, **`r10`(not `rcx`!)**, `r8`, `r9` etc. contain the arguments
- `rax` holds the return value


**note: The numbers differ from the 32bit conventions.**

| nr  | description | rdi     | rsi     | rdx     | r10     |
|-----|-------------|---------|---------|---------|---------|
|   0 | read        | file descriptor | buffer  | size    | -       |
|   1 | write       | file descriptor | buffer  | size    | -       |
|  60 | exit        | exit code | -     | -       | -       |

## Example Code
Hello World in nasm.
```nasm
; hello world program

    global _start

    section .text
_start:
write:
    mov     rax, 1  ; syscall write
    mov     rdi, 1  ; stdout
    mov     rsi, message    ; buffer
    mov     rdx, 14  ; size
    syscall
exit:
    mov     rax, 60 ; syscall exit
    xor     rdi, rdi; exit code 0
    syscall

    section .data
message:
    db "Hello there!", 10

```

## Compile and Run
### Pure Assembly
```
nasm -f elf64 $filename.asm -g -F dwarf
ld -o $filename $filename.o
./$filename
```
note: Use `-g -F dwarf` for debug symbols.

### Assembly with Embedded `stdc` Calls
```
nasm -f elf64 -g -F dwarf $filename.asm
gcc -o $filename $filename.o -g -no-pie -fno-pie
./$filename
```
note: Use `-g -F dwarf` resp. `-g` for debug symbols.
note: Use `-no-pie -fno-pie` to disable [PIE][position independent code] (position independent executable) if necessary.

## Disassemble
```
objdump -xds $filename
```

## References
- [nasm-tutorial]
- [amd64 manual]
- [overview of calling conventions]
- [linux amd64 syscall table]
- [position independent code]

[nasm]: https://nasm.us/
[intel vs atnt syntax]: https://tuttlem.github.io/2014/03/25/assembly-syntax-intel-at-t.html
[nasm-tutorial]: https://cs.lmu.edu/~ray/notes/nasmtutorial/
[amd64 manual]: https://www.amd.com/en/support/tech-docs/amd64-architecture-programmers-manual-volumes-1-5
[overview of calling conventions]: https://en.wikipedia.org/wiki/X86_calling_conventions#List_of_x86_calling_conventions
[linux amd64 syscall table]: https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
[position independent code]: https://en.wikipedia.org/wiki/Position-independent_code
