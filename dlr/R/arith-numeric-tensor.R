#' Arithmetic operations
#' Abstract function for tensor-numeric operations
#' Keep consistent style for variable names
.convert_numeric_tensor <- function(fun, e1, e2){
  e1 <- scalar(e1)
  return(fun(e1, e2))
}

#' @examples
setMethod("Arith", c(e1="numeric", e2="cpu_tensor"),
          function(e1, e2)
          {
            op = .Generic[[1]]
            .convert_tensor_numeric(`^`, e1, e2)
          },
          valueClass = "cpu_tensor"
)

