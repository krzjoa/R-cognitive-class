# drat::addRepo("daqana")
# install.packages("RcppArrayFire")
#
# Sys.setenv(LD_PRELOAD="/usr/local/lib64/libmkl_core.so:/usr/local/lib64/libmkl_gnu_thread.so")
# Sys.setenv(LD_PRELOAD="/opt/arrayfire/lib64/libmkl_mc3.so:/opt/arrayfire/lib64/libmkl_gnu_thread.so")
#
# system("echo $LD_PRELOAD")

library(RcppArrayFire)
src <- '
double piAF (const int N) {
    array x = randu(N, f32);
    array y = randu(N, f32);
    return 4.0 * sum<float>(sqrt(x*x + y*y) < 1.0) / N;
}'
# Rcpp::cppFunction(code = src, depends = "RcppArrayFire", includes = "using namespace af;")
#
# RcppArrayFire::arrayfire_set_seed(42)
# cat("pi ~= ", piAF(10^6), "\n")
#
#
# set.seed(42)
# N <- 40
# X <- matrix(rnorm(N * N * 2), ncol = N)
# src <- '
# void dot() {
#     af::array in = af::randu(3,3);
#     af::array z = af::randu(3,1);
#     af::matmul(in, z);
# }'
# Rcpp::cppFunction(code = src, depends = "RcppArrayFire")
# dot()
#
#
#     src.2 <- '
# void dot2() {
#     af::array A = af::randu(3,3); // A : random 3x3 matrix
#     af::inverse(A); // IA: inverse of A
#     //af::matmul(A,IA)
#     //af_print(af::matmul(A,IA),0);
# }'
# Rcpp::cppFunction(code = src.2, depends = "RcppArrayFire")
# dot2()

anR
