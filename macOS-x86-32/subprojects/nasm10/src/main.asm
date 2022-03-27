; target: MAC OS 10.7 or higher, MACH-O, i386, little endian
; description: count and print numbers 0..9 program 

%include    "quit.nasm"
%include    "str.nasm"

section .text
global start
start:
    ; loop over 0..9 and print each number (positive single digit integer only)
    mov     ecx, 0                  ; x = 0
.next:
    cmp     ecx, 10                 ; while x != 10
    je      .final                  ; terminate loop
    mov     eax, 0x30               ; ASCII code for `0`
    add     eax, ecx                ; calculate ASCII code for number (up to 9)
    push    eax                     ; push it on the stack
    mov     eax, esp                ; get its address
    call    sprintlf                ; print it
    add     esp, 4                  ; pop stack
    inc     ecx                     ; x += 1
    jmp     .next                   ; continue loop
.final:
.quit:
    ; quit
    call    quit
