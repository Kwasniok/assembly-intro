; target: MAC OS 10.7 or higher, MACH-O, i386
; description: showcase for calling convention (x86, cdecl, 16 byte aligned)

%include    "os.asm"

section .text
global start
start:
    call simple
    call caller
    call quit

section .text
simple:
; void simple(viod)
; does nothing
; basic operations of a function call
.prolog:
    ; must be accessed via `call`
    push    ebp                     ; store old base pointer (on stack)
    mov     ebp, esp                ; store current stack pointer (in ebp)
.begin:
    ; do nothing
.epilog:
    mov     esp, ebp                ; restore stack pointer (from ebp)
    pop     ebp                     ; restore old base pointer (from stack)
    ret                             ; return

section .text
caller:
; void caller(void)
; creates two local int32 and swaps their values
.prolog:
    ; must be accessed via `call`
    push    ebp                     ; store old base pointer (on stack)
    mov     ebp, esp                ; store current stack pointer (in ebp)
.begin:
    and     esp, 0xFFFFFFF0         ; align stack (16 bytes)
    sub     esp, 16                 ; allocate space for local variables
    mov     [esp+0], dword 0        ; int x0 = 0
    mov     [esp+4], dword 4        ; int x1 = 4
    sub     esp, 16                 ; allocate space for arguments on stack
    ; push arguments
    mov     [esp+4], dword esp      ; arg1: &x1
    add     [esp+4], dword 16+4     ; (add offset)
    mov     [esp+0], dword esp      ; arg0: &x0
    add     [esp+0], dword 16+0     ; (add offset)
    call    callee                  ; perform call
.epilog:
    mov     esp, ebp                ; restore stack pointer (from ebp)
    pop     ebp                     ; restore old base pointer (from stack)
    ret                             ; return

section .text
callee:
; void callee(int32* arg0, int32* arg1)
; swaps *arg0 and *arg1
.prolog:
    ; must be accessed via `call`
    push    ebp                     ; store old base pointer (on stack)
    mov     ebp, esp                ; store current stack pointer (in ebp)
    push    ebx                     ; store ebx (callee saved)
.begin:
    ; load args (adresses of ints)
    mov     eax, [ebp+8+0]
    mov     ecx, [ebp+8+4]
    ; load values (ints)
    mov     ebx, [eax]
    mov     edx, [ecx]
    ; store values swapped
    mov     [eax], edx
    mov     [ecx], ebx
.epilog:
    pop     ebx                     ; restore ebx (callee saved)
    mov     esp, ebp                ; restore stack pointer (from ebp)
    pop     ebp                     ; restore old base pointer (from stack)
    ret
