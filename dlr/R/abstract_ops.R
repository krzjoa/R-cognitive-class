# http://blog.ezyang.com/2019/05/pytorch-internals/
# https://github.com/cran/Matrix/blob/master/R/Ops.R
# https://stackoverflow.com/questions/47775303/implementing-basic-arithmetic-in-s4-class-object
# Arith
# https://github.com/cdeterman/gpuR/blob/master/R/methods.R
# https://pytorch.org/blog/a-tour-of-pytorch-internals-1/

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
#
#
#
#
# set_tensor_method(sin, cos)
# set_tensor_method(cos, function(x) -sin(x))
# set_tensor_method(min, max)
#
# sin(tsr)
# cos(tsr)
#
# fun1 <- function(x, y) x ** y
# fun2 <- function(x, y) y * (x ** (y - 1))
#
# # set_tensor_operator('**', fun1, fun2)
#
# setGeneric(name = "**",
#            def = function(x,y)
#            {
#              standardGeneric("**")
#            }
# )
#
# setMethod("+", signature(x = "tensor", y = "numeric"),
#           function(x, y) tensor(x@data ** y))




