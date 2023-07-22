
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


#include <stdio.h>


// for random initializing 
#include <stdlib.h>
#include <time.h>

// for memset
#include <cstring>


//functions
__global__ void sum_array_cpu_otherthings(int * a, int * b , int * c, long int size)
{
    int gid = blockIdx.x * blockDim.x + threadIdx.x;
    for (int j = 0; j < 10000; j++) {
        if (gid < size) {
            c[gid] = a[gid] + b[gid];
        }
    }
}

/*void compare_arrays(int* a, int* b, long int size)
{
    for (int i = 0; i < size; i++)
    {
        if (a[i] != b[i])
        {
            printf("Arrays are different \n");
            printf("%d - %d | %d \n", i, a[i], b[i]);
            return;
        }
    }
    printf("Arrays are same \n");
}
*/

int main()
{

    //for time measurements
    clock_t start_gpu, end_gpu;
    double CLOCK_PER_SECOND = 1000000.0;
    start_gpu = clock();

    long int size = 1000000;
    int block_size= 128;

    long int NU_BYTES= size * sizeof(long int);

    // host pointers
    int *h_a ,*h_b ,*gpu_results;

    // allocating
    h_a=(int*)malloc(NU_BYTES);
    h_b=(int*)malloc(NU_BYTES);
    // h_c=(int*)malloc(NU_BYTES);
    gpu_results=(int*)malloc(NU_BYTES); 

    //initializing a and b array randomly.
    srand(100);
    for (int i = 0; i < size; i++) {
        h_a[i] = (int)(rand() & 0xFF);
    }
    srand(102);
    for (int i = 0; i < size; i++) {
        h_b[i] = (int)(rand() & 0xFF);
    }


    // sum_array_cpu(h_a,h_b,h_c, size);
    memset(gpu_results, 0, NU_BYTES);

    // device pointer 
    int *d_a,*d_b, *d_c;
    cudaMallocManaged((int **)&d_a, NU_BYTES);
    cudaMallocManaged((int **)&d_b, NU_BYTES);
    cudaMallocManaged((int **)&d_c, NU_BYTES);

    // transfering data
    cudaMemcpy(d_a,h_a, NU_BYTES, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,h_b, NU_BYTES, cudaMemcpyHostToDevice);


    //grid defineing
    dim3  block(block_size);
    dim3 grid((size/block.x)+1); // one more thread to not getting error and guaranteeing having enough threads


    // running and transfering back
    sum_array_cpu_otherthings<<<grid,block>>>(d_a,d_b,d_c,size);
    cudaDeviceSynchronize();

    cudaMemcpy(gpu_results, d_c, NU_BYTES, cudaMemcpyDeviceToHost);

    // array comparing results.
    //compare_arrays(gpu_results, h_c, size);
    
    // freeing memories
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    printf("%d first value of a \n", h_a[0]);
    free(h_a);
    printf("%d first value of b \n", h_b[0]);
    free(h_b);
    printf("%d result of operation(must be a0+b0) \n", gpu_results[0]);
    free(gpu_results);

    end_gpu = clock();
    double time_taken = (end_gpu - start_gpu) / CLOCK_PER_SECOND;
    printf("The taken time for cpu is : %.8f \n", time_taken);

    return 0;

}
