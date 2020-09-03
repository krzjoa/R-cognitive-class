#' Arithmetic operations
#'  "+", "-", "*", "^", "%%", "%/%", "/"
#' Compare:
#' * Matrix package: https://github.com/cran/Matrix/blob/master/R/Ops.R
#' * gpuR package: https://github.com/cdeterman/gpuR/blob/master/R/methods-gpuVector.R
#' * rray: https://github.com/r-lib/rray/blob/master/R/compat-vctrs-arith.R
#'
#' Maybe vctrs is a better choice?
#'

#' Autograd: https://github.com/shabbychef/madness
#'
#' Dictionary:
#' x, y - inputs
#' result - cached operation result
#' grad - gradinet from previous result

# =============================================================================================== #
#                                         TENSOR - TENSOR                                         #
# =============================================================================================== #

#' Abstract function for tensor-numeric operations
#' Backward function rather than partial derivative?
#' Problem: newly created tensor has by default
#  The simpliest solution is may be potentially dangerous and does not handle
#  simple R operations such as x <- y
#  See: https://www.brodieg.com/2019/02/18/an-unofficial-reference-for-internal-inspect/

#' Maybe we don't need to track some 'abstract tensors'
#' Memoisation can handle this case instead

.abstract_operator <- function(fun, deriv, tensor.1, tensor.2){
  # Propagate requires_grad
  requires_grad <- any(tensor.1@requires_grad,
                       tensor.2@requires_grad)

  .fun   <- register_ops(get_context(), fun, deriv)
  connect(list(tensor.1, tensor.2), .fun)

  x@data          <- fun(tensor.1@data, tensor.2@data)
  x@pointer       <- register_ops(get_context(), x)
  x@requires_grad <- requires_grad

  # x <- reassign_ops(x)
  connect(.fun, x)
  return(x)
}

#' ============================================================== #
#'                              ADDITION                          #
#' ============================================================== #
#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.addition <- function(x, y) x + y
.addition_deriv <- list(
  x = function(x, y, result, grad) grad,
  y = function(x, y, result, grad) grad
)

.arith_addition <- function(x, y){
  .abstract_operator(.addition, .arith_addition, x, y)
}

#' ============================================================== #
#'                          SUBTRACTION                           #
#' ============================================================== #
.subtraction <- function(x, y) x - y
.subtraction_deriv <- list(
  x = function(x, y, result, grad) grad,
  y = function(x, y, result, grad) -grad
)

.arith_subtraction <- function(x, y){
  .abstract_operator(.subtraction, .subtraction_deriv, x, y)
}

#' ============================================================== #
#'                          MULTIPLICATION                        #
#' ============================================================== #
.multiplication <- function(x, y) x * y
.multiplication_deriv <- list(
  x = function(x, y, result, grad) y * grad,
  y = function(x, y, result, grad) x * grad
)

.arith_multiplication<- function(x, y){
  .abstract_operator(.multiplication, .multiplication_deriv, x, y)
}

#' ============================================================== #
#'                              DIVISION                          #
#' ============================================================== #
.division <- function(x, y) x / y
.division_deriv <-list(
  x = function(x, y, result, grad) grad / y,
  y = function(x, y, result, grad) - grad * x / y**2  # check operations order
)

.arith_division <- function(x, y){
  .abstract_operator(.division, .division_deriv, x, y)
}

#' ============================================================== #
#'                              POWER                             #
#' ============================================================== #
#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.power <- function(x, y) x ** y
.power_deriv <- list(
  x = function(x, y, result, grad) y * (x ** (y - 1)) * grad,
  y = function(x, y, result, grad) result * log(x) * grad
)

.arith_power <- function(x, y){
  .abstract_operator(.power, .power_deriv, x, y)
}

#' @examples
setMethod("Arith", c(e1="cpu_tensor", e2="cpu_tensor"),
          function(e1, e2)
          {
            op = .Generic[[1]]
            switch(op,
                   `+`  = .arith_addition(e1, e2),
                   `-`  = .arith_subtraction(e1, e2),
                   `*`  = .arith_multiplication(e1, e2),
                   `/`  = .arith_division(e1, e2),
                   `^`  = .arith_power(e1, e2),
                   # TODO:
                   `%%` = .arith_power(e1, e2),
                   `%/%` =.arith_power(e1, e2),
                   stop("undefined operation")
            )
          },
          valueClass = "cpu_tensor"
)


# =============================================================================================== #
#                                        NUMERIC - TENSOR                                         #
# =============================================================================================== #

#' @examples
setMethod("Arith", c(e1="numeric", e2="cpu_tensor"),
          function(e1, e2)
          {
            e1 <- scalar(e1)
            op = .Generic[[1]]
           .Primitive(op)(e1, e2)
          },
          valueClass = "cpu_tensor"
)

# =============================================================================================== #
#                                        TENSOR - NUMERIC                                         #
# =============================================================================================== #

#' @examples
setMethod("Arith", c(e1="cpu_tensor", e2="numeric"),
          function(e1, e2)
          {
            e2 <- scalar(e2)
            op = .Generic[[1]]
            .Primitive(op)(e1, e2)
          },
          valueClass = "cpu_tensor"
)
