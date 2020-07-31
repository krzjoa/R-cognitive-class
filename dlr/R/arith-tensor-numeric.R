# Arithmetic operations

#' Abstract function for tensor-numeric operations
.operator_tensor_numeric <- function(fun, deriv, tensor.arg, numeric.arg){
  # TODO: add_inputs etc.
  fun.n   <- register_ops(get_context(), fun)
  deriv.n <- register_ops(get_context(), deriv)
  # Add
  x@data <- fun(tensor.arg@data, numeric.arg)
  x
}

#' Problem:
#' We don't want to recreate functions
#' Should we use 'temporal' context?
.otn_pow <- function(x, y) x ** y
.otn_pow_deriv <- function(x, y) y * (x ** (y - 1))

mat_elem_pow <- function(x, y){
  .operator_tensor_numeric(.otn_pow, .otn_pow_deriv, x, y)
}


# mat_elem_pow <- function(x, y){
#   forward <- function(x, y) x ** y
#   deriv   <- function(x, y) y * (x ** (y - 1))
#   num <- register_ops(get_context(), forward)
#   .add_node_inputs(get_context(), num, 2)
#   x@data <- forward(x@data, y)
# }

#' @examples
#' out <- x ^ 2
setMethod("Arith", c(e1="cpu_tensor", e2="numeric"),
          function(e1, e2)
          {
            op = .Generic[[1]]
            switch(op,
                   `^` = mat_elem_pow(e1, e2),
                   stop("undefined operation")
            )
          },
          valueClass = "cpu_tensor"
)
#
# setGeneric("backward", def = function(x)
# {
#   standardGeneric("backward")
# })
#
# setMethod("backward", c(x = "cpu_tensor"),
#           function(x) x@backward(x, y))
#
#
# x <- cpu_tensor(5, dims = 1)
# y <- x ** 3
# y
#
# backward(y)

