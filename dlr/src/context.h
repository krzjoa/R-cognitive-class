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

// TODO: Check, if one can place struct definitions in the .c files instead of
// TODO: use one convention for asterisks
// placing the in the header file with declation in the particular files.
// See: https://stackoverflow.com/questions/180401/placement-of-the-asterisk-in-pointer-declarations


// Useful links
// ============================ Useful links ========================
  // http://lagodiuk.github.io/computer_science/2016/12/19/efficient_adjacency_lists_in_c.html
  // http://www.mathcs.emory.edu/~cheung/Courses/255/Syllabus/2-C-adv-data/dyn-array.html
  // https://www.geeksforgeeks.org/graph-and-its-representations/
  // https://cran.r-project.org/doc/manuals/R-exts.html#Garbage-Collection
  // https://www.programiz.com/dsa/graph-adjacency-list
  // https://www.sanfoundry.com/c-tutorials-mutually-dependent-structures/

  // https://homepage.divms.uiowa.edu/~luke/R/simpleref.html
  // https://marlin-na.github.io/r-api/pairlists/
  // https://wiki.r-consortium.org/view/Native_API_stats_of_Rinternals.h_without_USE_R_INTERNALS

  // Structures to handle computational graph
  // TODO:
  //' * add node finalizers
  //' * convert graph to readable form in R
  //' * insertion vs lookup speed; see: https://stackoverflow.com/questions/4063857/dynamic-list-in-ansi-c

  //' Atomic operation: divide into tensor and function
  //' dest: object id
  //' next: pointer to adjacent ops
  //' use one convention with pointers
  //'
  //' Incrementation:
  //' https://stackoverflow.com/questions/8208021/how-to-increment-a-pointer-address-and-pointers-value?rq=1

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


