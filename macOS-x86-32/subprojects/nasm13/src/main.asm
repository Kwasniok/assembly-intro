; target: MAC OS 10.7 or higher, MACH-O, i386, little endian
; calling convention: cdecl-like, 16 byte aligned
; description: print a number n in base 2, 8, 10 and 16

%include    "os.asm"
%include    "io.asm"

%define n 0x12345678

section .data
str_eq_bin:     db  " = 0b", 0x00
str_eq_oct:     db  " = 0o", 0x00
str_eq_dec:     db  " =   ", 0x00
str_eq_hex:     db  " = 0x", 0x00
str_bin:        db  " (base 2)", 0x00
str_oct:        db  " (base 8)", 0x00
str_dec:        db  " (base 10)", 0x00
str_hex:        db  " (base 16)", 0x00

section .text
global start
start:
    and     esp, 0xFFFFFFF0         ; align stack by 16 bytes
.polog:
    push    ebp
    mov     ebp, esp
.begin:
    ; align and allocate stack
    and     esp, 0xFFFFFFF0
    sub     esp, 16
    ; base = 2
    mov     [esp+12], dword 10
    mov     [esp+8], dword n
    call    iwrite
    mov     [esp+12], dword str_eq_bin
    call    swrite
    mov     [esp+12], dword 2
    mov     [esp+8], dword n
    call    iwrite
    mov     [esp+12], dword str_bin
    call    swritelf
    ; base = 8
    mov     [esp+12], dword 10
    mov     [esp+8], dword n
    call    iwrite
    mov     [esp+12], dword str_eq_oct
    call    swrite
    mov     [esp+12], dword 8
    mov     [esp+8], dword n
    call    iwrite
    mov     [esp+12], dword str_oct
    call    swritelf
    ; base = 10
    mov     [esp+12], dword 10
    mov     [esp+8], dword n
    call    iwrite
    mov     [esp+12], dword str_eq_dec
    call    swrite
    mov     [esp+12], dword 10
    mov     [esp+8], dword n
    call    iwrite
    mov     [esp+12], dword str_dec
    call    swritelf
    ; base = 16
    mov     [esp+12], dword 10
    mov     [esp+8], dword n
    call    iwrite
    mov     [esp+12], dword str_eq_hex
    call    swrite
    mov     [esp+12], dword 16
    mov     [esp+8], dword n
    call    iwrite
    mov     [esp+12], dword str_hex
    call    swritelf
    ; deallocate stack
    add     esp, 16
    ; quit
    call    quit
epilog:
    mov     esp, ebp
    pop     ebp
