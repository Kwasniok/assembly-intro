; target: MAC OS 10.7 or higher, MACH-O, i386, little endian
; calling convention: cdecl-like, 16 byte aligned

; note: Some macros assert the stack to be 16 byte aligned!

%ifndef _SYSCALL_ASM_
%define _SYSCALL_ASM_

; syscall op codes
%define SYSCALL         0
%define SYSCALL_EXIT    1
%define SYSCALL_READ    3
%define SYSCALL_WRITE   4

;
%define STDIN  0
%define STDOUT 1
%define STDERR 2

%macro syscall_exit 1
    ; %1: reg32/imm32 - exit code
    ; void exit(int rval)
    ; asserts 16 byte aligned stack
    sub     esp, 16                 ; allocate space for arguments on stack
    mov     [esp+4], dword %1       ; exit status
    mov     eax, SYSCALL_EXIT       ; store opcode
    int     0x80                    ; perform system call
    add     esp, 16                 ; deallocate argument space on stack
%endmacro

%macro syscall_read 3
    ; %1: reg32/imm32 - fd
    ; %2: reg32/imm32 - cbuf
    ; %3: reg32/imm32 - nbyte
    ; user_ssize_t read(int fd, user_addr_t cbuf, user_size_t nbyte)
    ; asserts 16 byte aligned stack
    sub     esp, 16                 ; allocate space for arguments on stack
    mov     [esp+12], dword %3      ; nbyte
    mov     [esp+ 8], dword %2      ; cbuf
    mov     [esp+ 4], dword %1      ; fd
    mov     eax, SYSCALL_READ       ; store opcode
    int     0x80                    ; perform system call
    add     esp, 16                 ; deallocate argument space on stack
%endmacro

%macro syscall_write 3
    ; %1: reg32/imm32 - fd
    ; %2: reg32/imm32 - cbuf
    ; %3: reg32/imm32 - nbyte
    ; user_ssize_t write(int fd, user_addr_t cbuf, user_size_t nbyte)
    ; asserts 16 byte aligned stack
    sub     esp, 16                 ; allocate space for arguments on stack
    mov     [esp+12], dword %3      ; nbyte
    mov     [esp+ 8], dword %2      ; cbuf
    mov     [esp+ 4], dword %1      ; fd
    mov     eax, SYSCALL_WRITE      ; store opcode
    int     0x80                    ; perform system call
    add     esp, 16                 ; deallocate argument space on stack
%endmacro

%endif ; %ifndef _SYSCALL_ASM_
