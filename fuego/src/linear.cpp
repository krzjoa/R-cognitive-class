#include <RcppArrayFire.h>

// [[Rcpp::depends(RcppArrayFire)]]

using af::array;
using af::log;
using af::erfc;
using std::sqrt;
using std::exp;


// [[Rcpp::export]]
af::array squareMatrix(const RcppArrayFire::typed_array<f32>& x) {
  return af::matmulTN(x ,x);
}

