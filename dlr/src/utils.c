#include "context.h"

/* @name C_compare_ptr
 * @title Check if two pointers are the same
 * @param x external pointer
 * @param y external pinter
 * @return logical: are pointers the same?
 */
SEXP C_compare_ptr(SEXP x, SEXP y){
  return Rf_ScalarLogical(R_ExternalPtrAddr(x) == R_ExternalPtrAddr(y));
}

/*
 * Get adjacency matrix for all the operations in the context
 */
SEXP C_adjacency_matrix(SEXP ctx){
 CAST_PTR(context, DlrContext, ctx);

 if (!context->head)
   return R_NilValue;

 SEXP adj_mat = PROTECT(allocMatrix(INTSXP, context->V, context->V));
 SEXP ops_names = PROTECT(allocVector(INTSXP, context->V));

 // Loop over all the ops
 struct Link *current_link = context->head;
 int current_index = 0;

 while(current_link){
   INTEGER(ops_names)[current_index] = current_link->contained->number;
   current_link = current_link->next;
   current_index++;

   // Loop over ops adjacencies


 }

 // Setting dimnaes
 SEXP dimnames = PROTECT(allocVector(VECSXP, 2));
 SET_VECTOR_ELT(dimnames, 0, ops_names);
 SET_VECTOR_ELT(dimnames, 1, ops_names);
 setAttrib(adj_mat, R_DimNamesSymbol, dimnames);

 UNPROTECT(3);
 return adj_mat;
}

