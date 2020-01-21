source("markov-decision-process/grid_world.R")
source("markov-decision-process/idx.R")
library(matricks)

# W przypadku "zwykłego" RL, gdzie przejścia między stanami są deterministyczne,
# wystarczy nam tylko funkcja wartości (value function)

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

iterative_policy_evaluation1()
    