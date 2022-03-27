; target: MAC OS 10.7 or higher, MACH-O, i386
; description: simple hello world program (with proper exit)

section .data
; db pseudo-op: store byte array
; equ pseudo-op: evaluate expression and store result
msg:        db      "Hello World!", 0xA ; non-null-terminated string
    .len    equ     $ - msg


section .text
global start
start:

write:
    ; perform system call (sys_write)
    ; c pseudo code declaration:
    ;     user_ssize_t write(int fd, user_addr_t cbuf, user_size_t nbyte)
    ; push arguments from right to left
    push    dword   msg.len         ; nbyte
    push    dword   msg             ; cbuf
    push    dword 1                 ; fd (stdout)
    sub     esp, 4                  ; align stack (to 8 bytes)
    mov     eax, 4                  ; store opcode for sys_write
    int     0x80                    ; perform system call
    add     esp, 16                 ; pop stack

exit:
    ; perform system call (sys_exit)
    ; c pseudo code declaration: void exit(int rval)
    ; push arguments from right to left
    push    dword   0               ; rval
    sub     esp, 4                  ; align stack (to 8 bytes)
    mov     eax, 1                  ; store opcode for sys_exit
    int     0x80                    ; perform system call
