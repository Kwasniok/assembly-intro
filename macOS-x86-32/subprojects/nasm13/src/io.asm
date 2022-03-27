; target: MAC OS 10.7 or higher, MACH-O, i386, little endian
; calling convention: cdecl-like, 16 byte aligned

%ifndef _IO_ASM_
%define _IO_ASM_

%include    "syscall.asm"
%include    "str.asm"


section .text

; int swrite(char* str)
; write null-terminated string to stdout
swrite:
.prolog:
    push    ebp
    mov     ebp, esp
.begin:
    mov     ecx, [ebp+20]
    and     esp, 0xFFFFFFF0
    sub     esp, 16
    mov     [esp+12], ecx
    call    strlen
    syscall_write STDOUT, ecx , eax
    add     esp, 16
.epilog:
    mov     esp, ebp
    pop     ebp
    ret

section .data
lfnt: db      0x0A, 0x00            ; "\n"

section .text
; int swritelf(char* str)
; write null-terminated string incl. a line feed to stdout
swritelf:
.prolog:
    push    ebp
    mov     ebp, esp
.begin:
    and     esp, 0xFFFFFFF0
    sub     esp, 16
    mov     eax, [ebp+20]
    mov     [esp+12], eax
    call    swrite
    mov     [esp+12], dword lfnt
    call    swrite
    add     esp, 16
.epilog:
    mov     esp, ebp
    pop     ebp
    ret


section .data
io_str_digits   db  "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", 0x00

section .text
; int iwrite(int32 i, int32 base)
; write integer i in given base to stdout
; base : 0..36
iwrite:
.prolog:
    push    ebp
    push    ebx
    mov     ebp, esp
.begin:
    and     esp, 0xFFFFFFF0         ; align
    ; calculate digits beginning with the least significant
    ; and put them as ASCII symbols in a buffer on the stack
    mov     ebx, [ebp+24]           ; base -> ebx
    mov     eax, [ebp+20]           ; i -> eax
    ;mov     ebx, 10                 ; set base (= 10, can be any of 2..10)
    mov     ecx, esp                ; store address of last byte in string ...
    dec     ecx                     ; ... buffer on stack
    sub     esp, 0x40               ; allocate buffer string of at most 32
                                    ; digits plus null terminator on stack
                                    ; (and respect 8 byte alignment)
    mov     [ecx], byte 0x00        ; set last byte in buffer to null terminator
.next:
    ; get last digit of i (EAX) in respect to base (EBX)
    mov     edx, 0                  ; clear EDX (required for div)
    div     ebx                     ; i (EDX:EAX) /= base (EBX) -> rest (EDX)
    ;add     edx, 0x30               ; convert digit (rest) to ASCII
    mov     dl, byte [io_str_digits+edx] ; convert digit (rest) to ASCII
                                    ; via lookup table
    dec     ecx                     ; get next address in string buffer
    mov     [ecx], byte dl          ; put digit symbol in buffer
    cmp     eax, 0                  ; do while(i != 0)
    jne     .next
.final:
    ; write the buffered digit string
    sub     esp, 16
    mov     [esp+12], ecx           ; get address of digit string buffer
    call    swrite                  ; write digit string
    add     esp, 16+0x40            ; pop stack (call+buffer)
.epilog:
    ; restore registers
    mov     esp, ebp
    pop     ebx
    pop     ebp
    ret

section .text
; int iwrite(int32 i, int32 base)
; write integer i in given base incl. a line feed to stdout
; base : 0..36
iwritelf:
.prolog:
    push    ebp
    mov     ebp, esp
.begin:
    and     esp, 0xFFFFFFF0
    sub     esp, 16
    mov     eax, [ebp+20]
    mov     [esp+12], eax
    mov     eax, [ebp+16]
    mov     [esp+8], eax
    call    iwrite
    mov     [esp+12], dword lfnt
    call    swrite
    add     esp, 16
.epilog:
    mov     esp, ebp
    pop     ebp
    ret

%endif ; %ifndef _IO_ASM_
