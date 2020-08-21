# Helper functions to create context, which handles computational graph
#' TODO: one convention for corresponding C and  function names
#' TODO: check, if all the operations still exists
#' Thera are several potential solutions of this problem
#' TODO: variable names convention

#' TODO: context enironment should keep exact pointers to all the dlr objects
#' For example, if we create in global
#' x <- tensor(1:100, c(2, 50))
#' We create pointer to this object, which should prevent object removal.
#' We should do exactly the same in the case of local variables
#' However, there are still two main problems to solve:
#' * how to handle object assignmnet (like this y <- x)
#' * duplicated funs in the environmnet: we don't need hundreads copies of power function etc.
#' Possible solution: duplicated register: object register vs ops register (?)
#' See: http://adv-r.had.co.nz/Environments.html

#' @name .create_context
#' @title Create graph to track computations
#' @return external pointer (EXPTREXP)
#' @useDynLib dlr C_create_context
#' @export
.create_context <- function(){
  ctx.container <- .Call(C_create_context)
  ctx <- new.env()
  ctx[['_container']] <- ctx.container
  ctx[['ops']] <- list()
  ctx[['paired.ops']] <- list()
  class(ctx) <- c("dlr_context", "environment")
  return(ctx)
}

#' @name get_context
#' @title Get default dlr context
#' @export
get_context <- function(){
  getOption("dlr.context")
}

#' @name reset_context
#' @title Reset context by removing all the objects from that
reset_context <- function(ctx = get_context()){

}

#' @name get_all_ops
#' @title Get all ops in context
#' @useDynLib dlr C_get_all_ops
#' @export
get_all_ops <- function(ctx){
  .Call(C_get_all_ops, ctx[['_container']])
}

#' @name get_all_ops_ptr
#' @title Get all ops in context
#' @useDynLib dlr C_get_all_ops_ptr
#' @export
get_all_ops_ptr <- function(ctx){
  .Call(C_get_all_ops_ptr, ctx[['_container']])
}

#' @name get_ops_number
#' @title Get operation number
#' @useDynLib dlr C_get_ops_number
#' @export
get_ops_number <- function(ptr) {
  .Call(C_get_ops_number, ptr)
}

#' @name get_r_ops
#' @title Get R operations
#' @useDynLib dlr C_get_r_ops
#' @export
get_r_ops <- function(ctx, number) {
  .Call(C_get_r_ops, ctx[['_container']], number)
}

#' @name register_ops
#' @title Create an operation inside the context.
#' It may be a tensor or a function
#' @useDynLib dlr C_register_ops
#' @export
register_ops <- function(ctx, r.ops, paired.ops = NULL){
  ptr     <- .Call(C_register_ops, ctx[['_container']], r.ops)
  ops.num <- get_ops_number(ptr)
  ctx[['ops']][[as.character(ops.num)]] <- r.ops
  if (!is.null(paired.ops))
    ctx[['ops']][[as.character(ops.num)]] <- paired.ops
  return(ptr)
}

#' @useDynLib dlr C_n_nodes
#' @export
n_nodes <- function(ctx = get_context()) {
  .Call(C_n_nodes, ctx[['_container']])
}
