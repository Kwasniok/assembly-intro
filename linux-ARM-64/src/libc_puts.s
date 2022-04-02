// Libc call puts.

.global main
.global puts

.text
main:
    stp x29, x30, [sp, #-16]!   // store stack and frame pointer
    mov x29, sp                 // update frame pointer
    adr x0, message             // buffer
    bl  puts                    // call puts
    ldp x29, x30, [sp], #16     // restore stack and frame pointer
    ret

.data
message:
    .asciz  "Hello there!"

