source("markov-decision-process/grid_world.R")
source("markov-decision-process/idx.R")
library(zeallot)
library(matricks)

# Wnioski: może chodzi o inicjalizację?
  
evaluate_policy <- function(actions, rewards, policy, 
                            epsilon = 1e-3, gamma = 0.9){
  
  V <- with_same_dims(policy, 0)
  # policy.idx <- as_idx(policy)
  
  while (TRUE) {
    biggest.change <- 0
    
    for (move in seq_matrix(policy)) {
      s <- move[[1]] # Action, value at index s
      a <- move[[2]]
      
      old.v <- at(V, s)
      
      if(!at(actions, s))
        next
      
      if(is.null(a))
        next
      
      r <- at(rewards, a)
      at(V, s) <- r + gamma * at(V, a)
      biggest.change <- max(biggest.change, abs(old.v - at(V, s)))
    }
    
    # print(biggest.change)
    
    if (biggest.change < epsilon){
      break
    }
  }
  return(V)
}  


policy_iteration <- function(gamma = 0.9){
  # Step 1
  grid <- get_grid()
  # states <- matrix_idx(grid$actions, 
  #                      grid$actions)
  possible.actions <- grid$actions & (grid$rewards == -0.1)

  # Step 2
  # Initialize value function
  V <-  with_same_dims(grid$actions, 0) 
  V[possible.actions] <- runif(sum(possible.actions))
  
  # Initalize policy  
  # Policy should describe actions, i.e: left, right itp.
  # elems <- c('U', 'D', 'R', 'L')

  
  P <- with_same_dims(grid$actions, NA) 
  # P[possible.actions] <- sample(elems, sum(possible.actions), replace = TRUE)
  
  set.seed(7)
  P <- neighbour_idx_matrix(mat = P, 
                             mask = possible.actions, 
                            diagonal = FALSE, random.select = 1)
  
  i.while <- 0
  
  # Repeating until convergence
  while (TRUE) {
    
    i.while <- i.while + 1
    print(i.while)

    V <- evaluate_policy(actions = grid$actions,
                         rewards = grid$rewards,
                         policy = P)
    
    is.policy.converged <- TRUE

    for (move in seq_matrix(grid$actions)) {
      s <- move[[1]] # Action, value at index s
      val <- move[[2]]
      
      # print(c("Place:", s))
      
      if(!val)
        next
      
      if (!is.null(at(P, s)[[1]])) {
        old.a <- at(P, s)[[1]]
        new.a <- NULL
        best.value <- -Inf
        
        possible.transitions <- neighbour_idx(possible.actions, 
                                              idx = s,
                                              mask = grid$actions,
                                              diagonal = FALSE)

        for (a in possible.transitions) {
          r <- at(grid$rewards, a)
          v <- r + gamma * at(V, a)
          
          #print(c(a, r, at(V, a)))
          #print(paste0("Best value ", best.value, " ", v))
          
          # browser()
          
          if (v > best.value) {
            best.value <- v
            new.a <- a
          }
        }
        
        at(P, s) <- list(new.a)
        if (any(new.a != old.a))
          is.policy.converged <- FALSE
      }
      }
    
    if (is.policy.converged)
      break
    
    print("Values: ")
    print(V)
    print("Policy:")
    print(P)
  }
  
  print("Values: ")
  print(V)
  print("Policy:")
  print(as.data.frame(P))
}



policy_iteration()
