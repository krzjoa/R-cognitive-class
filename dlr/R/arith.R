# Arithmetic operations

# mat_elem_pow <- function(x, y){
#   deriv <- function(x, y) y * (x ** (y - 1))
#   x@data <- x@data ^ y
#   x@backward <- deriv
#   x
# }
#
# setMethod("Arith", c(e1="cpu_tensor", e2="numeric"),
#           function(e1, e2)
#           {
#             op = .Generic[[1]]
#             switch(op,
#                    `^` = mat_elem_pow(e1, e2),
#                    stop("undefined operation")
#             )
#           },
#           valueClass = "cpu_tensor"
# )
#
# setGeneric("backward", def = function(x)
# {
#   standardGeneric("backward")
# })
#
# setMethod("backward", c(x = "cpu_tensor"),
#           function(x) x@backward)
#
x <- cpu_tensor(5, dims = 1)
y <- x ** 3
y

backward(y)

