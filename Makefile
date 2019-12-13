NVCC := nvcc
CC   := g++


.PHONY: clean all cpp_out cuda_out


all: cpp_out cuda_out

cpp_out: main_cpp.cpp
	$(CC) main_cpp.cpp -o cpp.out

cuda_out: main_cuda.cu
	$(NVCC) main_cuda.cu -o cuda.out

clean:
	rm -rf *.out
