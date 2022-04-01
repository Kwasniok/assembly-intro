// Syscall write.

.global _start

.text
_start:
    mov x0, #1      // file descriptor: stdout
    adr x1, message // buffer
    mov x2, #15     // count
    mov w8, #64     // syscall code
    svc #0          // syscall
_exit:
    mov x0, #0      // exit code
    mov w8, #93     // exit
    svc #0          // syscall

.data
message:
    .asciz  "Hello there!\n"
