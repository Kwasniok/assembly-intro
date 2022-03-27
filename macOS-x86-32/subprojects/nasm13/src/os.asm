; target: MAC OS 10.7 or higher, MACH-O, i386, little endian
; calling convention: cdecl-like, 16 byte aligned

%ifndef _OS_ASM_
%define _OS_ASM_

%include    "syscall.asm"

section .text
quit:
.prolog:
    ; must be accessed via `call`
    push    ebp                     ; store old base pointer (on stack)
    mov     ebp, esp                ; store current stack pointer (in ebp)
.begin:
    and     esp, 0xFFFFFFF8         ; align stack (8 bytes)
    syscall_exit 0
.epilog:
    mov     esp, ebp                ; restore stack pointer (from ebp)
    pop     ebp                     ; restore old base pointer (from stack)
    ret                             ; return

%endif ;  %ifndef _OS_ASM_
