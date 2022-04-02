// Simple program to calculate some Fibonacci numbers.

.global main
.global printf

.text
main:
    stp     x29, x30, [sp, #-16]!   // store stack and frame pointer
    mov     x29, sp                 // update frame pointer
    mov     x20, #0                 // f(n-1)
    mov     x21, #1                 // f(n)
                                    // x22 : f(n+1)
    mov     x23, #1                 // n
.print:
    adr     x0, format              // format
    mov     x1, x23                 // n
    mov     x2, x21                 // f(n)
    bl      printf                  // call printf
.next:
    adds    x22, x21, x20           // f(n+1)
    add     x23, x23, #1            // increment n
    mov     x20, x21                // next f(n-1)
    mov     x21, x22                // next f(n)
    b.vc    .print                  // loop if no overflow occurred (oVerflow flag is Clear)
.ret:
    ldp     x29, x30, [sp], #16     // restore stack and frame pointer
    ret

.data
format:
    .asciz  "f(%lu) = %lu\n"

