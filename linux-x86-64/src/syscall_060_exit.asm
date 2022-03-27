; minimal program

    global _start

    section .text
_start:
exit:
    mov     rax, 60 ; syscall exit
    xor     rdi, rdi; exit code 0
    syscall

