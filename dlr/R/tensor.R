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

#' How to store information, if gradient is required?
#' * grad slot == NULL
#' *

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
     data          = "rray_class",
     dims          = "numeric",
     grad          = "rray_class",
     pointer       = "externalptr",
     requires_grad = "logical"
     # is_leaf ?
))

#' cpu_tensor class constructor
#' @name cpu_tensor
#' @title CPU tensor
#' @export
cpu_tensor <- function(data, dims, grad = NULL, requires_grad = FALSE){

  if (is.null(grad))
    grad <- rray(0, dim = dims)
  else
    grad <- grad

  # TODO: remove xptr lib use
  tensor <- .cpu_tensor(
    data          = rray(x = data, dim = dims),
    dims          = dims,
    grad          = grad,
    pointer       = xptr::null_xptr(),
    requires_grad = requires_grad
  )
  ctx <- get_context()
  register_ops(ctx, tensor)
  # Wrong! tensor@pointer <- ptr

  return(tensor)
}

#' @name empty_cpu_tensor
#' @title Create empty cpu_tensor
#' @export
empty_cpu_tensor <- function(){
  cpu_tensor(numeric(0), dim = 0)
}

#' @name scalar
#' @title CPU tensor
#' @export
scalar <- function(x){
  cpu_tensor(
    data          = x,
    dims          = 1,
    requires_grad = FALSE)
}

#' @name set_tensor_grad
#' @title Modify inplace
#' @useDynLib dlr C_set_tensor_grad
#' @examples
#' library(dlr)
#' ctx <- get_context()
#' register_ops(ctx, cars)
#' register_ops(ctx, data.frame)
#' x <- cpu_tensor(5, dims = 1)
#' pryr::address(x)
#' set_tensor_grad(x, 777)
#' pryr::address(x)
#' @export
set_tensor_grad <- function(tensor, grad){
  .Call(C_set_tensor_grad, tensor, grad)
}

#' @name set_slot
#' @title Modify slot
#' @useDynLib dlr C_set_slot
#' @examples
set_slot <- function(tensor, key, value){
  .Call(C_set_slot, tensor, key, value)
}

