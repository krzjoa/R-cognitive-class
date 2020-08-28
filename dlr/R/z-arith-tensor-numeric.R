#' Arithmetic operations
#'  "+", "-", "*", "^", "%%", "%/%", "/"
#' Compare:
#' * Matrix package: https://github.com/cran/Matrix/blob/master/R/Ops.R
#' * gpuR package: https://github.com/cdeterman/gpuR/blob/master/R/methods-gpuVector.R

#' Abstract function for tensor-numeric operations
#' Keep consistent style for variable names
.operator_tensor_numeric <- function(fun, deriv, tensor.arg, numeric.arg){
  .fun   <- register_ops(get_context(), fun, deriv)
  # Convert numeric arg to tensor
  scalar.var <- scalar(numeric.arg)
  connect(list(tensor.arg, scalar.var), .fun)

  # Problem: newly created tensor has by default
  # The simpliest solution is may be potentially dangerous and does not handle
  # simple R operations such as x <- y
  # See: https://www.brodieg.com/2019/02/18/an-unofficial-reference-for-internal-inspect/
  x@data    <- fun(tensor.arg@data, numeric.arg)
  x@pointer <- register_ops(get_context(), x)

  # TODO: create one function, e.g.: connect_ops()
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
.tn_addition <- function(x, y) x + y
.tn_addition_deriv <- function(x, y) x + y

.arith_tn_addition <- function(x, y){
  .operator_tensor_numeric(.tn_addition, .tn_addition_deriv, x, y)
}

#' ============================================================== #
#'                          SUBTRACTION                           #
#' ============================================================== #
#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.tn_subtraction <- function(x, y) x - y
.tn_subtraction_deriv <- function(x, y) x - y

.arith_tn_subtraction <- function(x, y){
  .operator_tensor_numeric(.tn_subtraction, .tn_subtraction_deriv, x, y)
}

#' ============================================================== #
#'                          MULTIPLICATION                        #
#' ============================================================== #
#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.tn_multiplication <- function(x, y) x * y
.tn_multiplication_deriv <- function(x, y) x * y

.arith_tn_multiplication<- function(x, y){
  .operator_tensor_numeric(.tn_multiplication, .tn_multiplication_deriv, x, y)
}

#' ============================================================== #
#'                              DIVISION                          #
#' ============================================================== #
#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.tn_division <- function(x, y) x * y
.tn_division_deriv <- function(x, y) x * y

.arith_tn_division <- function(x, y){
  .operator_tensor_numeric(.tn_division, .tn_division_deriv, x, y)
}

#' ============================================================== #
#'                              POWER                             #
#' ============================================================== #
#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.tn_power <- function(x, y) x ** y
.tn_power_deriv <- function(x, y) y * (x ** (y - 1))

.arith_tn_power <- function(x, y){
  .operator_tensor_numeric(.tn_power, .tn_power_deriv, x, y)
}

#' @examples
setMethod("Arith", c(e1="cpu_tensor", e2="numeric"),
          function(e1, e2)
          {
            op = .Generic[[1]]
            switch(op,
                   `+` = .arith_tn_addition(e1, e2),
                   `-` = .arith_tn_subtraction(e1, e2),
                   `*` = .arith_tn_multiplication(e1, e2),
                   `/` = .arith_tn_division(e1, e2),
                   `^` = .arith_tn_power(e1, e2),
                   stop("undefined operation")
            )
          },
          valueClass = "cpu_tensor"
)

