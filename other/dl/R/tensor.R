#' @name tensor
#' @title Create tesor object
#' @param data single value or vector; default: NULL
#' @param dims vector of dimensions; max: 6
#' @return a tensor object
#' @examples
#' tensor(1:90, c(1, 2, 45)) -> tsr
# TODO: dimensions checking (?)
tensor <- function(data = NULL, ..., requires.grad = TRUE){
  cpu <- TRUE
  if (cpu)
    tsr <- .cpu_tensor(data = data, dims = as.list(...),
                     requires.grad = requires.grad)
  class(tsr) <- c("tensor", "cpu_tensor", "array")
  tsr
}

# For printing utils see: https://github.com/r-lib/pillar/tree/master/R
cat_line <- function(...) {
  cat(paste0(..., "\n"), sep = "")
}

print.tensor <- function(x){
  cat(pillar:::crayon_grey_0.6("A tensor: 10 x 20"))
}

.cpu_tensor <- function(data, dims, requires.grad){
  # tsr <- array(data, dim = dims)
  out <- list(data = array(7, c(3, 3)))
  if (requires.grad)
    attr(out, "grad") <- array(data, dim = dims)
  out
}





