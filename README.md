# singularity-cctm

Note: this requires that singularity is intalled
To install use the following command (requires 1.2 G of storage)

```
sudo yum update -y && \
    sudo yum install -y epel-release && \
    sudo yum update -y && \
    sudo yum install -y singularity-runtime singularity
```

you likely need to exit out of shell to get the path
Then check the version

```
singularity --version
```
    2.6.0-dist


Please obtain the following files from github using the git command:

git clone https://github.com/lizadams/singularity-cctm.git

This will create a directory named “singularity-cctm” and will contain the following:

```
singularity-cctm-liz.csh
applydiff
gcc9.def
gcc9-ioapi.def
gcc9-cmaq-liz.def
```

Edit the singularity-cctm-liz.csh script to specify the paths on your machine to point to the input data. Comment out the third line.

```
set HOSTDATA  = /home/centos/CMAQv5.3.2_Benchmark_2Day_Input
set CONTAINER = $cwd/gcc9-cmaq-liz.sif
##set SCRIPTDIR = /home/centos/Scripts-CMAQ
```

Note: you can obtain the container from the following google drive, or, you can build the container using the definition files and by following the instructions below.
https://drive.google.com/drive/u/1/folders/1HOEykpAhhbTU7tFjtrxcuh4yrOncFySP

To run the container, execute the command.

```
./singularity-cctm-liz.csh |& tee ./singularity-cctm-liz.log
```

I believe it is set to run 4x4 or on 16 processors.

You can take a look at Carlie's documentation on how to modify the environment variables in the wrapper script here:
https://cjcoats.github.io/CMAQ-singularity/singularity-cmaq.html#dirs


The timings that I obtained for this build on 16 processors on a c5.9xlarge (36 cores) was 
```
day 1: 840.23
day 2: 807.1
```


I built this container using Ed Anderson's definition files, but put Carlie's run_cctm.csh inside the container, and that contains the mpirun command, so you should not need to have mpi loaded using the module load command to run the script.
To BUILD a new container singularity container using the definition files you need access to sudo.

Run the following commands: (note you may need to modify the path to singularity)

First, build the base container with: compiler (g++ (GCC) 9.3.0), mpi layer (openmpi-3.1.4), netCDF (netcdf-c-4.7.1),
(netcdf-fortran-4.5.2), PnetCDF Version 1.11.2, 

> sudo singularity build gcc9.sif gcc9.def

(this step took 25 minutes)

Second, build the I/O API Layer


> sudo singularity build gcc9-ioapi.sif gcc9-ioapi.def

(this step took 2 minutes)

Third, build the CMAQv5.3.2 Layer

>  sudo singularity build gcc9-cmaq-liz.sif gcc9-cmaq-liz.def

Note, if there is a path at the top of the definition files such as:

```
Bootstrap: localimage
From: /home/centos/singularity_eanderso/gcc9.sif
```

Remove it, and use
```
Bootstrap: localimage
From: gcc9.sif
```

As long as the gcc9.sif container is in the directory that you are running the build command from, then it will find it, without the need for a full path.


Note: here are the Open MPI configuration details for this container build:

```

Open MPI configuration:
-----------------------
Version: 3.1.4
Build MPI C bindings: yes
Build MPI C++ bindings (deprecated): yes
Build MPI Fortran bindings: mpif.h, use mpi, use mpi_f08
MPI Build Java bindings (experimental): no
Build Open SHMEM support: yes
Debug build: no
Platform file: (none)

Miscellaneous
-----------------------
CUDA support: no
PMIx support: internal
 
Transports
-----------------------
Cisco usNIC: no
Cray uGNI (Gemini/Aries): no
Intel Omnipath (PSM2): no
Intel SCIF: no
Intel TrueScale (PSM): no
Mellanox MXM: no
Open UCX: no

OpenFabrics OFI Libfabric: no
OpenFabrics Verbs: no
Portals4: no
Shared memory/copy in+copy out: yes
Shared memory/Linux CMA: yes
Shared memory/Linux KNEM: no
Shared memory/XPMEM: no
TCP: yes
 
Resource Managers
-----------------------
Cray Alps: no
Grid Engine: no
LSF: no
Moab: no
Slurm: yes
ssh/rsh: yes
Torque: no
 
OMPIO File Systems
-----------------------
Generic Unix FS: yes
Lustre: no
PVFS2/OrangeFS: no

```

### Need to modifying this running singularity tutorial on pcluster for csh
https://qywu.github.io/2020/12/09/aws-slumr-pytorch.html

```
The installation requires Golang. It is better to follow the steps on the singularity github repo to install the latest version. Also, check the Install.md for details.

Note that we in a cluster now. We need to install for all the nodes in the cluster.

The following instructions are for amd.
These instructions may be better for CentOS, but I am not sure about how to install singularity on the compute nodes, and then have them not get terminated when idle in the queue.  It may be that we need to add the install commands to the parallel cluster config file, so the software is installed automatically.

https://github.com/hpcng/singularity/blob/master/INSTALL.md

# master's environment variable will affect 
# the compute node's environment variable
export VERSION=1.14.12 OS=linux ARCH=amd
export NUM_NODES=2

srun -N${NUM_NODES} wget -O /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz \
    https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz

srun -N${NUM_NODES} sudo tar -C /usr/local -xzf /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz

```
