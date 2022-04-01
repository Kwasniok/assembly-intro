# Linux ARM-64 Assembly

## Info
The [A64](https://developer.arm.com/architectures/instruction-sets/base-isas/a64) instruction set is supported by the [Armv8-A](https://en.wikipedia.org/wiki/AArch64#ARMv8-A) architecture.

Hardware that supports it includes:

| architecture | CPU            | hardware                  |
|--------------|----------------|---------------------------|
| Armv8-A      | ARM Cortex-A72 | Raspberry Pi 4B (BCM2711) |

## Dependencies
- CPU supporting the A64 instruction set
- linux kernel v5.15+
- nasm v2.15+
- gcc v11.2+ (or clang v13+)
- gdb v11.2+ (optional, or lldb v13+)
- make v4.3+ (optional)

note: Lower version numbers should work but were not tested.

note: This project focuses on the GNU compiler. Using LLVM is possible but requires an adaptation of the Makefile.
