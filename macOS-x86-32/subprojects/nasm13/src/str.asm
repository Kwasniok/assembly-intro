; target: MAC OS 10.7 or higher, MACH-O, i386, little endian
; calling convention: cdecl-like, 16 byte aligned

%ifndef _STR_ASM_
%define _STR_ASM_

section .text

; int strlen(char* str)
; calculate length of string str via null-termination
strlen:
.prolog:
    push    ebp
    mov     ebp, esp
    push    ebx
.begin:
    mov     eax, dword [ebp+20]     ; load initial position
    mov     ebx, eax                ; copy initial position
.next:
    cmp     byte [eax], 0           ; check for null character
    jz      .final                  ; terminate loop if it is a null character
    inc     eax                     ; go to next character
    jmp     .next                   ; continue loop
.final:
    sub     eax, ebx                ; subtract initial address form current
                                    ; address and store the result in eax
.epilog:
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret

%endif ; %ifndef _STR_ASM_
