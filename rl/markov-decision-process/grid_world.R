library(R6)
library(matricks)


grid_world <- R6Class(
  classname = 'grid_world',
  
  public = list(
    
    width = 5,
    height = 5,
    i = 1,
    j = 1,
    board = NA, 
    rewards = NA,
    actions = NA,
    
    initialize = function(width, height, start){
      self$width <- width
      self$height <- height
      self$i <- start[1]
      self$j <- start[2]
      
      self$board <- matrix(0, nrow = height, 
                           ncol = width)
    },
    
    set = function(actions, rewards){
      self$rewards <- rewards
      self$actions <- actions  
    },
    
    set_state = function(s){
      self$i <- s[1]
      self$j <- s[2]
    },
    
    is_terminal = function(s){
      self$actions[s[1], s[2]]
    },
    
    move = function(action){
      if(self$is_action_possible(action)){
        switch (action,
          U = {self$i <- self$i - 1},
          D = {self$i <- self$i + 1},
          R = {self$j <- self$j + 1},
          L = {self$j <- self$j - 1},
        )
      }
      self$rewards[self$i, self$j]    
    },
    
    undo_move = function(action){
      if(self$is_action_possible(action)){
        switch (action,
                U = {self$i <- self$i + 1},
                D = {self$i <- self$i - 1},
                R = {self$j <- self$j - 1},
                L = {self$j <- self$j + 1},
        )
      }
      self$rewards[self$i, self$j]    
    },
    
    is_action_possible = function(action){
      switch (action,
              U = {c(self$i - 1, self$j)},
              D = {c(self$i + 1, self$j)},
              R = {c(self$i, self$j + 1)},
              L = {c(self$i, self$j - 1)}
      ) -> action.value
      self$actions[action.value[1], action.value[2]]
    },
    
    game_over = function(){
      !self$actions[self$i, self$j]
    }
  )
)


standard_grid <- function(){
  gw <- grid_world$new(6, 5, c(1, 1))
  
  # Actions
  m(T, T, T, F, T|
    T, T, F, T, T|
    F, T, T, T, F|
    T, T, T, T, T|
    F, F, T, T, T|
    F, T, T, T, F) -> actions
  
  rewards <- matrix(0, 6, 5)
  
  set_values(rewards, 
             c(4, 4) ~ -1,
             c(5, 3) ~ 1) -> rewards
  
  gw$set(rewards = rewards,
         actions = actions)
  
  gw
}

negative_grid <- function(step.cost = -0.1){
  gw <- standard_grid()
  rewards <- gw$rewards
  rewards[rewards == 0] <- step.cost
  gw$rewards <- rewards
  gw
}

# gw <- negative_grid()
# 
# gw$move('R')
# 
# 
# gw$is_action_possible('R')


conv.threshold <- 10e-4

#' @name matrix_idx
#' @title Return all the matrix/data.frame indices
#' @param x matrix or data.frame
#' @param mask logical matrix
#' @return list of two-element vectors, where values describe (x, y) position respecitively
#' @example 
#' mat <- matrix(0, 3, 3)
#' matrix_idx(mat)
matrix_idx <- function(x, mask = NULL){
  n.col <- ncol(x)
  n.row <- nrow(x)
  out <- expand.grid(1:n.col, 1:n.row)
  
  # browser()
  
  out2 <- asplit(out, 1)
  out2 <- Map(as.vector, out2)
  
  if (is.matrix(mask)){
    out3 <- matrix(out2, nrow = n.row, ncol = n.col)
    return(out3[mask])
  } else {
    return(out2)
  }
}

#' @name neighbour_idx
#' @title Get all indices in neighbourhood 
#' @param mat matrix or data.frame
#' @param idx two-element vector
#' @param mask logical matrix; optional
#' @param diagonal include diagonal neighbours
#' @param include.idx include current index
#' @example 
#' mat <- matrix(0, 3, 3)
#' neighbour_idx(mat, c(1, 2))
#' neighbour_idx(mat, c(1, 2), diagonal = FALSE)
#' neighbour_idx(mat, c(1, 2), diagonal = FALSE, include.idx = TRUE)
#' # With mask
#' mat <- matrix(0, 3, 4)
#' mask <- m(F, F, T, T | F, F, F, F | T, T, F, T)
#' neighbour_idx(mat, c(1, 2), mask = mask)
neighbour_idx <- function(mat, idx, mask = NULL, diagonal = TRUE, include.idx = FALSE){
  n.row <- nrow(mat)
  n.col <- ncol(mat)
  nidx <- NULL
  min.row <- max(1, idx[1]-1)
  max.row <- min(n.row, idx[1] + 1)
  min.col <- max(1, idx[2] - 1)
  max.col <- min(n.col, idx[2] + 1)
  
  for (i in min.row:max.row) {
    for (j in min.col:max.col) {
      
      if (!include.idx & idx[1] == i & idx[2] == j)
        next
      
      if (!diagonal & (abs(idx[1]-i) + abs(idx[2] - j)) == 2)
        next
      
      if (!is.null(mask)) {
        if (mask[i, j])
          nidx <- c(nidx, list(c(i, j)))
      } else {
        nidx <- c(nidx, list(c(i, j)))
      }
    }
  }
  nidx
}



main <- function(){
  grid <- standard_grid()
  
  V <- matrix(0, nrow = grid$height, ncol = grid$width)
  gamma <- 1.0 # discount factor
  states <- matrix_idx(grid$actions, grid$actions)
  mask <- grid$actions & (grid$rewards == 0)
  # non.terminal.states <- matrix_idx(grid$actions, )
  
  while (TRUE) {
    biggest.change <- 0
    
    for (s in states){
      old.v <- V[s[1], s[2]]
      
      # V(s) only has value if `s` it's not a terminal state
      possible.transitions <- neighbour_idx(grid$actions, 
                                            idx = s, mask = mask, 
                                            diagonal = FALSE)
      for (ns in non.terminal.states){
        
        new.v <- 0
        p.a <- 1.0 / length(possible.transitions)
        
        
        
        
      }
      
    }
        
    
  }
  
  
}
  


