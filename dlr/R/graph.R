# Helper functions to create computational graph

#' @name .create_graph
#' @title Create graph to track computations
#' @return external pointer (EXPTREXP)
#' @useDynLib dlr create_graph
#' @export
.create_graph <- function(){
  graph <- .Call(create_graph, 5)
  class(graph) <- "dlr_graph"
  graph
}

#' @name .add_edge
#' @title Add node to computational graph
#' @useDynLib dlr add_edge
#' @details Works inplace
#' @export
.add_edge <- function(graph, start, end){
  .Call(add_edge, graph, start, end)
}

#' @useDynLib dlr print_graph
#' @export
.print_graph <- function(graph){
  .C(print_graph, graph)
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




