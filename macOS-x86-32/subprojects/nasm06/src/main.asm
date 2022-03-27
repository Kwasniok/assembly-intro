; target: MAC OS 10.7 or higher, MACH-O, i386
; description: print two lines program

%include    "quit.nasm"
%include    "str.nasm"

section .data
; db pseudo-op: store byte array
; equ pseudo-op: evaluate expression and store result
msg1:   db      "Hello World!", 0xA, 0 ; null-terminated string
msg2:   db      "Bye World!", 0xA, 0   ; null-terminated string

section .text
global start
start:
    ; sprint(msg1)
    mov     eax, msg1
    call    sprint
    ; sprint(msg2)
    mov     eax, msg2
    call    sprint
    ; quit()
    call    quit
