; defines an identity function

    global asm_func
    section .text

; int64_t asm_func(int64_t n)
asm_func:
    mov     rax, rdi
    ret
