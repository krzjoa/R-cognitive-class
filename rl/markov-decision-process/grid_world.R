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





gw <- grid_world$new(6, 5, c(1, 1))

#' @name matrix_set
#' @title Set multiple values useing one function call 
#' @description 
#' This functions allows to set multiple elements of a matrix 
#' instead of using annoying step-by-step assignment by
#' mat[1,2] <- 2
#' mat[2,3] <- 0.5 
#' etc.
#' @aliases s
#' @examples 
#' mat <- matrix(0, 4, 5)
#' matrix_set(mat, .(1,1) ~ 5, .(3, 4) ~ 0.3)
matrix_set <- function(matrix, ...){
  exprs <- list(...)
  
  is.formula <- sapply(exprs, function(x) inherits(x, 'formula'))
  
  if(!all(is.formula))
    stop(paste0("Following arguments are not formulae: ", exprs[!is.formula]))
  
  for(expr in exprs){
    args <- strsplit(as.character(expr), "~", fixed = TRUE)
    args <- args[args != ""]
    lh <- eval(parse(text = args[[1]]))
    rh <- as.numeric(args[[2]])
    matrix[lh[1], lh[2]] <- rh
  }
  matrix
}

matrix_set(rewards, 
           c(1, 1) ~ 2,
           c(2, 3) ~ 0.5, 
           c(4, 4) ~ 200)


# Actions
m(T, T, T, F, T|
  T, T, F, T, T|
  F, T, T, T, F|
  T, T, T, T, T|
  F, F, T, T, T|
  F, T, T, T, F) -> actions

rewards <- matrix(0, 6, 5)
rewards[5, 5] <- 1
rewards[4, 1] <- -1 

gw$set(rewards = rewards,
       actions = actions)

gw$move('R')


gw$is_action_possible('R')



