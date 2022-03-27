; Example programm which operates on packed integers.

    global  main
    extern  printf

    section .text
main:
    push    rbp

    ; load, add ans store packed signed words
    vmovaps  ymm0, [data0]
    vmovaps  ymm1, [data1]
    vpaddsw  ymm0, ymm1
    vmovaps  [result], ymm0

    ; print result words in groups of 4
    xor     rax, rax
    mov     rdi, format
    movzx   rsi, word [result + 0x00] ; zx = zero extended
    movzx   rdx, word [result + 0x02]
    movzx   rcx, word [result + 0x04]
    movzx   r8 , word [result + 0x06]
    call    printf

    xor     rax, rax
    mov     rdi, format
    movzx   rsi, word [result + 0x08] ; zx = zero extended
    movzx   rdx, word [result + 0x0A]
    movzx   rcx, word [result + 0x0C]
    movzx   r8 , word [result + 0x0E]
    call    printf

    xor     rax, rax
    mov     rdi, format
    movzx   rsi, word [result + 0x10] ; zx = zero extended
    movzx   rdx, word [result + 0x12]
    movzx   rcx, word [result + 0x14]
    movzx   r8 , word [result + 0x16]
    call    printf

    xor     rax, rax
    mov     rdi, format
    movzx   rsi, word [result + 0x18] ; zx = zero extended
    movzx   rdx, word [result + 0x1A]
    movzx   rcx, word [result + 0x1C]
    movzx   r8 , word [result + 0x1E]
    call    printf

    pop     rbp
    ret

    section .data
    align   32
data0:
    dw  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
data1:
    dw  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
format:
    db "0x%04X 0x%04X 0x%04X 0x%04X", 10, 0

    section .bss
    align 32
result:
    resw    8
