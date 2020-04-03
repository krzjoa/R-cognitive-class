.abstract_function <- function(fun, deriv){
  custom.fun <- fun
  attr(custom.fun, "deriv") <- deriv
  custom.fun
}

`+.tensor` <- function(a, b){
  print("lollo")
}

sin.tensor <- .abstract_function(cos, sin)
attr(sin.tensor, "derivative")

ar <- array(3, dim = list(3, 3))
sin(ar)

tsr <- tensor(3, 7, 7)
sin(tsr)

my.fun <- sin
attr(my.fun, "deriv") <- cos

my.fun(1:10)

