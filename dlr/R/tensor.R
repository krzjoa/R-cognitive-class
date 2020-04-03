#' @name tensor
#' @title Create `fuego` tensor of arbitrary shapes
#' @description Tensor abstraction, an interface for CPU and CUDA tensors.
#' @param data numeric vector, array or data.frame
#' @param dims dimensions
#' @param requires.grad is gradient required; logical
#' @examples
#' x   <- tensor(1:30, c(3, 10))
#' tsr <- tensor(1:20, c(2, 10))
NULL

# TODO: create abstraction class??

#' tensor class definition
.cpu_tensor <- setClass("cpu_tensor",
   representation(
     data     = "numeric",
     dims     = "numeric",
     grad     = "numeric",
     backward = "function",
     forward  = "function"
))

#' tensor class constructor
cpu_tensor <- function(data, dims, requires.grad = FALSE){

  grad <- if (requires.grad) array(0, dim = dims) else NA_real_

  .cpu_tensor(data = data,
              dims = dims,
              grad = grad)
}

#' cpu tensor

#' Remark: .Call have to return SEXP, while .C doesn't

# Main object to store all the session objects
#' #' @useDynLib dlr test
#' #' @export
#' graph <- function() .Call(test)


# library(dlr)
# gph <- graph()
# nodes(gph)

