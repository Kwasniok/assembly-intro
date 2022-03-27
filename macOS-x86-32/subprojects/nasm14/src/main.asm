; target: MAC OS 10.7 or higher, MACH-O, i386, little endian
; calling convention: cdecl-like, 16 byte aligned
; description: echo program

%include    "os.asm"
%include    "io.asm"

%define nbyte 1024

str_fail:   db  "-fail-", 0x00
str_welcome:   db  "write q to quit", 0x00
str_in:     db  ">> ", 0x00
str_out:    db  "<< ", 0x00

section .text
global start
start:
    and     esp, 0xFFFFFFF0         ; align stack by 16 bytes
.polog:
    push    ebp
    mov     ebp, esp
    sub     esp, 12                 ; align
.begin:
.welcome:
    sub     esp, 16
    mov     [esp+12], dword str_welcome ; str
    call    swritelf
    add     esp,16
.echo:
    sub     esp, nbyte              ; alloc buf
    mov     [esp], byte 0x00        ; initialize buf with ""
    mov     eax, esp                ; store buf
    sub     esp, 16                 ; push arguments
    mov     [esp+8], eax            ; buf
.next:
    ; print ">>"
    mov     [esp+12], dword str_in  ; str
    call    swrite
    ; read
    mov     [esp+12], dword nbyte   ; nbyte (note: buf is already set)
    call    sread
    ; if *buf == 'q' terminate
    cmp     [esp+16], byte 0x71     ; if *buf is "q"
    je      .final                  ; terminate loop
    ; print "<<" and echo on success (or signal fail)
    cmp     eax, 0
    jl      .fail
    mov     [esp+12], dword str_out ; str
    call    swrite
    mov     eax, esp
    add     eax, 16                 ; buf
    mov     [esp+12], eax           ; str
    call    swritelf
    jmp     .success
.fail:
    mov     [esp+12], dword str_fail ; str
    call    swritelf
.success:
    jmp     .next
.final:
    ; deallocate stack (buffer and arguments)
    add     esp, nbyte + 16
    ; quit
    call    quit
epilog:
    mov     esp, ebp
    pop     ebp
