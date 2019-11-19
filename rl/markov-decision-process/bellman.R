#' @name matrix_rows
#' @tittle Construct a matrix passing following rows
#' @param ... set of rows
#' @return matrix
#' @examples 
#' x <- matrix_rows(c(1,2,3),
#'                  c(4,5,6))
matrix_rows <- function(...){
  `all rows have equal length` <- unique(sapply(list(...), length)) == 1
  stopifnot(`all rows have equal length`)
  
  
  
}

matrix_rows(c(1,2,3) | c(2,3,4))



x <- matrix_rows(c(1,2,3),
                 c(4,5))
