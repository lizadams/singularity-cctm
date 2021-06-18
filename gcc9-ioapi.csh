#!/bin/csh -f
set echo

#  --------------------------------------
#  Add /usr/local/lib to the library path
#  --------------------------------------
#   if [ -z ${LD_LIBRARY_PATH} ]
#   then
#      export LD_LIBRARY_PATH=/usr/local/lib
#   else
#      export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
#   fi
#  ----------------------
#  Unpack and build IOAPI
#  ----------------------
   cd /shared/build
   git clone https://github.com/cjcoats/ioapi-3.2
   cd ioapi-3.2
   git checkout -b 20200828
#  -------------------------------------------
#  Add -fPIC so we can create a shared library
#  and disable openmp because not used in CMAQ
#  
#   -------------------------------------------
   cd ioapi
   setenv BIN Linux2_x86_64
   mkdir ../$BIN
   setenv BASEDIR /shared/build/ioapi-3.2
   setenv HOME /shared/build
   cat >fpicfix <<EOF
27c27
< MFLAGS    = -fPIC -m64
---
> MFLAGS    = -ffast-math -funroll-loops -m64  #  -Wall -Wsurprising -march=native -mtune=native
29,30c29,30
< OMPFLAGS  = # -fopenmp
< OMPLIBS   = # -fopenmp
---
> OMPFLAGS  = -fopenmp
> OMPLIBS   = -fopenmp
40,41c40,41
<  -DNEED_ARGS=1 \
<  -DIOAPI_NCF4=1
---
>  -DNEED_ARGS=1
> PARFLAGS  =
EOF
   /shared/build/singularity-cctm/applydiff Makeinclude.Linux2_x86_64 fpicfix -R
   #cd ..
   cp Makefile.nocpl Makefile
   make >& make.ioapi.log
   cd ..
   cd m3tools
   cp Makefile.nocpl Makefile
   make >& make.m3tools
   cd ..
   mkdir lib bin
   cd Linux2_x86_64
   mv * ../bin
   cd ../bin
   mv *.o *.mod ../Linux2_x86_64
   mv *.a ../lib
   cd ../Linux2_x86_64
   ls -1 ../bin | xargs -I % sh -c 'ln -s ../bin/% %'
   cd ../Linux2_x86_64
   ln -s ../lib/libioapi.a
   cd ..
   sudo cp -p bin/* /shared/build/ioapi-3.2/bin
   sudo cp -p lib/* /shared/build/ioapi-3.2/lib
   sudo cp -p Linux2_x86_64/*.mod /shared/build/ioapi-3.2/include
#  -------------------------------------------------------
#  Only crusty old fixed source code should need the IOAPI
#  EXT files. Newer code should be USE-ing a module.
#  -------------------------------------------------------
   sudo cp -p ioapi/fixed_src/*.EXT /shared/build/ioapi-3.2/include

#Note: when I tried to use m3diff, it complained
#m3diff: error while loading shared libraries: libgfortran.so.5: cannot open shared object file: No such file or directory
#used the following command:
# find /usr -name libgfortran.so.5
#it found /usr/local/lib64/libgfortran.so.5

#Added this to my .chsrc
#setenv LD_LIBRARY_PATH ${OPENMPI_LIB}/lib:/usr/local/lib:/usr/local/lib/openmpi:/usr/local/lib64
#now m3diff works

