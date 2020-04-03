#include <R.h>
#include <Rinternals.h>

//typedef struct tensor {
//  int* dim;
//  double* array;
//} Tensor;

//typedef struct variable {
//   Tensor tsr;
//   Tensor gradient;
//} Variable;


// Deklaracja tensora zawiera sprawdzenie wielkości!

// https://tiehu.is/blog/c1
// https://pl.wikibooks.org/wiki/C/Preprocesor
// https://stackoverflow.com/questions/10225098/understanding-exactly-when-a-data-table-is-a-reference-to-vs-a-copy-of-another
// https://github.com/pytorch/pytorch/tree/master/aten/src/ATen
// https://codereview.stackexchange.com/questions/159301/matrices-in-c-implementation
// https://gist.github.com/nadavrot/5b35d44e8ba3dd718e595e40184d03f0
// https://colinfay.me/writing-r-extensions/the-r-api-entry-points-for-c-code.html
// https://github.com/USCbiostats/software-dev/wiki/Structures-and-pointers-with-Rcpp
// http://lists.r-forge.r-project.org/pipermail/rcpp-devel/2013-July/006249.html
// https://github.com/wch/r-source/blob/5a156a0865362bb8381dcd69ac335f5174a4f60c/src/main/dstruct.c


// R_registerRoutines
// https://github.com/tidyverse/purrr/blob/master/src/init.c

SEXP tensor_sum(SEXP tensor){
   SEXP result = PROTECT(allocVector(REALSXP, 1));
   REAL(result)[0] = REAL(tensor)[1];
   UNPROTECT(1);
   return result;
}


