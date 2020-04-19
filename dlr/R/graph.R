# Helper functions to create computational graph

#' @name .create_context
#' @title Create graph to track computations
#' @return external pointer (EXPTREXP)
#' @useDynLib dlr create_DlrContext
#' @export
.create_context <- function(){
  graph <- .Call(create_DlrContext)
  class(graph) <- "dlr_context"
  graph
}

#' @name .create_ops
#' @title Add a node
#' @useDynLib dlr create_ops_in_context
#' @export
.create_ops <- function(ctx, val, r.ops){
  .Call(create_ops_in_context, ctx, val, r.ops)
}


#' @useDynLib dlr graph_vertices
#' @export
.nodes <- function(gph) .Call(graph_vertices, gph)

#' @name get_graph
#' @title Get computation graph
#' @export
get_graph <- function(){
  getOption("dlr.context")
}

#' @name .show_graph
#' @title Show graph
#' @useDynLib dlr print_DlrContext
#' @export
.show_graph <- function(gph) .Call(print_DlrContext, gph)

#' @name .get_r_ops
#' @title Show graph
#' @useDynLib dlr get_r_ops
#' @export
.get_r_ops <- function(ctx, number) .Call(get_r_ops, ctx, number)

#' @name .add_node_inputs
#' @title Add node inputs
#' @useDynLib dlr add_inputs
#' @export
.add_node_inputs <- function(ctx, number, nodes){
  .Call(add_inputs, ctx, number, as.integer(nodes))
}

#' @name .get_linked_nodes
#' @title Show graph
#' @useDynLib dlr get_node_inputs
#' @export
.get_linked_nodes <- function(ctx, number) .Call(get_node_inputs, ctx, number)

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
