; Example programm for a printf call.

    global main
    extern printf

    section .text


main:
.print:
    ; print(const char* format, ...)
    mov     rdi, format
    mov     rsi, 12345
    xor     rax, rax    ; due to varargs: no vector registers used
    sub     rbp, 8*3    ; align stack
    call    printf
    add     rbp, 8*3    ; revert
.ret:
    ret

    section .data
format:
    db      `%li\n`, 0

