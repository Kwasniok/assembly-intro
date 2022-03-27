; target: MAC OS 10.7 or higher, MACH-O, i386, little endian
; description: count 0..9 and print all details of integer division by 3

%include    "quit.nasm"
%include    "print.nasm"

section .data
str_div:    db      "/", 0x00
str_eq:     db      "=", 0x00
str_r:      db      "r", 0x00

section .text
global start
start:
    mov     ecx, 0                  ; counter = 0
    mov     ebx, 3                  ; divisor = 3

.next:
    cmp     ecx, 10                 ; while counter < 10
    je      .final

    ; divide value of counter by divisor and print all details

    mov     eax, ecx                ; current = counter

    ; print `<divident>/<divisor>=`

    ; print divident
    call    idprint
    ; store registers and align stack
    push    eax
    sub     esp, 4
    ; print division sign
    mov     eax, str_div
    call    sprint
    ; print divisor
    mov     eax, ebx
    call    idprint
    ; print equals sign
    mov     eax, str_eq
    call    sprint
    ; restore registers and pop stack
    add     esp, 4
    pop     eax

    ; perform division
    ; DIV divides EDX:EAX (interpreted as one quad word) by given register
    ; and stores floor(EDX:EAX / EBX) in EAX and mod(EDX:EAX, EBX) in EDX
    mov     edx, 0x0                ; clear EDX
    idiv    ebx

    ; print `<floor(divident/divisor)>rmod(divident,divisor)\n`

    ; print floor(divident/divisor)
    call    idprint
    ; print r
    mov     eax, str_r
    call    sprint
    ; print mod(divident/divisor) and line feed
.here:
    mov     eax, edx
    call    idprintlf

    ; increase and continue loop
    inc     ecx
    jmp     .next
.final:

.quit:
    ; quit
    call    quit
