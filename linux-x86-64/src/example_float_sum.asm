; Example program for functions acting on a vector of floating point numbers.
; Each vector consists of n floats packed as an array at given address v.


    global  sum
    global  avg
    section .text

; double sum(uint64_t n, double* v);
sum:
.init:
    xorpd   xmm0, xmm0  ; clear total
    cmp     rdi, 0
    je      .ret
.loop:
    addsd   xmm0, [rsi] ; add next value
    add     rsi, 8      ; change pointer to next value
    dec     rdi         ; advance counter
    jnz     .loop       ; stop condition
.ret:
    ret

; double avg(uint64_t n, double* v);
avg:
.init:
    xorpd   xmm0, xmm0  ; return zero in case of empty list
    cmp     rdi, 0      ; test if empty
    je      .ret
.sum:
    push    rdi
    call    sum
    pop     rdi
.div:
    cvtsi2sd    xmm1, rdi   ; convert n to double
    divsd   xmm0, xmm1      ; divide by n
.ret:
    ret
