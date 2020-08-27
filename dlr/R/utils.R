#' @name compare_ptr
#' @title Compare two pointers
#' @param x external pointer
#' @param y external pointer
#' @useDynLib dlr C_compare_ptr
#' @examples
#' library(dlr)
#' ctx <- get_context()
#' register_ops(ctx, cars)
#' register_ops(ctx, data.frame)
#' x <- cpu_tensor(5, dims = 1)
#' all.ops <- get_all_ops_ptr(ctx)
#' compare_ptr(x@pointer, all.ops[[3]])
#' @export
compare_ptr <- function(x, y){
  .Call(C_compare_ptr, x, y)
}

#' @name is_in_pointer_list
#' @title Check if externaptr object occurs in the given list of externalptrs
#' @param ptr externalptr object
#' @param ptr.list list of externalptr objects
#' @examples
#' library(dlr)
#' ctx <- get_context()
#' register_ops(ctx, cars)
#' register_ops(ctx, data.frame)
#' x <- cpu_tensor(5, dims = 1)
#' y <- x ** 3
#' all.ops <- get_all_ops_ptr(ctx)
#' is_in_pointer_list(x@pointer,  all.ops)
#' @export
is_in_pointer_list <- function(ptr, ptr.list){
  return(any(unlist(Map(function(x) compare_ptr(x, ptr), ptr.list))))
}


#' @name get_soprano_pointer
#' @title Retun pointer to soprano graph's nodes
#' @description If obj is a pointer, it returns obj.
get_soprano_pointer <- function(obj){
  if (inherits(obj, "cpu_tensor"))
    return(obj@pointer)
  else
    return(obj)
}


#' @name add_class
#' @title Add class name
`add_class<-` <- function(obj, new_class){
  class(obj) <- c(class(obj), new_class)
  return(obj)
}
