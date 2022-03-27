; short program which writes a message

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
