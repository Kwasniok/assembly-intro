; Example program which uses libc to print the program args.

    global  main
    extern  puts

    section .text
; int main(int argc, char** argv)
main:
.loop:
    push    rdi         ; caller saved
    push    rsi         ; caller saved
    mov     rdi, [rsi]  ; select current argument
    sub     rsp, 8      ; align stack
    call    puts        ; print argument
    add     rsp, 8      ; revert
    pop     rsi
    pop     rdi
.inc:
    add     rsi, 8      ; next argument
    dec     rdi         ; one argument less remaining
    jnz     .loop       ; stop if no arguments left
.ret:
    ret
