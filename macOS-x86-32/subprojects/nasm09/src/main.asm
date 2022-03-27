; target: MAC OS 10.7 or higher, MACH-O, i386
; description: ask for and print name program

%include    "quit.nasm"
%include    "str.nasm"

section .data ; initialized storage
; db pseudo-op: store byte array
msg1:       db      "Please enter your name: ", 0
msg2:       db      "Hello, ", 0

section .bss  ; uninitialized storage (Block Started by Symbol)
; resX N pseudo.op: reserve storage for N units of X
; X    | b    | w    | d           | q                      | t
; unit | byte | word | double word | quad word/double float | extended float
sinput:     resb    255             ; reserve space of 255 bytes

section .text
global start
start:
.promt:
    ; print promt
    mov     eax, msg1
    call    sprint
.sys_read:
    ; get input
    ; perform system call (sys_read)
    ; c pseudo code declaration:
    ;     user_ssize_t read(int fd, user_addr_t cbuf, user_size_t nbyte)
    ; push arguments from right to left
    push    255
    push    sinput
    push    0
    sub     esp, 4                  ; align to 8 bytes
    mov     eax, 3                  ; opcode for sys_read
    int     0x80
    add esp, 16                     ; pop stack
.print:
    ; print response message
    mov     eax, msg2
    call    sprint
    mov     eax, sinput
    call    sprint
.quit:
    ; quit
    call    quit
