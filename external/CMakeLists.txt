include(ExternalProject)

## IMPORTANT NOTE
## YOU MAY WELL NEED TO ADJUST THESE FOR DIFFERENT PLATFORMS!!!

ExternalProject_Add( 
    scalapack
    URL ${CMAKE_SOURCE_DIR}/external/scalapack_installer.tgz
    BUILD_IN_SOURCE 1
    PREFIX ${CMAKE_SOURCE_DIR}/build
    CONFIGURE_COMMAND ""
    BUILD_COMMAND python <SOURCE_DIR>/scalapack_installer_1.0.2/setup.py  --downall --prefix=${CMAKE_SOURCE_DIR}/local
    INSTALL_COMMAND ""
)

ExternalProject_Add_Step(scalapack shared
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/local/lib
    COMMAND . ../../scripts/mkshared.sh gfortran librefblas.a librefblas${CMAKE_SHARED_LIBRARY_SUFFIX} ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS}
    COMMAND . ../../scripts/mkshared.sh gfortran libreflapack.a libreflapack${CMAKE_SHARED_LIBRARY_SUFFIX} ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS} -L.. -lrefblas
    COMMAND . ../../scripts/mkshared.sh gfortran libtmg.a libtmg${CMAKE_SHARED_LIBRARY_SUFFIX} ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS} -L.. -lreflapack -lrefblas
    COMMAND . ../../scripts/mkshared.sh mpif77 libscalapack.a libscalapack${CMAKE_SHARED_LIBRARY_SUFFIX} ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS} -L.. -lreflapack -lrefblas
    DEPENDEES install
)

ExternalProject_Add(
    gsl-1.15
    URL ${CMAKE_SOURCE_DIR}/external/gsl-1.15.tar.gz
    BUILD_IN_SOURCE 1
    PREFIX ${CMAKE_SOURCE_DIR}/build
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_SOURCE_DIR}/local
    BUILD_COMMAND make 
    INSTALL_COMMAND make install
)

ExternalProject_Add(
    fftw-3.3.2
    URL ${CMAKE_SOURCE_DIR}/external/fftw-3.3.2.tar.gz
    BUILD_IN_SOURCE 1
    PREFIX ${CMAKE_SOURCE_DIR}/build
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_SOURCE_DIR}/local --enable-mpi --enable-shared --disable-fortran
    BUILD_COMMAND make 
    INSTALL_COMMAND make install
)

## YOU WILL NEED TO ADD IN ARMCI CONFIG OPTIONS ON A REAL HPC SYSTEM
ExternalProject_Add(
    ga-5-1-1
    URL ${CMAKE_SOURCE_DIR}/external/ga-5-1-1.tgz
    BUILD_IN_SOURCE 1
    PREFIX ${CMAKE_SOURCE_DIR}/build
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_SOURCE_DIR}/local --with-blas=-lrefblas --with-lapack=-lreflapack --with-scalapack=-lscalapack 
    BUILD_COMMAND make 
    INSTALL_COMMAND make install
)

ExternalProject_Add_Step(ga-5-1-1 shared
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/local/lib
    COMMAND . ../../scripts/mkshared.sh mpicc libarmci.a libarmci${CMAKE_SHARED_LIBRARY_SUFFIX} ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS} -lgfortran 
    COMMAND . ../../scripts/mkshared.sh mpicc libga.a libga${CMAKE_SHARED_LIBRARY_SUFFIX} ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS} -lrefblas -lreflapack -lscalapack -lgfortran
    DEPENDEES install
)

