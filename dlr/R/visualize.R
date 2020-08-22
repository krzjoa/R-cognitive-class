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
#' adjacency_matrix(ctx)
#' @export
adjacency_matrix <- function(ctx){
  .Call(C_adjacency_matrix, ctx[['_container']])
}
