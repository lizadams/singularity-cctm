#!/bin/bash
#SBATCH --job-name singularity-mpi
#SBATCH -N 4 # total number of nodes
#SBATCH --time=00:05:00 # Max execution time

mpirun -n 4 singularity --bind /shared/build/singularity-cctm /opt exec /shared/build/singularity-cctm/ mpitest.openmpi.sif /opt/mpitest
