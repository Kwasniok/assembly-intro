// Syscall exit. (minimal program)

.global _start

.text
_start:
    mov x0, #0      // exitcode
    mov w8, #93     // syscall code
    svc #0          // syscall

