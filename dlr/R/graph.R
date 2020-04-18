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
#' @useDynLib dlr add_node
#' @export
.create_ops <- function(ctx, val){
  .Call(add_node, ctx, val)
}


#' @useDynLib dlr graph_vertices
#' @export
.nodes <- function(gph) .Call(graph_vertices, gph)

#' @name get_graph
#' @title Get computation graph
#' @export
get_graph <- function(){
  getOption("dlr.graph")
}

#' @name .show_graph
#' @title Show graph
#' @useDynLib dlr print_DlrContext
#' @examples
#' library(dlr)
#' ctx <- get_graph()
#' .add_node(ctx, 13)
#' .add_node(ctx, 20)
#' .add_node(ctx, 777)
#' .add_node(ctx, 45)
#' .nodes(ctx)
#' .show_graph(ctx)
#' @export
.show_graph <- function(gph) .Call(print_DlrContext, gph)


