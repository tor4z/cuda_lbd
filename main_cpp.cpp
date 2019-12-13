#include <iostream>
#include <algorithm>
#include <ctime>

using namespace std;

#define N           1024
#define RADIUS      3
#define BLOCK_SIZE  16


void stencil_1d(int *in, int *out){
    int result;
    int i;
    int offset;

    for(i = 0; i < N; i++) {
        result = 0;
        for(offset = -RADIUS; offset <= RADIUS; offset++)
            result += in[i + offset];
        out[i] = result;
    }
}


void fill_ints(int *x, int n){
    fill_n(x, n, 1);
}


int main(void) {
    int *in, *out;
    int size = (N + 2 * RADIUS) * sizeof(int);
    clock_t start, end;

    in = (int*)malloc(size);
    fill_ints(in, N + 2 * RADIUS);

    out = (int*)malloc(size);
    fill_ints(out, N + 2 * RADIUS);

    start = clock();
    stencil_1d(in + RADIUS, out + RADIUS);
    end = clock();

    cout << "CPP Duration: " << end - start << "ms." << endl;

    free(in);
    free(out);
    return 0;
}
