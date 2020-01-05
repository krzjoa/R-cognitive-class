source("rl/markov-decision-process/grid_world.R")
library(matricks)

# W przypadku "zwykłego" RL, gdzie przejścia między stanami są deterministyczne,
# wystarczy nam tylko funkcja wartości (value function)

#' @name matrix_idx
#' @title Get available marix indices
#' @param x matrix
#' @param n.row number of rows; default: NULL
#' @param n.col number of columns; default: NULL
#' @param mask logical matrix; default: NULL
#' @examples 
#' mat <- matrix(0, 3, 3)
#' mask <- m(T, T, F | T, F, T | F, F, T)
#' # All poss
#' matrix_idx(mat)
#' matrix_idx(mat, mask = mask)
#' matrix_idx(mask = mask)
matrix_idx <- function(x, n.row = NULL, n.col = NULL, mask = NULL){
  
  if (missing(x) & !is.null(mask))
    x <- mask
  
  n.col <- if (is.null(n.col)) ncol(x) else n.col
  n.row <- if (is.null(n.row)) nrow(x) else n.col
  out <- expand.grid(1:n.row, 1:n.col)
  
  if (is.null(mask))
    mask <- matrix(TRUE, nrow = n.row, ncol = n.col)

  out2 <- asplit(out, 1)
  out2 <- Map(as.vector, out2)
  out3 <- matrix(out2, nrow = n.row, ncol = n.col)
  
  out3[mask]
}

#' @name iterative_policy_evaluation
iterative_policy_evaluation1 <- function(epsilon = 1e-4, gamma = 1){
  grid <- negative_grid()
  states <- matrix_idx(grid$actions, 
                       grid$actions)
  
  V <- matrix(0, nrow = nrow(grid$actions),
              ncol = ncol(grid$actions))
  
  possible.actions <- grid$actions & (grid$rewards == -0.1)
  
  while (TRUE) {
    biggest.change <- 0
    
    for (s in states) {
      old.v <- at(V, s)
      
      if (at(possible.actions, s)){
        possible.transitions <- neighbour_idx(possible.actions, 
                                              idx = s,
                                              mask = grid$actions,
                                              diagonal = FALSE)
        new.v <- 0
        p.a <- 1.0 / length(possible.transitions)
        
        for (a in possible.transitions){
          r <- at(grid$rewards, a)
          new.v <- new.v + p.a * (r + gamma * at(V, a))
        }
          
        at(V, s) <- new.v
        biggest.change <- max(biggest.change, abs(old.v - at(V, s)))
      }
    }
    print("\n")
    print(V)
    print("\n")
    
    if (biggest.change < epsilon)
      break
  }
}

