# paste(list.files("/opt/intel/mkl/lib/intel64/", pattern = "lib"), collapse = ":")

#Sys.setenv(LD_PRELOAD="/opt/arrayfire/lib64/libmkl_core.so:/usr/lib/x86_64-linux-gnu/libtbb.so.2:/opt/arrayfire/lib64/libmkl_mc3.so:/opt/arrayfire/lib64/libmkl_def.so")
#Sys.setenv(LD_PRELOAD=paste(list.files("/opt/intel/mkl/lib/intel64/", pattern = "lib", full.names = TRUE), collapse = ":"))
#Sys.setenv(LD_PRELOAD="/opt/intel/mkl/lib/intel64/libmkl_core.so:/usr/lib/x86_64-linux-gnu/libtbb.so.2:/opt/intel/mkl/lib/intel64/libmkl_tbb_thread.so:/opt/intel/mkl/lib/intel64/libmkl_mc3.so:/opt/intel/mkl/lib/intel64/libmkl_def.so")

anRpackage::rcpparrayfire_innerproduct(1:20)


# Trzeba wyeksportować "z ręki"
# export LD_PRELOAD="/opt/intel/mkl/lib/intel64/libmkl_core.so:/usr/lib/x86_64-linux-gnu/libtbb.so.2:/opt/intel/mkl/lib/intel64/libmkl_tbb_thread.so:/opt/intel/mkl/lib/intel64/libmkl_mc3.so:/opt/intel/mkl/lib/intel64/libmkl_def.so"

# Sys.setenv("LD_PRELOAD"="/opt/intel/mkl/lib/intel64/libmkl_core.so:/usr/lib/x86_64-linux-gnu/libtbb.so.2:/opt/intel/mkl/lib/intel64/libmkl_tbb_thread.so:/opt/intel/mkl/lib/intel64/libmkl_mc3.so:/opt/intel/mkl/lib/intel64/libmkl_def.so")
# Sys.getenv("LD_PRELOAD")
#
# system('export LD_PRELOAD="/opt/intel/mkl/lib/intel64/libmkl_core.so:/usr/lib/x86_64-linux-gnu/libtbb.so.2:/opt/intel/mkl/lib/intel64/libmkl_tbb_thread.so:/opt/intel/mkl/lib/intel64/libmkl_mc3.so:/opt/intel/mkl/lib/intel64/libmkl_def.so"')
#
# N <- 40
# X <- matrix(rnorm(N * N * 2), ncol = N)
#
# src <- '
# af::array squareMatrix(const RcppArrayFire::typed_array<f32>& x) {
#     return af::matmulTN(x ,x);
# }'
#
# myplugin <- inline::getPlugin("Rcpp")
# myplugin$env$LD_PRELOAD <- "/opt/intel/mkl/lib/intel64/libmkl_core.so:/usr/lib/x86_64-linux-gnu/libtbb.so.2:/opt/intel/mkl/lib/intel64/libmkl_tbb_thread.so:/opt/intel/mkl/lib/intel64/libmkl_mc3.so:/opt/intel/mkl/lib/intel64/libmkl_def.so"
# Rcpp::cppFunction(code = src, depends = "RcppArrayFire", plugins = myplugin)
#
# tXXGPU <- squareMatrix(X)
# print(tXXGPU)
