%ifndef _STR_NASM_
%define _STR_NASM_

section .text

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

%endif ; %ifndef _STR_NASM_ 
