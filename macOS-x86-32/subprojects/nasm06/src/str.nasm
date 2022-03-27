
; calculate length of string (eax) via null-termination (return to eax)
strlen:
.prolog:
    push    ebx                     ; store ebx on stack to preserve it
.begin:
    mov     ebx, eax                ; store initial position
.next:
    cmp     byte [eax], 0           ; check for null character
    jz      .final                  ; terminate loop if it is a null character
    inc     eax                     ; go to next character
    jmp     .next                   ; continue loop
.final:
    sub     eax, ebx                ; subtract initial address form current
                                    ; address and store the result in eax
.epilog:
    pop     ebx                     ; restore ebx
    ret                             ; return (counter part of call)

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
    sub     esp, 4                  ; align stack (to 8 bytes)
    mov     eax, 4                  ; store opcode for sys_write
    int     0x80                    ; perform system call
    add     esp, 20                 ; pop stack
.epilog:
    ; restore registers
    pop     eax
    pop     ebx
    ret

; print char (eax) to stdout
cprint:
.prolog:
    ; store registers
    push    dword   ebx
    push    dword   eax
.begin:
    mov     ebx, 1
.sys_write:
    ; perform system call (sys_write)
    ; c pseudo code declaration:
    ;     user_ssize_t write(int fd, user_addr_t cbuf, user_size_t nbyte)
    ; push arguments from right to left
    sub     esp, 4                  ; align stack (to 8 bytes)
    push    dword   ebx             ; nbyte
    push    dword   eax             ; cbuf
    push    dword 1                 ; fd (stdout)
    sub     esp, 4                  ; align stack (to 8 bytes)
    mov     eax, 4                  ; store opcode for sys_write
    int     0x80                    ; perform system call
    add     esp, 20                 ; pop stack
.epilog:
    ; restore registers
    pop     eax
    pop     ebx
    ret
