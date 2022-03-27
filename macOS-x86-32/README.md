# macOS x86-32 Assembly

## Organization

There are multiple subprojects in the `subprojects` folder:
```
  - o - subprojects
    + - o subproj01
        + - o bin
            + - o main
        + - o src
            + - o main.nasm
        + - o makefile
            ...
    + - o subproj02
        ...
    ...
```
Within each subproject `bin` contains the executable `main` and `src` holds the NASM source code file `main.nasm` and
potentially more source code files. The [`makefile`](https://www.gnu.org/software/make/manual/make.html) defines the build and clean procedure for each subproject.

## Dependencies
- CPU with IA-32 architecture
- macOS v10.7
- nasm
- Xcode commadline tools
- make

## Tools
The following tools available as scripts:

| command | tool |
|--------|-------|
| `./build <subproject>` | build the executalbe (must be performed before running) |
| `./run <subproject> <args>` | run the executalbe |
| `./debug <subproject>`  | debug the executable with [LLDB](https://lldb.llvm.org/) |
| `./disassemble <subproject> [<label>]` | disassemble text and data section of the executalbe (starting at `<label>`) |
| `./symbol_table <subproject>` | show symbol table of executable (may not be complete) |
| `./stats <subproject>` | show stats (size of executable and SLOC) |
| `./clean <subproject>` | remove executable and temporary build files |

## Subprojects
The [subprojects](subprojects) are:

| name | description |
|------|-------------|
| `minimal_working_example` | simplest valid program possible |
| `nasmXX` | inspired by the lessons on [asmtutor.com](https://asmtutor.com/) (numbers do not match) |

## Useful Commands
Further useful commands are:

| command | description |
|---------|-------------|
| `file <file path>` | get details about the file type (beyond the extension, e.g. architecture of executables) |

## References
- [complete NASM instruction set reference](http://home.myfairpoint.net/fbkotler/nasmdocc.html)
- [system calls on MAC OS X (32bit and 64bit)](https://filippo.io/making-system-calls-from-assembly-in-mac-os-x/)
_Note: Alignment for 32bit can be 8 bytes instead of 16 bytes!_
- [more on system calls on MAC OS X for 64bit](http://thexploit.com/secdev/mac-os-x-64-bit-assembly-system-calls/)
- [system call table for MAC OS X](https://opensource.apple.com/source/xnu/xnu-1504.3.12/bsd/kern/syscalls.master)
- [system call table for macOS (64bit)](https://sigsegv.pl/osx-bsd-syscalls/)
- [IA-32 calling convention](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/LowLevelABI/130-IA-32_Function_Calling_Conventions/IA32.html)
- [LLDB command cheat sheet](https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/gdb_to_lldb_transition_guide/document/lldb-command-examples.html)
- [System V ABI for i386 (conventions)](https://www.uclibc.org/docs/psABI-i386.pdf)
- [GNU make documentation](https://www.gnu.org/software/make/manual/make.html)
