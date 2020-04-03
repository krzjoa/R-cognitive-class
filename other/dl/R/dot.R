#' pkgbuild::compile_dll()


#' Tensor dot product
dot <- function(a, b){

}
# https://stackoverflow.com/questions/12100856/combining-s4-and-s3-methods-in-a-single-function
# setMethod("%*%", signature(x="tensor", y="tensor"), dot)

#' @name test.c
#' @title An example
#' @export
test.c <- function(tensor) {
  .Call("tensor_sum", tensor)
}
