#include <Rcpp.h>
using namespace Rcpp;

// https://stackoverflow.com/questions/1114349/struct-inheritance-in-c


https://cran.r-project.org/doc/manuals/r-release/R-ints.html
https://www.geeksforgeeks.org/difference-structure-union-c/

// [[Rcpp::export]]
SEXP make_callable(SEXP x) {
  return x;
}


CLOSXP get_fun(SEXP x){
  typedef struct CLOSXP clos;
  return clos;
}

https://github.com/hadley/pryr/blob/master/src/typename.cpp
