# DIRECTORIES
maindir=fast_matched_filter
srcdir=$(maindir)/src
libdir=$(maindir)/lib

echo "Building fast_matched_filter in $(maindir) directory"

CC=gcc
NVCC=nvcc

all: $(libdir)/matched_filter_GPU.so $(libdir)/matched_filter_CPU.so $(maindir)/matched_filter.$(mex_extension)
python_cpu: $(libdir)/matched_filter_CPU.so
python_gpu: $(libdir)/matched_filter_GPU.so 
.SUFFIXES: .c .cu

# GPU FLAGS
COPTIMFLAGS_GPU=-O3
CFLAGS_GPU=-Xcompiler "-fopenmp -fPIC -march=native -ftree-vectorize" -Xlinker -lgomp
ARCHFLAG=-gencode=arch=compute_52,code=sm_52\
  			-gencode arch=compute_60,code=sm_60\
  			-gencode arch=compute_61,code=sm_61\
  			-gencode arch=compute_70,code=sm_70\
  			-gencode arch=compute_75,code=sm_75\
  			-gencode arch=compute_80,code=sm_80\
  			-gencode arch=compute_90,code=sm_90\
  			-gencode arch=compute_90,code=compute_90
LDFLAGS_GPU=--shared

# CPU FLAGS
COPTIMFLAGS_CPU=-O3
# -march=native can cause problems on some CPUs; remove if needed
CFLAGS_CPU=-fopenmp -fPIC -ftree-vectorize -march=native -std=gnu99
LDFLAGS_CPU=-shared

# build for python
$(libdir)/matched_filter_GPU.so: $(srcdir)/matched_filter.cu
	$(NVCC) $(COPTIMFLAGS_GPU) $(CFLAGS_GPU) $(ARCHFLAG) $(LDFLAGS_GPU) $< -o $@

$(libdir)/matched_filter_CPU.so: $(srcdir)/matched_filter.c
	$(CC) $(COPTIMFLAGS_CPU) $(CFLAGS_CPU) $(LDFLAGS_CPU) $< -o $@

clean:
	rm $(libdir)/*.so
