#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>

// Macros
#define CAST_PTR(output, struct_name, ptr) struct struct_name *output = (struct struct_name*) R_ExternalPtrAddr(ptr);

// Link
struct Link{
  struct Ops *contained;
  struct Link *next;
};
void _Link_finalizer(struct Link *link);
struct Link* create_Link(struct Ops *contained_ops, struct Link *next_link);
struct Link* last_link(struct Link *current_link);
int get_chain_length(struct Link* current_link);

// Ops
struct Ops{
  int number;
  struct DlrContext *context; // To clean whole the chain, if the real object is removed from R env
  SEXP R_ops; // R object. It may be a vector or function. If NULL, object is vitual
  SEXP R_paired_ops; // Paired Ops, such as function derivative
  struct Link *wrapper_in_context; // Pointer to the Link object, which wraps the curent Ops in the DlrContext
  struct Link *inputs_header;
  struct Link *outputs_header;
};

void _Ops_finalizer(SEXP ext);
struct Ops* create_Ops(int node_no, SEXP R_ops, SEXP R_paired_ops);
void add_input_Ops(struct Ops* ops, struct Ops* input_ops);
void add_output_Ops(struct Ops* ops, struct Ops* output_ops);
void free_chain(struct Ops* ops);
SEXP C_get_ops_number(SEXP ops_ptr);
SEXP C_get_input_ptr(SEXP ops_ptr);
SEXP C_get_output_ptr(SEXP ops_ptr);
SEXP C_get_object(SEXP ops_ptr);
SEXP C_get_paired_object(SEXP ops_ptr);

// DlrContext
struct DlrContext{
  int V;
  struct Link *head;
};

static void _DlrContext_finalizer(SEXP ext);
struct Ops* get_ops(SEXP DlrContext_ptr, SEXP number);
SEXP C_create_context();
SEXP C_register_ops(SEXP DlrContext_ptr, SEXP R_ops, SEXP R_paired_ops);
SEXP C_get_r_ops(SEXP DlrContext_ptr, SEXP number);
SEXP C_n_nodes(SEXP DlrContext_ptr);
SEXP C_get_all_ops(SEXP DlrContext_ptr);
SEXP C_get_all_ops_ptr(SEXP DlrContext_ptr);
SEXP C_show_graph(SEXP DlrContext_ptr);
SEXP C_add_input(SEXP node_ptr, SEXP input_ptr);
SEXP C_add_output(SEXP node_ptr, SEXP output_ptr);
SEXP C_get_inputs(SEXP ops_ptr);
SEXP C_get_outputs(SEXP ops_ptr);

// Utils
SEXP C_compare_ptr(SEXP x, SEXP y);
SEXP C_adjacency_matrix(SEXP ctx);

// Array

//' Initializing DLL library
//' * https://github.com/Rdatatable/data.table/blob/a8ec94484d2cc375d8295a94bacc5353576c238a/src/init.c
//' * https://github.com/randy3k/xptr/blob/master/src/xptr.c
//' * https://github.com/tidyverse/purrr/blob/master/src/init.c
//' * R_registerRoutines

// TODO: Check, if one can place struct definitions in the .c files instead of
// TODO: use one convention for asterisks
// placing the in the header file with declation in the particular files.
// See: https://stackoverflow.com/questions/180401/placement-of-the-asterisk-in-pointer-declarations
