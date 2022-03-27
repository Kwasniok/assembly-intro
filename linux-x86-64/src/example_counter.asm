; Example programm for a counter.

    global main
    extern printf

N_MAX:  equ     0xFFFFFF

    section .text
main:
.init:
    xor     rcx, rcx    ; start with 0
.print:
    ; print(const char* format, ...)
    push    rcx         ; caller saved
    mov     rdi, format
    mov     rsi, rcx
    xor     rax, rax    ; due to varargs: no vector registers used
    call    printf
    pop     rcx         ; revert
.inc:
    inc     rcx
.loop:
    cmp     rcx, N_MAX
    jne     .print
.ret:
    ret

    section .data
format:
    db      `%li\n`, 0

