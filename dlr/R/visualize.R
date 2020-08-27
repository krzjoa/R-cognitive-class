#' @name adjacency_matrix
#' @title Creat adjacency matrix for all the operations in the context
#' @param ctx dlr_context object
#' @useDynLib dlr C_adjacency_matrix
#' @examples
#' library(dlr)
#' ctx <- get_context()
#' register_ops(ctx, cars)
#' register_ops(ctx, data.frame)
#' x <- cpu_tensor(5, dims = 1)
#' y <- x ** 3
#' all.ops <- get_all_ops_ptr(ctx)
#' adj_mat <- adjacency_matrix(ctx)
#' print(adj_mat)
#' plot(adj_mat)
#' @export
adjacency_matrix <- function(ctx){
  mat <- .Call(C_adjacency_matrix, ctx[['_container']])
  # add_class(mat) <- "soprano_adjacency_matrix"
  class(mat) <- c(class(mat), "soprano_adjacency_matrix")
  return(mat)
}

#' @name plot
#' @title Plot somprano adjacency matrix
#' @export
plot.soprano_adjacency_matrix<- function(adj_mat){
  print(adj_mat)
}
