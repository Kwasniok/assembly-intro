quit:
.prolog:
    sub     esp, 4                  ; align stack (to 8 bytes)
.begin:
    ; perform system call (sys_exit)
    ; c pseudo code declaration: void exit(int rval)
    ; push arguments from right to left
    push    dword   0               ; rval
    sub     esp, 4                  ; align stack (to 8 bytes)
    mov     eax, 1                  ; store opcode for sys_exit
    int     0x80                    ; perform system call
