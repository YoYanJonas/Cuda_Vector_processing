#include <stdio.h>
#include <fstream>
#include <iostream>


// for random initializing 
#include <stdlib.h>
#include <time.h>

// for memset
#include <cstring>



void sum_array_cpu_otherthings(int* a, int* b, int* c, long int size) {
    for (int j = 0; j < 10000; j++) {
        for (int i = 0; i < size; i++) {
            c[i] = a[i] + b[i];
            c[i] = 2 * c[i];
            c[i] = 2 * a[i] + 2 * b[i];
            c[i] = c[i] / 2;

        }
    }
}

int main() {
    clock_t start_cpu, end_cpu;
    double CLOCK_PER_SECOND = 1000000.0;
    start_cpu = clock();

    long int size = 1000000;
    int* h_a, * h_b, * h_c;
    long int NU_BYTES = size * sizeof( long int);

  


    h_a = (int*)malloc(NU_BYTES);
    h_b = (int*)malloc(NU_BYTES);
    h_c=(int*)malloc(NU_BYTES);

    srand(100);
    for (int i = 0; i < size; i++) {
        h_a[i] = (int)(rand() & 0xFF);
    }
    srand(102);
    for (int i = 0; i < size; i++) {
        h_b[i] = (int)(rand() & 0xFF);
    }


    sum_array_cpu_otherthings(h_a,h_b,h_c, size);

    printf("%d first value of a \n", h_a[0]);
    free(h_a);
    printf("%d first value of b \n", h_b[0]);
    free(h_b);
    printf("%d result of operation(must be a0+b0) \n", h_c[0]);
    free(h_c);

    end_cpu = clock();
    double time_taken = (end_cpu - start_cpu) / CLOCK_PER_SECOND;
    printf("The taken time for cpu is : %.8f \n", time_taken);
    return 0;
}