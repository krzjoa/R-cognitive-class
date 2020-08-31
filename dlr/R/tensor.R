#' @name tensor
#' @title Create `soprano` tensor of arbitrary shapes
#' @description Tensor abstraction, an interface for CPU and CUDA tensors.
#' @param data numeric vector, array or data.frame
#' @param dims dimensions
#' @param requires.grad is gradient required; logical
#' @importFrom rray rray
#' @examples
#' library(dlr)
#' x   <- cpu_tensor(1:30, c(3, 10))
NULL

# TODO: create abstraction class??
# See: https://stackoverflow.com/questions/12636056/why-sometimes-i-cant-set-a-class-definition-as-slot-in-a-s4-class
# https://stackoverflow.com/questions/13002200/s4-classes-multiple-types-per-slot

setOldClass("vctrs_rray")
setOldClass("vctrs_vctr")
setOldClass("vctrs_rray_dbl")
setClassUnion("rray_class", members = c("vctrs_rray", "vctrs_vctr", "vctrs_rray_dbl"))


#' tensor class definition
.cpu_tensor <- setClass("cpu_tensor",
   representation(
     data     = "rray_class",
     dims     = "numeric",
     grad     = "rray_class",
     pointer  = "externalptr"
     # is_leaf ?
))

#' cpu_tensor class constructor
#' @name cpu_tensor
#' @title CPU tensor
#' @export
cpu_tensor <- function(data, dims, requires.grad = FALSE){

  data <- rray(x = data, dim = dims)
  grad <- rray(0, dim = dims)
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
