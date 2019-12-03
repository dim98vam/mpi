# define the shell to bash
SHELL := /bin/bash

# define the C/C++ compiler to use,default here is clang
CC = gcc-7
MPICC = mpicc
MPIRUN = mpirun 
INCLUDES= -I $(OPENBLAS_ROOT)/include
LINK=-L $(OPENBLAS_ROOT)/lib

all: library test_mpi clean

clean:
	rm knnring_mpiSynchronous.a knnring_mpiAsynchronous.a test_mpi test_sequential knnring.h

library:
	cd knnring; make lib; cd ..
	cd knnring; cp lib/*.a inc/knnring.h ../; cd .. 


test_sequential: library
        #tar -xvzf code.tar.gz
	$(MPICC) $(INCLUDES) tester.c knnring_mpiSynchronous.a -o $@ $(LINK) -lopenblas -lm
	./test_sequential


test_mpi:
	$(MPICC) $(INLCUDES) tester_mpi.c knnring_mpiSynchronous.a -o $@ $(LINK) -lopenblas -lm 
	$(MPIRUN) ./test_mpi 
	rm test_mpi 
	$(MPICC) $(INLCUDES) tester_mpi.c knnring_mpiAsynchronous.a -o $@ $(LINK) -lopenblas -lm
	$(MPIRUN) ./test_mpi 

