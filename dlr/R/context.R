# Helper functions to create context, which handles computational graph
#' TODO: one convention for corresponding C and  function names
#' TODO: check, if all the operations still exists
#' Thera are several potential solutions of this problem

#' @name .create_context
#' @title Create graph to track computations
#' @return external pointer (EXPTREXP)
#' @useDynLib dlr C_create_context
#' @export
.create_context <- function(){
  ctx <- .Call(C_create_context)
  class(ctx) <- "dlr_context"
  ctx
}

#' @name get_context
#' @title Get default dlr context
#' @export
get_context <- function(){
  getOption("dlr.context")
}

#' @name show_graph
#' @title Show context as a graph
#' @param ctx dlr_context
#' @useDynLib dlr C_show_graph
#' @export
show_graph <- function(ctx = get_context()) .Call(C_show_graph, ctx)

#' @name get_ops_number
#' @title Get operation number
#' @useDynLib dlr C_get_ops_number
get_ops_number <- function(ptr) .Call(C_get_ops_number, ptr)

#' @name get_r_ops
#' @title Get R operations
#' @useDynLib dlr C_get_r_ops
#' @export
get_r_ops <- function(ctx, number) .Call(get_r_ops, ctx, number)

#' @name register_ops
#' @title Create an operation inside the context.
#' It may be a tensor or a function
#' @useDynLib dlr C_register_ops
#' @export
register_ops <- function(ctx, r.ops, paired.ops = NULL){
  .Call(C_register_ops, ctx, r.ops)
}

#' @name get_paired_ops
#' @title Get paired operatin such as function derivative
#' @useDynLib dlr C_get_paired_ops
#' @export
get_paired_ops <- function(ops.ptr){
  .Call(C_get_paired_ops, ops.ptr)
}

#' @name reassign_ops
#' @title Workaround for the copy-on-modify case
# reassign_ops <- function(ops){
#
# }

#' @useDynLib dlr C_n_nodes
#' @export
n_nodes <- function(ctx = get_context()) .Call(C_n_nodes, ctx)

#' Function for getting artificial number of the operation

#' @name add_inputs
#' @title Add node inputs
#' @useDynLib dlr C_add_input
#' @export
add_input <- function(ops, input){
  .Call(C_add_input, ops, input)
}

#' @name get_linked_nodes
#' @title Get list of linked nodes
#' @useDynLib dlr C_get_linked_nodes
#' @export
get_linked_nodes <- function(ctx, number) .Call(C_get_linked_nodes, ctx, number)


#' @examples
#' library(dlr)
#' ctx <- get_graph()
#' .create_ops(ctx, 13, dplyr::mutate)
#' .create_ops(ctx, 20, cars)
#' .create_ops(ctx, 45, data.frame)
#' .nodes(ctx)
#' .show_graph(ctx)
#' .get_r_ops(ctx, 45)
#' .get_r_ops(ctx, 77)
#' # Adding links to nodes
#' .add_node_inputs(ctx, 13, as.integer(c(20, 45)))
#' .get_linked_nodes(ctx, 13)
