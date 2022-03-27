; target: MAC OS 10.7 or higher, MACH-O, i386
; description: print argvs program

%include    "quit.nasm"
%include    "str.nasm"

section .text
global start
start:
    ; print argvs
    pop     ecx                     ; get nargs
.next:
    cmp     ecx, 0                  ; while nargs > 0
    jz      .final                  ; terminate loop if true
    pop     eax                     ; get arg
    call    sprintlf                ; print arg
    dec     ecx                     ; nargs -= 1
    jmp     .next                   ; continue loop
.final:
    ; quit
    call    quit
