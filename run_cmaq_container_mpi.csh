#!/bin/csh -f

setenv NTASKS "16"

# this configuration depends on the host
setenv MPICH_ROOT "/opt/amazon/openmpi/"

setenv SINGULARITY_BINDPATH "$MPICH_ROOT"
setenv SINGULARITYENV_LD_LIBRARY_PATH "$MPICH_ROOT/lib:\$LD_LIBRARY_PATH"

# run CMAQ with MPI
mpirun -n $NTASKS \
  singularity exec gcc9-cmaq-hostmpi.sif \
  | tee log.cmaq.$NTASKS
