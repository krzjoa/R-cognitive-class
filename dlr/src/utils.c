#include "context.h"

/*
 * Check if two pointers are the same
 * @param x external pointer
 * @param y external pinter
 * @return logical: are pointers the same?
 */
SEXP C_compare_ptr(SEXP x, SEXP y){
  return Rf_ScalarLogical(R_ExternalPtrAddr(x) == R_ExternalPtrAddr(y));
}
