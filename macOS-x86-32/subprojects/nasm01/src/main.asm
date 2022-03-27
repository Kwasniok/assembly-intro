; target: MAC OS 10.7 or higher, MACH-O, i386
; description: simple hello world program (missing exit causes undefined behaviour at end)

section .data
; db pseudo-op: store byte array
; equ pseudo-op: evaluate expression and store result
msg:        db      "Hello World!", 0xA ; non-null-terminated string
    .len    equ     $ - msg


section .text
global start
start:
    ; perform system call
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
