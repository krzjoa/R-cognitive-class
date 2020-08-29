#' Arithmetic operations
#' Abstract function for tensor-numeric operations
#' Keep consistent style for variable names
#'
#' Ten podział dlaczegoś nie działa. Dlaczego?
.convert_tensor_numeric <- function(fun, e1, e2){
  e2 <- scalar(e2)
  return(fun(e1, e2))
}

#' @examples
setMethod("Arith", c(e1="cpu_tensor", e2="numeric"),
          function(e1, e2)
          {
            op = .Generic[[1]]
            .convert_tensor_numeric(`^`, e1, e2)
          },
          valueClass = "cpu_tensor"
)

