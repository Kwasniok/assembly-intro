// Example programm which calls the float vector functions defined in assembly.

#include <inttypes.h>
#include <stdio.h>

double sum(uint64_t n, double* v);
double avg(uint64_t n, double* v);

int main(int argc, char** argv) {
    // define vector
    double values[] = {
        1.0,
        2.0,
        3.0,
        4.0,
        5.0,
        6.0,
        7.0,
        8.0,
        9.0,
        10.0,
        11.0,
        12.0,
        13.0,
    };
    // call functions with varying vector size
    for (uint64_t i = 0; i < sizeof(values) / sizeof(double) + 1; ++i) {
        double total = sum(i, (double*) &values);
        double average = avg(i, (double*) &values);
        printf("%lu, %f, %f\n", i, total, average);
    }
    return 0;
}
