# Testing tensors using S4 class
# See: https://yutani.rbind.io/post/double-dispatch-of-s3-method/
# https://adv-r.hadley.nz/s3.html#double-dispatch
# vec_arith
# https://github.com/cran/Matrix/blob/master/R/Ops.R
# https://github.com/r-lib/rray/blob/master/src/multiply-add.cpp

tsr.1 <- tensor(...)

#' Class for
setClass("ftensor",
         representation(data      = "array",
                        dims      = "numeric",
                        grad      = "array",
                        backward  = "vector",    # Keep pinters to the objects
                        forward   = "numeric"))

trollo <- function(e1, e2) print("trollo")

setMethod("+", signature(e1 = "ftensor", e2 = "ftensor"),
          trollo)


# Class constructor
ftensor <- function(data){
  new("ftensor",
      data = array(7, c(3, 3)),
      grad = array(7, c(3, 3)))
}




ftsr <- ftensor(7)


my.sin <- function(x) {sin(x@data); print(Recall)}

attr(my.sin, "deriv") <- cos

setMethod("sin", signature(x = "tensor"),
          my.sin)

sin(x)

getMethod("sin", "tensor") -> mthd
attr(mthd, "deriv")

trollo <- function(){
  print(environment())
}


#sin.tensor <- .abstract_function(cos, sin)
#attr(sin.tensor, "derivative")

#tsr <- tensor(777, 3, 3)
#sin(tsr)
