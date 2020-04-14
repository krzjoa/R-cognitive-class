#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>

// #define CAST_PTR(strukt, ptr) stru

// http://lagodiuk.github.io/computer_science/2016/12/19/efficient_adjacency_lists_in_c.html
// http://www.mathcs.emory.edu/~cheung/Courses/255/Syllabus/2-C-adv-data/dyn-array.html
// https://www.geeksforgeeks.org/graph-and-its-representations/
// https://cran.r-project.org/doc/manuals/R-exts.html#Garbage-Collection
// https://www.programiz.com/dsa/graph-adjacency-list


//

// Structures to handle computational graph
// TODO:
//' * add node finalizers
//' * use dynamic adjacency list
//' * convert graph to readable form in R
//' * insertion vs lookup speed; see: https://stackoverflow.com/questions/4063857/dynamic-list-in-ansi-c

//' Atomic operation: divide into tensor and function
//' dest: object id
//' next: pointer to adjacent ops
//'

//' ================================== Ops ================================ //
struct Ops{
  int dest;
  struct Ops* next;
};

struct Ops* create_Ops(SEXP node_no){
  int dest = asInteger(node_no);
  struct Ops* p = (struct Ops*) calloc(1, sizeof(struct Ops));
  p->dest = dest;
  p->next = NULL;
  return p;
}

void _Ops_finalizer(SEXP ext){
  struct Ops *ptr = (struct Ops*) R_ExternalPtrAddr(ext);
  Free(ptr);
}


//' ================================== Gaph ================================ //


// How to remove this structure???
// Moving head to graph: when done, cannot be accessed via index (why?)
struct OperationStack{
  struct Ops* head;
};

struct Graph{
  int V;
  struct Ops** ops_stack;
};

static void _graph_finalizer(SEXP ext)
{
  struct Graph *ptr = (struct Graph*) R_ExternalPtrAddr(ext);
  Free(ptr);
}


struct Ops* new_node(int dest){
  struct Ops* p = (struct Ops*) calloc(1, sizeof(struct Ops));
  p->dest = dest;
  p->next = NULL;
  return p;
}



SEXP create_graph(SEXP nodes){
  int V = asInteger(nodes);
  struct Graph* graph = (struct Graph*) malloc(sizeof(struct Graph));
  graph->V = V;

  graph->ops_stack = (struct OperationStack*) malloc(V * sizeof(struct OperationStack));

  int i;
  for (i = 0; i < V; i++)
    graph->ops_stack[i].head = NULL;

  SEXP ptr_graph = PROTECT(R_MakeExternalPtr(graph, R_NilValue, R_NilValue));
  R_RegisterCFinalizerEx(ptr_graph, _graph_finalizer, TRUE);
  UNPROTECT(1);

  return ptr_graph;
}

SEXP add_edge(SEXP graph_ptr, SEXP sexp_src, SEXP sexp_dest){
  int src = asInteger(sexp_src);
  int dest = asInteger(sexp_dest);
  struct Graph *graph = (struct Graph*) R_ExternalPtrAddr(graph_ptr);
  // Dodać destruktor
  struct Ops* node = new_node(src);
  node->next = graph->ops_stack[src].head;
  graph->ops_stack[dest].head = node;
  return graph_ptr;
}

void print_graph(SEXP graph_ptr)
{
  struct Graph *graph = (struct Graph*) R_ExternalPtrAddr(graph_ptr);
  int v;
  for (v = 0; v < graph->V; ++v)
  {
    struct Ops* pCrawl = graph->ops_stack[v].head;
    printf("\n Adjacency list of vertex %d\n head ", v);
    while (pCrawl)
    {
      printf("-> %d", pCrawl->dest);
      pCrawl = pCrawl->next;
    }
    printf("\n");
  }
}


SEXP graph_vertices(SEXP ptr){
  struct Graph *graph = (struct Graph*) R_ExternalPtrAddr(ptr);
  return ScalarInteger(graph->V);
}

