; Example program for stack frames.

    global  _start

    section .text

_start:
    push    rbp
    call    func
    mov     rax, 60     ; exit
    xor     rdi, rdi
    syscall


func:
.prologue:
    ; stack is 16-byte aligned before `call`
    push    rbp         ; store old stack frame pointer
    ; stack is 16-byte aligned again
    mov     rbp, rsp    ; advance stack frame pointer
    sub     rsp, 16     ; alloc 16 bytes for local variables
    ; stack 16-byte aligned again
.body:
    ; function body may use local variables and/or call other functions
    times 32    rdtsc
.epilogue:
    add     rsp, 16     ; reverse alloc
    pop     rbp         ; restore old stack frame pointer
    ret                 ; return
