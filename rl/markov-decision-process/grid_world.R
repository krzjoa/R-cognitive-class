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
  
  m(T, T, T, F, T|
    T, T, F, T, T|
    F, T, T, T, F|
    T, T, T, T, T|
    F, F, T, T, T|
    F, T, T, T, F) -> actions
  
  rewards <- matrix(0, 6, 5)
  rewards <- set_values(rewards, 
                        c(4, 4) ~ 1.,
                        c(5, 3) ~ -1)  
  
  gw$set(actions = actions,
         rewards = rewards)
  gw
}


negative_grid <- function(step.cost = -0.1){
  gw <- standard_grid()
  rewards <- gw$rewards
  rewards[rewards == 0] <- step.cost
  gw$rewards <- rewards
  gw
}


