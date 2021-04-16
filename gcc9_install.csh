#!/bin/csh -f

#  ---------------------------
#  Build and install gcc 9.3.0
#  ---------------------------
cd /home/centos/build
GCC_VERSION=9.3.0
wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
tar xzvf gcc-${GCC_VERSION}.tar.gz
mkdir obj.gcc-${GCC_VERSION}
cd gcc-${GCC_VERSION}
./contrib/download_prerequisites
cd ../obj.gcc-${GCC_VERSION}
../gcc-${GCC_VERSION}/configure --disable-multilib
make -j $(nproc)
sudo make install

#  -----------------------
#  Download and build HDF5
#  -----------------------
   cd /home/centos/build
   wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz
   tar xvf hdf5-1.10.5.tar.gz
   rm -f hdf5-1.10.5.tar.gz
   cd hdf5-1.10.5
   export CFLAGS="-O3"
   export FFLAGS="-O3"
   export CXXFLAGS="-O3"
   export FCFLAGS="-O3"
   ./configure --prefix=/usr/local --enable-fortran --enable-cxx --enable-shared --with-pic
   make > make.gcc9.log 2>&1
#  make check > make.gcc9.check
   make install
#  ---------------------------
#  Download and build netCDF-C
#  ---------------------------
   cd /home/centos/build
   wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.1.tar.gz
   tar xvf netcdf-c-4.7.1.tar.gz
   rm -f netcdf-c-4.7.1.tar.gz
   cd netcdf-c-4.7.1
   ./configure --with-pic --with-hdf5=/home/centos/build/hdf5-1.10.5/hdf5/ --enable-netcdf-4 --enable-shared --prefix=/usr/local
configure: error: curl required for remote access. Install curl or build with --disable-dap.
   ./configure --with-pic --enable-netcdf-4 --enable-shared --disable-dap --prefix=/usr/local
configure: error: Can't find or link to the hdf5 library. Use --disable-netcdf-4, or see config.log for errors.
   ended up using:
 ./configure --with-pic --disable-netcdf-4 --enable-shared --disable-dap --prefix=/usr/local
   make > make.gcc9.log 2>&1
   sudo make install
#  ---------------------------------
#  Download and build netCDF-Fortran
#  ---------------------------------
   cd /home/centos/build
   wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.2.tar.gz
   tar xvf netcdf-fortran-4.5.2.tar.gz
   rm -f netcdf-fortran-4.5.2.tar.gz
   cd netcdf-fortran-4.5.2
   export LIBS="-lnetcdf"
   ./configure --with-pic --enable-shared --prefix=/usr/local

got error: checking size of off_t... configure: error:
edited .cshrc to add path to /usr/local/lib where netcdf-c was installed`

   make > make.gcc9.log 2>&1
   make install
#  -----------------------------
#  Download and build netCDF-CXX
#  -----------------------------
   cd /home/centos/build
   wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx4-4.3.1.tar.gz
   tar xvf netcdf-cxx4-4.3.1.tar.gz
   rm -f netcdf-cxx4-4.3.1.tar.gz
   cd netcdf-cxx4-4.3.1
   ./configure --with-pic --enable-shared --prefix=/usr/local

getting error:
configure: error: netcdf.h could not be found. Please set CPPFLAGS.
   make > make.gcc9.log 2>&1
   make install
#  --------------------------
#  Download and build OpenMPI
#  --------------------------
   cd /home/centos/build
   wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.4.tar.gz
   tar xvf openmpi-3.1.4.tar.gz
   rm -f openmpi-3.1.4.tar.gz
   cd openmpi-3.1.4
   export CFLAGS="-O3"
   export FFLAGS="-O3"
   export CXXFLAGS="-O3"
   export FCFLAGS="-O3"
used C shell
   setenv CFLAGS -O3
   setenv FFLAGS -O3
   setenv CXXFLAGS -O3
   setenv FCFLAGS -O3
   sudo ./configure --prefix=/usr/local --enable-mpi-cxx
   make > make.gcc9.log 2>&1
#  make check > make.gcc9.check
   sudo make install
add to LD_LIBRARY_PATH
setenv LD_LIBRARY_PATH ${OPENMPI_LIB}/lib:/usr/local/lib:/usr/local/lib/openmpi
#  ----------------------------------
#  Download and buildi Parallel netCDF
#  ----------------------------------
   cd /home/centos/build
   wget https://parallel-netcdf.github.io/Release/pnetcdf-1.11.2.tar.gz
   tar xvf pnetcdf-1.11.2.tar.gz
   rm -f pnetcdf-1.11.2.tar.gz
   cd pnetcdf-1.11.2
   export CFLAGS="-O3 -fPIC"
   export FFLAGS="-O3 -fPIC"
   export CXXFLAGS="-O3 -fPIC"
   export FCFLAGS="-O3 -fPIC"
   ./configure --prefix=/usr/local MPIF77=mpif90 MPIF90=mpif90 MPICC=mpicc MPICXX=mpicxx --with-mpi=/usr/local
   make > make.gcc9.log 2>&1
   make install
#  ----------------------------------------
#  Use tcsh 6.20 instead of the broken 6.21
#  ----------------------------------------
   cd /home/centos/build
   wget http://ftp.funet.fi/pub/mirrors/ftp.astron.com/pub/tcsh/old/tcsh-6.20.00.tar.gz
   tar xvf tcsh-6.20.00.tar.gz
   rm -f tcsh-6.20.00.tar.gz
   cd tcsh-6.20.00
   ./configure --disable-nls
   make > make.gcc9.log 2>&1
   make install
   #ln -s /usr/local/bin/tcsh /bin/csh
#  ----------------------
#  Download and build vim
#  ----------------------
   cd /home/centos/build
   git clone https://github.com/vim/vim.git vim
   cd vim
   ./configure
   make > make.gcc9.log 2>&1
   make install
   #cd /usr/local/bin
   #ln -s vim vi

# Test install
   whereis h5diff
   nc-config --version
   nf-config --version
   ncxx4-config --version
