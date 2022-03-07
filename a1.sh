#!/bin/bash
start=`date +%s`
for i in 563
do
datfile=${i}
T=300
#mpirun -np 8 lmp_mpi < tensiletest_${datfile}_ac_${T}.lmp -l tensiletest_${datfile}_ac_${T}.log
mpirun -np 16 lmp_mpi < tensiletest_${datfile}_zz_${T}.lmp -l tensiletest_${datfile}_zz_${T}.log
done

