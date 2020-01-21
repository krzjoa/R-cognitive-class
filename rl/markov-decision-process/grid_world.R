library(matricks)

grid_world <- R6::R6Class(	
  classname = 'grid_world',	
  
  public = list(	
    
    # Default values	
    i = 1,	
    j = 1,	
    rewards = NA, 	
    actions = NA, # Possible actions	
    
    initialize = function(actions, rewards, start){	
      
      if (!identical(dim(actions), dim(rewards)))	
        stop("Matrices have different shapes!")	
      
      self$actions <- actions	
      self$rewards <- rewards	
      self$i <- start[1]	
      self$j <- start[2]	
    },	
    
    set_state = function(s){	
      self$i <- s[1]	
      self$j <- s[2]	
    },	
    
    is_terminal = function(s){	
      self$actions[s[1], s[2]]	
    },	
    
    game_over = function(){	
      !self$actions[self$i, self$j]	
    }	
  )	
)


standard_grid <- function(){
  gw <- grid_world$new(6, 5, c(1, 1))
  
  actions <- m(T, T, T, F, T|
               T, T, F, T, T|
               F, T, T, T, T|
               T, T, T, T, T|
               F, F, T, T, T|
               F, T, T, T, F)
  plot(actions)
  # Defining rewards matrix with two terminal states
  rewards <- with_same_dims(actions, 0)
  rewards <- sv(rewards,
                c(4, 4) ~ 1., # Win
                c(5, 3) ~ -1) # Lose
  # We add small penalties, which encourages models
  # to reduce number of steps it passes 
  rewards[rewards == 0] <- -0.1

  # List of possible state indices
  # states <- matrix_idx(actions, actions)
  # 
  # m(T, T, T, F, T|
  #   T, T, F, T, T|
  #   F, T, T, T, F|
  #   T, T, T, T, T|
  #   F, F, T, T, T|
  #   F, T, T, T, F) -> actions
  # 
  # rewards <- matrix(0, 6, 5)
  # rewards <- set_values(rewards, 
  #                       c(4, 4) ~ 1.,
  #                       c(5, 3) ~ -1)  
  
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

get_grid <- function(){
  
    actions2 <- m(T, T, T, T|
                  T, F, T, T|
                  T, T, T, T)
  
    rewards2 <- with_same_dims(actions2, 0)
    rewards2 <- sv(rewards2,
                  c(1, 4) ~ 1.,
                  c(2, 4) ~ -1)
    rewards2[rewards2 == 0] <- -0.1
  
    grid <- grid_world$new(actions = actions2,
                           rewards = rewards2,
                           start = c(1, 1))
    grid
}


