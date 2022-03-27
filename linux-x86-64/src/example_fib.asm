; Example programm for calculating Fibonacci numbers.
; Returns up to but not including N_MAX numbers and aborts apon an overflow.

    global main
    extern printf

N_MAX:  equ     0xFFFF

    section .text
main:
.init:
    mov     rax, 0      ; f(0)
    mov     rdx, 1      ; f(1)
    mov     rcx, 1      ; counter n
.print:
    ; print(const char* format, ...)
    push    rax         ; caller saved
    push    rdx         ; caller saved
    push    rcx         ; caller saved
    sub     rbp, 8      ; align stack
    mov     rdi, format
    mov     rsi, rcx
    ; mov   rdx, rdx
    xor     rax, rax    ; due to varargs: no vector registers used
    call    printf
    add     rbp, 8      ; revert
    pop     rcx         ; revert
    pop     rdx         ; revert
    pop     rax         ; revert
.inc:
    mov     rdi, rdx    ; tmp = f(n)
    add     rdx, rax    ; f(n+1)
    jo      .abort      ; abort apon overflow
    mov     rax, rdi    ; f(n)
    inc     rcx         ; ++n
.loop:
    cmp     rcx, N_MAX
    jne     .print
.ret:
    ret
.abort:
    mov     rdx, rdi    ; restore
    ret

    section .data
format:
    db      `f(%lu) = %lu\n`, 0

