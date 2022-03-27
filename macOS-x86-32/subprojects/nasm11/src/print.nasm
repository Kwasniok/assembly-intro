%ifndef _PRINT_NASM_
%define _PRINT_NASM_
%include    "str.nasm"

section .text

; print null-terminated string (eax) to stdout
sprint:
.prolog:
    ; store registers
    push    dword   ebx
    push    dword   eax
.begin:
    mov     ebx, eax
    call    strlen
.sys_write:
    ; perform system call (sys_write)
    ; c pseudo code declaration:
    ;     user_ssize_t write(int fd, user_addr_t cbuf, user_size_t nbyte)
    ; push arguments from right to left
    sub     esp, 4                  ; align stack (to 8 bytes)
    push    dword   eax             ; nbyte
    push    dword   ebx             ; cbuf
    push    dword 1                 ; fd (stdout)
    push    dword   edx             ; align stack (to 8 bytes) and store edx
    mov     eax, 4                  ; store opcode for sys_write
    int     0x80                    ; perform system call (messes with edx)
    pop     edx                     ; restore edx
    add     esp, 16                 ; pop stack
.epilog:
    ; restore registers
    pop     eax
    pop     ebx
    ret

section .data
lfnt: db      0x0A, 0x00

section .text
; print null-terminated string (eax) incl. a line feed to stdout
; wrapps around sprint
sprintlf:
.base:
    call    sprint                  ; print string
.prolog:
    push    dword   eax             ; store registers
.begin:
    mov     eax, lfnt               ; set string to null-terminated line feed
    call    sprint                  ; print line feed
.epilog:
    pop     eax                     ; restore registers
    ret


section .text
; print single digit number (eax) in base 10 to stdout
idprint:
.prolog:
    push    dword   eax             ; store registers
.begin:
    add     eax, 0x30               ; 0x30 = `0` in ASCII
    push    eax                     ; push it on the stack
    mov     eax, esp                ; get its address
    sub     esp, 4                  ; align to 8 bytes
    call    sprint                  ; print it
.epilog:
    add     esp, 8                 ; pop stack
    pop     eax                    ; restore registers
    ret

section .text
; print single digit number [0-9] (eax) in base 10 incl. a line feed to stdout
; wrapps around iprint, no boundary checks performed
idprintlf:
.base:
    call    idprint                 ; print digit
.prolog:
    push    dword   eax             ; store registers
.begin:
    mov     eax, lfnt               ; set string to null-terminated line feed
    call    sprint                  ; print line feed
.epilog:
    pop     eax                    ; restore registers
    ret

%endif ; %ifndef _PRINT_NASM_
