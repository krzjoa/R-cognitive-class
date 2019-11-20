#' @name v
#' @title A shortcut to create a vector
#' @param ... arbitrary number of values
#' @return matrix with dims n_elements x 1
v <- function(...){
  matrix(c(...), ncol = 1)
}

m <- function(...){
  # Capture user input  
  raw.matrix <- rlang::exprs(...)
  
  # Expressions
  exprs <- unlist(sapply(raw.matrix, function(x) as.list(x)))
  
  break.indices <-c(0, which(sapply(exprs, deparse) == '|') + 1, length(exprs) + 1)
  #if(var(diff(break.indices)) != 0)
  #  stop()
  
  sapply()
  
  
  
  sapply(raw.matrix, function(x) unlist(as.list(x))) 
  
  
  
  sapply(raw.matrix, function(x) length(as.list(x))) 
  
  # z <- sapply(..., substitute)
  browser()
}


a <- m(1, 2, 3 | 
       4, 5, 6 | 
       7, 8, 9 )

m(1, 2, (3 | 9) | 
  4, 5, 6 | 
  7, 8, 9 )


m(1, 2, 3 :
    3, 4, 5)
