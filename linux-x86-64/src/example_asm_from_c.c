// minimal programm which wraps around an assembly identity function

#include <inttypes.h>

int64_t asm_func(int64_t n);

int main() {
    return asm_func(42);
}
