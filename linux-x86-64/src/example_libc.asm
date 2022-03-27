; example program which uses a libc call

    global main
    extern puts

    section     .text
main:
    mov     rdi, message
    call    puts
    ret

    section .data
message:
    db      "Hello there!", 0

