#' Arithmetic operations
#'  "+", "-", "*", "^", "%%", "%/%", "/"
#' Compare:
#' * Matrix package: https://github.com/cran/Matrix/blob/master/R/Ops.R
#' * gpuR package: https://github.com/cdeterman/gpuR/blob/master/R/methods-gpuVector.R
#' * rray: https://github.com/r-lib/rray/blob/master/R/compat-vctrs-arith.R
#'
#' Maybe vctrs is a better choice?

#' Abstract function for tensor-numeric operations
#' Keep consistent style for variable names
.operator_tensor_tensor <- function(fun, deriv, tensor.1, tensor.2){
  .fun   <- register_ops(get_context(), fun, deriv)
  connect(list(tensor.1, tensor.2), .fun)
  # Problem: newly created tensor has by default
  # The simpliest solution is may be potentially dangerous and does not handle
  # simple R operations such as x <- y
  # See: https://www.brodieg.com/2019/02/18/an-unofficial-reference-for-internal-inspect/
  x@data    <- fun(tensor.1@data, tensor.2@data)
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
.addition <- function(x, y) x + y
.addition_deriv <- function(x, y) x + y

.arith_addition <- function(x, y){
  .operator_tensor_tensor(.tn_addition, .arith_addition, x, y)
}

#' ============================================================== #
#'                          SUBTRACTION                           #
#' ============================================================== #
#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.subtraction <- function(x, y) x - y
.subtraction_deriv <- function(x, y) x - y

.arith_subtraction <- function(x, y){
  .operator_tensor_tensor(.subtraction, .subtraction_deriv, x, y)
}

#' ============================================================== #
#'                          MULTIPLICATION                        #
#' ============================================================== #
#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.multiplication <- function(x, y) x * y
.multiplication_deriv <- function(x, y) x * y

.arith_multiplication<- function(x, y){
  .operator_tensor_tensor(.multiplication, .multiplication_deriv, x, y)
}

#' ============================================================== #
#'                              DIVISION                          #
#' ============================================================== #
#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.division <- function(x, y) x * y
.division_deriv <- function(x, y) x * y

.arith_division <- function(x, y){
  .operator_tensor_tensor(.division, .division_deriv, x, y)
}

#' ============================================================== #
#'                              POWER                             #
#' ============================================================== #
#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.power <- function(x, y) x ** y
.power_deriv <- function(x, y) y * (x ** (y - 1))

.arith_power <- function(x, y){
  .operator_tensor_tensor(.power, .power_deriv, x, y)
}

#' @examples
setMethod("Arith", c(e1="cpu_tensor", e2="cpu_tensor"),
          function(e1, e2)
          {
            op = .Generic[[1]]
            switch(op,
                   `+` = .arith_addition(e1, e2),
                   `-` = .arith_subtraction(e1, e2),
                   `*` = .arith_multiplication(e1, e2),
                   `/` = .arith_division(e1, e2),
                   `^` = .arith_power(e1, e2),
                   stop("undefined operation")
            )
          },
          valueClass = "cpu_tensor"
)

