# Linux x86-64 Assembly

## Organization
Source code is stored in `src` and executables are build in `bin`.
Run `make` to build all executables or `make <target>` where `<target>` is the name of the executable to build one executable.

## Dependencies
- CPU with x86_64 architecture
- linux kernel v5.16+
- nasm v2.15+
- gcc v11.2+ (or clang v13+)
- gdb v11.2+ (optional, or lldb v13+)
- make v4.3+ (optional)

note: Lower version numbers should work but were not tested.

note: This project focuses on the GNU compiler. Using LLVM is possible but requires an adaptation of the Makefile.
