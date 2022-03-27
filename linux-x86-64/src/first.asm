; first program

          global    _start

          section   .text
_start:   mov       rax, 1                  ; system call for write
          mov       rdi, 1                  ; file handle 1 is stdout
          mov       rbx, message + 4        ; store address in register rbx
          mov       rsi, rbx                ; address of string to output
          mov       rdx, 29                 ; number of bytes
          syscall                           ; invoke operating system to do the write
          mov       rax, 1
          mov       rdi, 1
          mov       rsi, 0x401000           ; random memory section
          mov       rdx, 32
          syscall                           ; print again
          mov       rax, 1
          mov       rdi, 1
          mov       rsi, $                  ; this memory section
          mov       rdx, 32
          syscall                           ; print again
          mov       rax, 1
          mov       rdi, 1
          mov       rsi, float0             ; float1 memory section
          mov       rdx, 8
          syscall                           ; print again
          mov       rax, 60                 ; system call for exit
          xor       rdi, rdi                ; exit code 0
          syscall                           ; invoke operating system to exit

          section   .data
message:  db        "SKIPHello, Worldiedo!", 10 , 0 , "hi234", 10
float0:   dq        1.64346012125e-32
