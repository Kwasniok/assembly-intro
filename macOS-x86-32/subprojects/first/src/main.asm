; target: MAC OS 10.7 or higher, MACH-O, i386
; description: hello world


section .data
; db pseudo-op: store byte array
msg:    db      "Hello, world!", 0x0A, 0 ; set message
; equ pseudo-op: evaluate expression and store result
.len:   equ     $ - msg             ; calculate length of message

section .text
global start

start:

write_message:
    ; sys_call of sys_write (OPCODE 4) in BSD convention:
    mov     eax, 4                  ; store opcode in main register
    ; push arguments in reverse order
    push    dword msg.len           ; push message address
    push    dword msg               ; push message length (in bytes)
    push    dword 1                 ; push file descriptor (stdout)
    sub     esp, 4                  ; align stack (to 16 bytes)

    ; int 0x80 is an interrupt passing the workflow back to the kernel
    int     0x80                    ; perform system call

    add     esp, 16                 ; pop stack

    call exit

exit:
    ; sys_call of sys_exit (OPCODE 1) in BSD convention
    mov     eax, 1                  ; store opcode in main register
    ; push arguments in reverse order
    push    dword 4                 ; push exit status
    sub     esp, 4                  ; align stack (to 8 bytes)

    int     0x80                    ; perform system call
