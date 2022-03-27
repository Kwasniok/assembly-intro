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
; print integer (eax) in base 10 to stdout
; TODO: make base (ebx) a variable
iprint:
.prolog:
    ; store registers
    push    dword   edx
    push    dword   ecx
    push    dword   ebx
    push    dword   eax
.begin:
    ; calculate digits beginning with the least significant
    ; and put them as ASCII symbols in a buffer on the stack
    mov     ebx, 10                 ; set base (= 10, can be any of 2..10)
    mov     ecx, esp                ; store address of last byte in string ...
    dec     ecx                     ; ... buffer on stack
    sub     esp, 40                 ; allocate buffer string of at most 32
                                    ; digits plus null terminator on stack
                                    ; (and respect 8 byte alignment)
    mov     [ecx], byte 0x00        ; set last byte in buffer to null terminator
.next:
    ; get last digit of i (EAX) in respect to base (EBX)
    mov     edx, 0                  ; clear EDX (required for div)
    div     ebx                     ; i (EDX:EAX) /= base (EBX) -> rest (EDX)
    add     edx, 0x30               ; convert digit (rest) to ASCII
    dec     ecx                     ; get next address in string buffer
    mov     [ecx], byte dl          ; put digit symbol in buffer
    cmp     eax, 0                  ; do while(i != 0)
    jne     .next
.final:
    ; print the buffered digit string
    mov     eax, ecx                ; get address of digit string buffer
    call    sprint                  ; print digit string
    add     esp, 40                 ; pop stack (buffer)
.epilog:
    ; restore registers
    pop     eax
    pop     ebx
    pop     ecx
    pop     edx
    ret

section .text
; print integer (eax) in base 10 incl. a line feed to stdout
; wrapps around iprint
iprintlf:
.base:
    call    iprint                 ; print digit
.prolog:
    push    dword   eax             ; store registers
.begin:
    mov     eax, lfnt               ; set string to null-terminated line feed
    call    sprint                  ; print line feed
.epilog:
    pop     eax                    ; restore registers
    ret

%endif ; %ifndef _PRINT_NASM_
