// Libc call printf.

.global main
.global printf

.text
main:
    stp x29, x30, [sp, #-16]!   // store stack and frame pointer
    mov x29, sp                 // update frame pointer
    adr x0, format              // format
    mov x1, #42                 // lu
    bl  printf                  // call printf
    ldp x29, x30, [sp], #16     // restore stack and frame pointer
    ret

.data
format:
    .asciz  "The (not so) secret number is %lu!\n"

