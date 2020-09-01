#include "context.h"

struct Ops;

void _Ops_finalizer(SEXP ext){
  // struct Ops *ptr = (struct Ops*) R_ExternalPtrAddr(ext);
  CAST_PTR(ops, Ops, ext);
  // If real object, remove whole chain
  // free_chain()
  // Temporary!!!!
  // Free(ops);
}

// This function should neve be called outside of the context
struct Ops* create_Ops(int node_no, SEXP R_ops, SEXP R_paired_ops){
  struct Ops* ops = (struct Ops*) calloc(1, sizeof(struct Ops));
  ops->number = node_no;
  ops->R_ops = R_ops;
  ops->R_paired_ops = R_paired_ops;
  return ops;
}

void add_input_Ops(struct Ops* ops, struct Ops* input_ops){
  if(!ops->inputs_header)
    ops->inputs_header = create_Link(input_ops, NULL);
  else
    ops->inputs_header->next = create_Link(input_ops, NULL);
}

void add_output_Ops(struct Ops* ops, struct Ops* output_ops){
  if(!ops->outputs_header)
    ops->outputs_header = create_Link(output_ops, NULL);
  else
    ops->outputs_header->next = create_Link(output_ops, NULL);
}

SEXP C_get_ops_number(SEXP ops_ptr){
  CAST_PTR(ptr, Ops, ops_ptr);
  return ScalarInteger(ptr->number);
}

SEXP C_get_input_ptr(SEXP ops_ptr){
  CAST_PTR(ops, Ops, ops_ptr);
  if (!ops->inputs_header)
    return R_NilValue;
  // Transform into the ExternalPointer
  SEXP new_ops_ptr = PROTECT(R_MakeExternalPtr(ops->inputs_header, R_NilValue, R_NilValue));
  R_RegisterCFinalizerEx(new_ops_ptr, _Ops_finalizer, TRUE);
  UNPROTECT(1);
  return new_ops_ptr;
}

SEXP C_get_output_ptr(SEXP ops_ptr){
  CAST_PTR(ops, Ops, ops_ptr);
  if (!ops->outputs_header)
    return R_NilValue;
  // Transform into the ExternalPointer
  SEXP new_ops_ptr = PROTECT(R_MakeExternalPtr(ops->outputs_header, R_NilValue, R_NilValue));
  R_RegisterCFinalizerEx(new_ops_ptr, _Ops_finalizer, TRUE);
  UNPROTECT(1);
  return new_ops_ptr;
}

/*
 * Get contained R object from Ops
 */
SEXP C_get_object(SEXP ops_ptr){
  CAST_PTR(ops, Ops, ops_ptr);
  return ops->R_ops;
}

SEXP C_get_paired_object(SEXP ops_ptr){
  CAST_PTR(ops, Ops, ops_ptr);
  return ops->R_paired_ops;
}

/*
 * Check, if operation is a root node
 * Node is a root node if it has no 'inputs'
 */
SEXP C_is_root(SEXP ops_ptr){
  CAST_PTR(ops, Ops, ops_ptr);
  return ScalarLogical((int) (ops->inputs_header == NULL));
}

// Free all the virtual objects from the inputs and their inputs
// It can be real object only
void free_chain(struct Ops* ops){
  // Check, if object is 'real'

  // free_chain recursively till reaching a real object
}
