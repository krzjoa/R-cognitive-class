#' @name tensor
#' @title Create `fuego` tensor of arbitrary shapes
#' @description Tensor abstraction, an interface for CPU and CUDA tensors.
#' @param data numeric vector, array or data.frame
#' @param dims dimensions
#' @param requires.grad is gradient required; logical
#' @examples
#' library(dlr)
#' x   <- cpu_tensor(1:30, c(3, 10))
NULL

# TODO: create abstraction class??

#' tensor class definition
.cpu_tensor <- setClass("cpu_tensor",
   representation(
     data     = "array",
     dims     = "numeric",
     grad     = "array",
     pointer  = "externalptr"
))

#' cpu_tensor class constructor
#' @name cpu_tensor
#' @title CPU tensor
#' @export
cpu_tensor <- function(data, dims, requires.grad = FALSE){

  data <- array(data = data, dim = dims)
  grad <- array(0, dim = dims)
  # grad <- if (requires.grad) array(0, dim = dims) else array(NULL)

  # TODO: remove xptr lib use
  tensor <- .cpu_tensor(data = data,
                        dims = dims,
                        grad = grad,
                        pointer = xptr::null_xptr())
  ctx <- get_context()
  ptr <- register_ops(ctx, tensor)
  tensor@pointer <- ptr
  tensor
}

#' @name scalar
#' @title CPU tensor
#' @export
scalar <- function(x){
  cpu_tensor(data  = x,
             dims = 1,
             requires.grad = FALSE)
}
