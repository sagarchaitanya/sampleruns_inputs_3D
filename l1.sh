#!/bin/bash
start=`date +%s`
for i in basic 563
do
datfile=${i}
T=300
mpirun -np 16 lmp_mpi < tensiletest_${datfile}_ll_${T}.lmp -l tensiletest_${datfile}_ll_${T}.log
#mpirun -np 8 lmp_mpi < tensiletest_${datfile}_zz_${T}.lmp -l tensiletest_${datfile}_zz_${T}.log
done

