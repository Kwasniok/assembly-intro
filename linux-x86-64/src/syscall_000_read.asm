; short program which reads and then writes a message

    global _start

    section .text
_start:
read:
    mov     rax, 0  ; syscall read
    mov     rdi, 0  ; stdin
    mov     rsi, buffer
    mov     rdx, 256; size
    syscall
write:
    mov     rax, 1  ; syscall write
    mov     rdi, 1  ; stdout
    mov     rsi, buffer
    mov     rdx, 256; size
    syscall
exit:
    mov     rax, 60 ; syscall exit
    xor     rdi, rdi; exit code 0
    syscall

    section .bss
buffer:
    resb 256

