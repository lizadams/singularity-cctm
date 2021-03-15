# singularity-cctm

Please obtain the following files from github using the git command:

git clone https://github.com/lizadams/singularity-cctm.git

This will create a directory named “singularity-cctm” and will contain the following:

singularity-cctm-liz.csh
gcc9.def
gcc9-ioapi.def
gcc9-cmaq-liz.def

Edit the singularity-cctm-liz.csh script to specify the paths on your machine to point to the input data. Comment out the third line.

set HOSTDATA  = /home/centos/CMAQv5.3.2_Benchmark_2Day_Input
set CONTAINER = $cwd/gcc9-cmaq-liz.sif
##set SCRIPTDIR = /home/centos/Scripts-CMAQ

Note: you can obtain the container from the following google drive, or, you can build the container using the definition files and by following the instructions below.

To run the container, execute the command.

./singularity-cctm-liz.csh |& tee ./singularity-cctm-liz.log

I believe it is set to run 4x4 or on 16 processors.

You can take a look at Carlie's documentation on how to modify the environment variables in the wrapper script here:
https://cjcoats.github.io/CMAQ-singularity/singularity-cmaq.html#dirs


The timings that I obtained for this build on 16 processors on a c5.9xlarge (36 cores) was 
840.23
807.1


I built this container using Ed Anderson's definition files, but put Carlie's run_cctm.csh inside the container, and that contains the mpirun command, so you should not need to have mpi loaded using the module load command to run the script.
To BUILD a new container singularity container using the definition files you need access to sudo.

Run the following commands: (note you may need to modify the path to singularity)

First, build the base container with the compiler and mpi layer
> sudo /usr/local/bin/singularity build gcc9.sif gcc9.def

Second, build the I/O API Layer
> sudo /usr/local/bin/singularity build gcc9-ioapi.sif gcc9-ioapi.def

Third, build the CMAQv5.3.2 Layer
>  sudo /usr/local/bin/singularity build gcc9-cmaq-liz.sif gcc9-cmaq-liz.def

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
