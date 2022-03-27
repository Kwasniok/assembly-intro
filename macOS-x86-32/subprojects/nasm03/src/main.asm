; target: MAC OS 10.7 or higher, MACH-O, i386
; description: hello world program with null-terminated string

section .data
; db pseudo-op: store byte array
; equ pseudo-op: evaluate expression and store result
msg:        db      "Hello World!", 0xA, 0 ; null-terminated string


section .text
global start
start:
msgstrlen:
    ; calculate msg length via null-termination (stored in eax)
    mov     ebx, msg                ; store beginning address for comparisions
    mov     eax, ebx                ; set current position to first charater
next:
    cmp     byte [eax], 0           ; check for null character
    jz      final                   ; terminate loop if it is a null character
    inc     eax                     ; go to next character
    jmp     next                    ; continue loop
final:
    sub     eax, ebx                ; subtract initial address form current
                                    ; address and store the result in eax

write:
    ; perform system call (sys_write)
    ; c pseudo code declaration:
    ;     user_ssize_t write(int fd, user_addr_t cbuf, user_size_t nbyte)
    ; push arguments from right to left
    push    dword   eax             ; nbyte
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
