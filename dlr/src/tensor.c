#include <R.h>
#include <Rinternals.h>

typedef struct tensor {
  int* dim;
  double* array;
} Tensor;

typedef struct variable {
   Tensor tens;
   Tensor gradient;
} Variable;


// Deklaracja tensora zawiera sprawdzenie wielkości!

// https://tiehu.is/blog/c1
// https://pl.wikibooks.org/wiki/C/Preprocesor
// https://stackoverflow.com/questions/10225098/understanding-exactly-when-a-data-table-is-a-reference-to-vs-a-copy-of-another
// https://github.com/pytorch/pytorch/tree/master/aten/src/ATen
// https://codereview.stackexchange.com/questions/159301/matrices-in-c-implementation
// https://gist.github.com/nadavrot/5b35d44e8ba3dd718e595e40184d03f0

SEXP create_tensor(int dims){
   struct tensor new_Tensor;
   new_Tensor.dim = dims;
   new_Tensor.array = {1.,2.,3.,4.,5.};
   return new_Tensor;
}



