#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>

#define CAST_PTR(output, struct_name, ptr) struct struct_name *output = (struct struct_name*) R_ExternalPtrAddr(ptr);

// ============================ Useful links ========================
// http://lagodiuk.github.io/computer_science/2016/12/19/efficient_adjacency_lists_in_c.html
// http://www.mathcs.emory.edu/~cheung/Courses/255/Syllabus/2-C-adv-data/dyn-array.html
// https://www.geeksforgeeks.org/graph-and-its-representations/
// https://cran.r-project.org/doc/manuals/R-exts.html#Garbage-Collection
// https://www.programiz.com/dsa/graph-adjacency-list
// https://www.sanfoundry.com/c-tutorials-mutually-dependent-structures/

// Structures to handle computational graph
// TODO:
//' * add node finalizers
//' * convert graph to readable form in R
//' * insertion vs lookup speed; see: https://stackoverflow.com/questions/4063857/dynamic-list-in-ansi-c

//' Atomic operation: divide into tensor and function
//' dest: object id
//' next: pointer to adjacent ops
//' use one convention with pointers
//' Divide into 3 files
//'
//' Incrementation:
//' https://stackoverflow.com/questions/8208021/how-to-increment-a-pointer-address-and-pointers-value?rq=1

//' ================================ Link  ===============================  //
//' Link is a simple structure, which contains pointer to a Ops instance
//' as well as next and previous object
//' TODO: add finalizer

struct Link{
  struct Ops *contained;
  struct Link *next;
};

void _Link_finalizer(struct Link *link){
  free(link); // ???
}

struct Link* create_Link(struct Ops *contained_ops, struct Link *next_ops){
  struct Link* l = (struct Link*) calloc(1, sizeof(struct Link));
  l->contained = contained_ops;
  l->next = next_ops;
  return l;
}

struct Link* last_link(struct Link *current_link){
  while(current_link->next){
    current_link = current_link->next;
  }
  return current_link;
}

//' ================================== Ops ================================ //
struct Ops{
  int number;
  struct DlrContext *context; // To clean whole the chain, if the real object is removed from R env
  SEXP R_ops; // R object. It may be a vector or function. If NULL, object is vitual
  SEXP R_paired_ops; // Paired Ops, such as function derivative
  struct Link *wrapper_in_context; // Pointer to the Link object, which wraps the curent Ops in the DlrContext
  struct Link *inputs_header;
  struct Link *outputs_header;
};

