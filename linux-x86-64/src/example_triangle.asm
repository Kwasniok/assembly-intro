; prints a triangle to stdout

; Prints BUF_SIZE - 1 lines individually by reusing the same buffer.
; For each line a newline is appended and the old one is turned into a star.

    global _start

; system constants
STDOUT:     equ     1
SYS_WRITE:  equ     1
SYS_EXIT:   equ     60
EXIT_OK:    equ     0
; program constants
STAR:       equ "*"
NL:         equ 10
BUF_SIZE:   equ 7


    section .bss
buffer:     resb BUF_SIZE


    section .text
_start:
print_triangle:
.init:
    mov     rdi, STDOUT
    mov     rsi, buffer     ; pointer to first char
    mov     r8, buffer      ; pointer to last char
    mov     rdx, 2          ; string size and counter
.loop:
; update buffer
    mov     byte [r8], STAR ; set second to last char to star
    inc     r8
    mov     byte [r8], NL   ; set last char to new line
; write line
    mov     rax, SYS_WRITE
    syscall
.inc:
    inc     rdx
.until:
    cmp     rdx, BUF_SIZE ; reached end of buffer?
    jle     .loop
exit:
    mov     rax, SYS_EXIT
    mov     rdi, EXIT_OK
    syscall

