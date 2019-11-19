library(R6)

grid_world <- R6Class(
  classname = 'grid_world',
  
  public = list(
    
    width = 5,
    height = 5,
    i = 0,
    j = 0,
    board = NA, 
    rewards = NA,
    
    initialize = function(width, height, start){
      self$width <- width
      self$height <- height
      self$i <- start[1]
      self$j <- start[2]
      
      self$board <- matrix(0, nrow = height, 
                           ncol = width)
    },
    
    set = function(actions, rewards){
      self$rewawrds <- rewards
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
      if(self$actions[action[1], action[2]]){
        switch (action,
          U = {self$i <- self$i - 1},
          D = {self$i <- self$i + 1},
          R = {self$i <- self$j + 1},
          L = {self$i <- self$j - 1},
        )
      }
      self$rewards[self$i, self$j]    
    },
    
    undo_move = function(action){
      if(self$actions[action[1], action[2]]){
        switch (action,
                U = {self$i <- self$i + 1},
                D = {self$i <- self$i - 1},
                R = {self$i <- self$j - 1},
                L = {self$i <- self$j + 1},
        )
      }
      self$rewards[self$i, self$j]    
    },
    
    game_over = function(){
      !self$actions[self$i, self$j]
    },
    
    
    
)
  
)





gw <- grid_world$new(10, 5, c(0, 0))


