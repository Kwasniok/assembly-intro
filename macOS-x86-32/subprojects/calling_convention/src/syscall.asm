%ifndef _SYSCALL_ASM_
%define _SYSCALL_ASM_

; syscall op codes
%define SYSCALL         0
%define SYSCALL_EXIT    1

%macro syscall_exit 1
    ; asserts 16 byte aligned stack
    sub     esp, 16                 ; allocate space for arguments on stack
    mov     [esp+4], dword %1       ; exit status
    mov     eax, SYSCALL_EXIT       ; store opcode
    int     0x80                    ; perform system call
    add     esp, 16                 ; deallocate argument space on stack
%endmacro

%endif ; %ifndef _SYSCALL_ASM_
