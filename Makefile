all: gcut

gcut: graph.h block.h energy.h
	mex mexEnergyMin.cpp

clean:
	/bin/rm *.mexa64
