; target: MAC OS 10.7 or higher, MACH-O, i386
; description: print two lines program

%include    "quit.nasm"
%include    "str.nasm"

section .data
; db pseudo-op: store byte array
; equ pseudo-op: evaluate expression and store result
msg1:   db      "Hello World!", 0   ; null-terminated string
msg2:   db      "Bye World!", 0     ; null-terminated string

section .text
global start
start:
    ; print msg1 (with line feed)
    mov     eax, msg1
    call    sprintlf
    ; print msg2 (with line feed)
    mov     eax, msg2
    call    sprintlf
    ; quit
    call    quit
