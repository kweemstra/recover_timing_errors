SHELL = /bin/bash	# Needs to be defined

# This makefile takes care of the compilation of all the programs.
# Sourcefiles for the main programs are given by the capitalized filenames in the SRC directory

# The following programs are compiled by this makefile:

# ./SRC/XCORRS.F90 		-> ./BIN/Xcorrs
# ./SRC/BESSEL.F90 		-> ./BIN/Bessel
# ./SRC/GET_VEL.F90 		-> ./BIN/Get_vel
# ./SRC/GET_VEL_AND_ALPHA.F90 	-> ./BIN/Get_vel_and_alpha

# IMPORTANT NOTES: 

# The Capital fortran extensions are automatically preprocessed, which is neccessary in case of Macro's...

## Module command line options for compiling with ``gfortran'': 
# -J defines directory to store the modules. It also checks this directory for modules. (i.e. by the ``include'' statement)
### Module command line options for compiling with ``ifort'':
# -module defines directory to store the modules.
# -I defines directories that will be searched for modules, (i.e. by the ``include'' and ``use'' statements); there can be multiple -I statements

# -c flag makes sure the linking is not done until all the source scripts providing modules are compiled.
# Never only remove the .mod files in the MODULES directory! they are used...
# If you do remove them, make sure you also remove the corresponding object .o files, because the make utility checks if these oject files are updated (or not!)

######################################################################################################################
####################################################### COMPILER #####################################################
######################################################################################################################

#FOR=gfortran
FOR=mpif90
#FOR=mpiifort

######################################################################################################################
####################################################### COMPILER #####################################################
######################################################################################################################

#Variables
dO=./dierckx/OBJ
dS=./dierckx/SRC
dM=./dierckx/MOD

Dierckx = ${dO}/spgrid.o ${dO}/fpopsp.o ${dO}/fpbacp.o ${dO}/fpchec.o ${dO}/fpgrsp.o ${dO}/fpknot.o ${dO}/fprati.o ${dO}/fpdisc.o ${dO}/fpgivs.o ${dO}/fpsysy.o ${dO}/fpchep.o ${dO}/fpbspl.o ${dO}/fpspgr.o ${dO}/fpcyt1.o ${dO}/fprota.o ${dO}/fpcyt2.o ${dO}/fpback.o ${dO}/bispev.o ${dO}/fpbisp.o

${dO}/%.o		: ${dS}/%.f
		${FOR} ${OPTFLAGS} -c $< -J${dM} -o $@

lapO=./lapacktest/OBJ
lapS=./lapacktest/SRC
lapM=./lapacktest/MOD

Lapsrc := $(notdir $(wildcard ${lapS}/*.f))
Lapobj := $(patsubst %.f,${lapO}/%.o,$(Lapsrc))

#$(info Lapsrc is $(Lapsrc))
#$(info Lapobj is $(Lapobj))

${lapO}/%.o		: ${lapS}/%.f
		${FOR} ${OPTFLAGS} -c $< -J${lapM} -o $@


######################################################################################################################
############################################## MAKE MAIN PROGRAMMES ##################################################
######################################################################################################################

# Directories
M = ./MOD
S = ./SRC
B = ./BIN
O = ./OBJ

# Libraries and their locations
SACLIBDIR=-L$(SACHOME)/lib
SACLIBS=-lsac -lsacio
SACMODS=-I$(SACHOME)/include
FFTWLIBS=-lm -lfftw3f -lfftw3   ## -lfftw3 is for double precision routines [default installation;'call dfftw(...)'], and -lfftw3f for single precision ['call sfftw(...)']
FFTWLIBDIR=-L/vardim/home/weemstra/lib/lib/
FFTWINCDIR=-I/vardim/home/weemstra/lib/fftw-3.3.4/api/         # Location fftw header file
#LAPACKLIBDIR=-L/opt/lapack361/
#LAPACKLIBDIR=-L/usr/lib64/
#LAPACKLIBS=-llapack -lblas
MKL=-Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_gf_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl

##### Flags
IFORTFLAGS=-g -Wall -fcheck bounds -ftraceback -fmax-errors=1 #-fcheck=all ##-fno-range-check
DEBUGFLAGS=-g -Wall -fbounds-check -fbacktrace -fmax-errors=1 #-fcheck=all ##-fno-range-check
OPTIONS=-ffree-line-length-none
OPTFLAGS=-funroll-all-loops -fpic -O3  #-fcheck=all
OPENMPFLAGS=-fopenmp
CPPFLAGS=-traditional-cpp

###################################### DEPENDENCIES OF MAIN PROGRAMS ON OBJECT FILES ###################################################

TIMING_ERR_INV_OBJECTS = $O/File_operations.o $O/Array_operations.o $O/Inverse.o $O/Geo_routines.o $O/Strings.o $O/Precision.o $O/Snr_routines.o $O/Return_taper.o $O/Cubspl.o $O/Ppvalu.o $O/Interv.o $O/LS_solutions.o

###################################### DEPENDENCIES OF MAIN PROGRAMS ON OBJECT FILES ###################################################

$B/Timing_err_inv		: $S/TIMING_ERR_INV.F90 ${TIMING_ERR_INV_OBJECTS}
			${FOR} $< ${TIMING_ERR_INV_OBJECTS} ${OPTIONS} ${MKL} ${SACLIBDIR} ${SACLIBS} ${SACMODS} ${DEBUGFLAGS} -I$M -o $@

$O/Array_operations.o		: $S/Array_operations.F90
			${FOR} -c $< ${DEBUGFLAGS} -J$M -o $@

$O/File_operations.o		: $S/File_operations.F90 $O/Strings.o
			${FOR} -c $< ${DEBUGFLAGS} -J$M -o $@

$O/Strings.o			: $S/Strings.F90 $O/Precision.o
			${FOR} -c $< ${DEBUGFLAGS} -J$M -o $@

$O/Precision.o			: $S/Precision.F90
			${FOR} -c $< ${DEBUGFLAGS} -J$M -o $@

$O/Inverse.o			: $S/Inverse.f $O/Geo_routines.o
			${FOR} -c $< ${DEBUGFLAGS} -J$M -o $@

$O/Geo_routines.o		: $S/Geo_routines.f
			${FOR} -c $< ${DEBUGFLAGS} -J$M -o $@

$O/Return_taper.o		: $S/Return_taper.F90
			${FOR} -c $< ${DEBUGFLAGS} -J$M -o $@

$O/Snr_routines.o		: $S/Snr_routines.F90
			${FOR} -c $< ${DEBUGFLAGS} -J$M -o $@

$O/Cubspl.o:			 $S/Cubspl.f90 $O/Ppvalu.o
			${FOR} -c $< ${OPTFLAGS} -o $@

$O/Ppvalu.o:			 $S/Ppvalu.f90 $O/Interv.o
			${FOR} -c $< ${OPTFLAGS} -o $@

$O/LS_solutions.o:		 $S/LS_solutions.f90
			${FOR} -c $< ${OPTFLAGS} -J$M -o $@

$O/Interv.o:		 	 $S/Interv.f90
			${FOR} -c $< ${OPTFLAGS} -o $@

clean				:
			rm $B/* $O/* $M/*
