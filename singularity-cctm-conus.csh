#!/bin/csh -f

# ===================== Singularity "Run CCTM" Script =========================
#   Not for batch use on "longleaf.unc.edu" etc. servers (see ../Scripts-BATCH)
#*********************************************************************
# Data directory on host:  mounts onto container-directory "/opt/CMAQ_532/data"

set HOSTDATA  = /home/centos/CONUS
set CONTAINER = $cwd/gcc9-cmaq-liz.sif
#set SCRIPTDIR = /home/centos/Scripts-CMAQ

#   Set up environment for MPI-version ("mpich", "mvapich", or "openmpi"),
#   verbose-level and/or debug:

setenv SINGULARITYENV_CTM_DIAG_LVL  2
setenv SINGULARITYENV_MPIVERSION   openmpi

unsetenv SINGULARITYENV_DEBUG
unsetenv SINGULARITYENV_EXEC

setenv SINGULARITYENV_APPEND_PATH /usr/local/src/ioapi-3.2/Linux2_x86_64

# setenv SINGULARITYENV_DEBUG   1
# setenv SINGULARITYENV_EXEC    <path to debug-executable>

#  For CMAQ-option control-variables such as CONC_SPCS, CTM_MAXSYNC, KZMIN, etc.,
#  you should follow the pattern below, which has the effect of doing a
# "setenv FOO BAR" within the container-environment:
#
# setenv SINGULARITYENV_FOO  BAR
#
# "Normal" run-control variables follow a similar pattern:

setenv SINGULARITYENV_START_DATE    "2015-12-22"
setenv SINGULARITYENV_END_DATE      "2015-12-22"
setenv SINGULARITYENV_START_TIME    000000
setenv SINGULARITYENV_RUN_LENGTH    240000
setenv SINGULARITYENV_TIME_STEP      10000
setenv SINGULARITYENV_APPL          12US2
setenv SINGULARITYENV_EMIS          2016fh
setenv SINGULARITYENV_PROC          mpi
setenv SINGULARITYENV_NPCOL         8
setenv SINGULARITYENV_NPROW         4
setenv SINGULARITYENV_NZ            35
setenv SLURM_CPUS_ON_NODE 1
setenv SINGULARITYENV_YYYYMM        201512
setenv SINGULARITYENV_CTM_ABFLUX    N
setenv SINGULARITYENV_CTM_BIOGEMIS      N
setenv SINGULARITYENV_CTM_OCEAN_CHEM    N

#mpirun -np 16 singularity -d exec \
singularity -d exec \
 --bind ${HOSTDATA}:/usr/local/src/CMAQ_REPO/data \
 ${CONTAINER} /usr/local/src/CMAQ_REPO/CCTM/scripts/run_cctm_singularity_conus.csh

set err_status = ${status}

if ( ${err_status} != 0 ) then
    echo ""
    echo "****************************************************************"
    echo "** Error for run_cctm.csh              **"
    echo "**    STATUS=${err_status}                                    **"
    echo "****************************************************************"
endif

exit( ${err_status} )