void _Ops_finalizer(SEXP ext){
  // struct Ops *ptr = (struct Ops*) R_ExternalPtrAddr(ext);
  CAST_PTR(ops, Ops, ext);
  // If real object, remove whole chain
  // free_chain()
  Free(ops);
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

int _get_n_inputs(struct Ops* ops){
  int i = 0;
  struct Link* current_link = ops->inputs_header;
  while(current_link){
    i++;
    current_link = current_link->next;
  }
  return i;
}

SEXP C_get_ops_number(SEXP ops_ptr){
  CAST_PTR(ptr, Ops, ops_ptr);
  return ScalarInteger(ptr->number);
}

SEXP C_get_paired_ops(SEXP ops_ptr){
  CAST_PTR(ops, Ops, ops_ptr);
  return ops->R_paired_ops;
}

// Free all the virtual objects from the inputs and their inputs
// It can be real object only
void free_chain(struct Ops* ops){
  // Check, if object is 'real'

  // free_chain recursively till reaching a real object

}

//' ================================== DlrContext ================================ //
//' Context is a structure for storing computational graph
//' In the conext, theoretically should exist two types of objects:
//' * virtual objects
//' * 'real' objects

struct DlrContext{
  int V;
  struct Link *head;
};

static void _DlrContext_finalizer(SEXP ext)
{
  CAST_PTR(ptr, DlrContext, ext);
  Free(ptr);
  // TODO: free all the children?
}

SEXP C_create_context(){
  struct DlrContext* context = (struct DlrContext*) malloc(sizeof(struct DlrContext));
  context->V = 0;
  context->head = NULL;
  SEXP ptr_graph = PROTECT(R_MakeExternalPtr(context, R_NilValue, R_NilValue));
  R_RegisterCFinalizerEx(ptr_graph, _DlrContext_finalizer, TRUE);
  UNPROTECT(1);
  return ptr_graph;
}

// Create an operation and add it to the context
// TODO: remove debugging
SEXP C_register_ops(SEXP DlrContext_ptr, SEXP R_ops, SEXP R_paired_ops){
  CAST_PTR(context, DlrContext, DlrContext_ptr);
  context->V++;
  int val = context->V;
  // New Ops
  struct Ops *new_ops = create_Ops(val, R_ops, R_paired_ops);
  // New link
  struct Link *new_link = create_Link(new_ops, NULL);
  if (!context->head)
    context->head = new_link;
  else
    last_link(context->head)->next = new_link;

  // Transform into the ExternalPointer
  SEXP new_ops_ptr = PROTECT(R_MakeExternalPtr(new_ops, R_NilValue, R_NilValue));
  R_RegisterCFinalizerEx(new_ops_ptr, _Ops_finalizer, TRUE);
  UNPROTECT(1);

  return new_ops_ptr;
}

SEXP C_get_r_ops(SEXP DlrContext_ptr, SEXP number){
  CAST_PTR(context, DlrContext, DlrContext_ptr);
  int int_number = asInteger(number);
  struct Link *current_link = context->head;
  while(current_link){
    if (current_link->contained->number == int_number)
      return current_link->contained->R_ops;
    current_link = current_link->next;
  }
  return R_NilValue;
}

struct Ops* get_ops(SEXP DlrContext_ptr, SEXP number){
  CAST_PTR(context, DlrContext, DlrContext_ptr);
  int int_number = asInteger(number);
  struct Link *current_link = context->head;
  while(current_link){
    if (current_link->contained->number == int_number)
      return current_link->contained;
    current_link = current_link->next;
  }
  return NULL;
}

SEXP C_n_nodes(SEXP DlrContext_ptr){
  CAST_PTR(context, DlrContext, DlrContext_ptr);
  return ScalarInteger(context->V);
}

SEXP C_show_graph(SEXP DlrContext_ptr){
  CAST_PTR(context, DlrContext, DlrContext_ptr);
  struct Link *current_link = context->head;
  // This operation can be transformed into iter_links (?)
  while(current_link){
    printf("-> %d", current_link->contained->number);
    current_link = current_link->next;
  }
  return R_NilValue;
}

//SEXP C_add_inputs(SEXP DlrContext_ptr, SEXP node_ptr, SEXP inputs_numbers){
//  CAST_PTR(context, DlrContext, DlrContext_ptr);
//  CAST_PTR(ops, Ops, node_ptr);
//  struct Link* current_link = context->head;
  //struct Ops* ops = get_ops(DlrContext_ptr, node_number);
  // For each number
//  int* int_inputs_numbers = INTEGER(inputs_numbers);
//  int size = length(inputs_numbers);
//  while(current_link){
//    for(int i = 0; i < size; i++){
//      if (current_link->contained->number == int_inputs_numbers[i]){
//       struct Ops* added_ops = get_ops(DlrContext_ptr, ScalarInteger(int_inputs_numbers[i]));
//       add_input_Ops(ops, added_ops);
//      }
//    }
//    current_link = current_link->next;
//  }
//  return R_NilValue;
//}

SEXP C_add_input(SEXP node_ptr, SEXP input_ptr){
  CAST_PTR(ops, Ops, node_ptr);
  CAST_PTR(ops_input, Ops, input_ptr);
  add_input_Ops(ops, ops_input);
  return R_NilValue;
}

SEXP C_add_output(SEXP node_ptr, SEXP output_ptr){
  CAST_PTR(ops, Ops, node_ptr);
  CAST_PTR(ops_output, Ops, output_ptr);
  add_output_Ops(ops, ops_output);
  return R_NilValue;
}

SEXP C_get_linked_nodes(SEXP DlrContext_ptr, SEXP node_number){
  //CAST_PTR(context, DlrContext, DlrContext_ptr);
  struct Ops* ops = get_ops(DlrContext_ptr, node_number);
  int n_linked_ops = _get_n_inputs(ops);

  //http://adv-r.had.co.nz/C-interface.html#c-vectors
  int* pout;
  SEXP out = PROTECT(allocVector(INTSXP, n_linked_ops));
  pout = INTEGER(out);

  int i = 0;
  struct Link* current_link = ops->inputs_header;
  // This operation can be transformed into iter_links (?)
  while(current_link){
    pout[i] = current_link->contained->number;
    i++;
    current_link = current_link->next;
  }

  return out;
}
