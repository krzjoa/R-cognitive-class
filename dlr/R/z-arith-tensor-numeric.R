# Arithmetic operations

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

#' @name backward
#' @title This function traverses the graph back and computes all the gradients where it's needed
#' @param ops tensor
backward <- function(ops){
  # For simplicity, suppose we have only one sequence of operations

}

# set_tensor_method <- function(fun, deriv){
#
#   .function <- function(x){
#     deriv <- deriv
#     # x@backward <- deriv
#     x@data <- fun(x@data)
#     x
#   }
#
#   setMethod(deparse(substitute(fun)), signature(x = "tensor"),
#             .function, topenv(parent.frame(2)))
# }
#
#
# set_tensor_operator <- function(operator, fun, deriv){
#
#   .operator <- function(x, y){
#     deriv <- deriv
#     x@data <- fun(x@data, y)
#     x
#   }
#
#   setMethod(operator, signature(x = "tensor", y = "numeric"),
#             .operator, topenv(parent.frame(2)))
#
# }
