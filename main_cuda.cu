#include <iostream>
#include <algorithm>
#include <ctime>

using namespace std;

#define N           100000
#define RADIUS      3
#define BLOCK_SIZE  16


__global__ void stencil_1d(int *in, int *out){
    __shared__ int temp[BLOCK_SIZE + 2 * RADIUS];
    int gindex = threadIdx.x + blockIdx.x * blockDim.x;
    int lindex = threadIdx.x + RADIUS;

    temp[lindex] = in[gindex];
    if(threadIdx.x < RADIUS) {
        temp[lindex - RADIUS] = in[gindex - RADIUS];
        temp[lindex + BLOCK_SIZE] = in[gindex + BLOCK_SIZE];
    }

    __syncthreads();

    int result = 0;
    for(int offset = -RADIUS; offset <= RADIUS; offset++)
        result += temp[lindex + offset];
    
    out[gindex] = result;
}


void fill_ints(int *x, int n){
    fill_n(x, n, 1);
}


int main(void) {
    int *in, *out;
    int *d_in, *d_out;
    clock_t start, end;
    int size = (N + 2 * RADIUS) * sizeof(int);

    in = (int*)malloc(size);
    fill_ints(in, N + 2 * RADIUS);

    out = (int*)malloc(size);
    fill_ints(out, N + 2 * RADIUS);

    cudaMalloc((void**)&d_in, size);
    cudaMalloc((void**)&d_out, size);

    cudaMemcpy(d_in, in, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_out, out, size, cudaMemcpyHostToDevice);

    start = clock();
    stencil_1d<<<N/BLOCK_SIZE, BLOCK_SIZE>>>(d_in + RADIUS, d_out + RADIUS);
    end = clock();
    cudaMemcpy(out, d_out, size, cudaMemcpyDeviceToHost);

    cout << "CUDA Duration: " << end - start << "ms." << endl;

    free(in);
    free(out);
    cudaFree(d_in);
    cudaFree(d_out);
    return 0;
}
