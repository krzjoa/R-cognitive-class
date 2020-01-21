source("markov-decision-process/grid_world.R")
source("markov-decision-process/idx.R")
library(zeallot)
library(matricks)


quasi_possible <- function(idx){
  list(U = c(idx[1] + 1, idx[2]),
       D = c(idx[1] - 1, idx[2]),
       R = c(idx[1], idx[2] + 1),
       L = c(idx[1], idx[2] - 1))
}


evaluate_policy <- function(actions, rewards, policy, possible.actions,
                            epsilon = 1e-3, gamma = 0.9){
  
  V <-  with_same_dims(actions, 0) 
  V[possible.actions] <- runif(sum(possible.actions))

  while (TRUE) {
    biggest.change <- 0
    
    for (move in seq_matrix(actions)) {

      s <- move[[1]] # Action, value at index s
      possible <- move[[2]]
      
      old.v <- at(V, s)
      # New v value if computed by iterating over possibilities
      new.v <- 0
      
      if(!at(possible.actions, s))
        next
      
      for (pa in quasi_possible(s)){
        if (at(policy, s) == pa)
          p <- 0.5
        else
          p <- 0.5 / 3
        
        if (!is_idx_possible(actions, pa))
          next
        
        if (at(actions, pa))
          next
        
        r <- at(rewards, a)
        new.v <- new.v + p* (r + gamma * at(V, pa))
      }
      at(V, s) <- new.v
      biggest.change <- max(biggest.change, abs(old.v - at(V, s)))
    }
    
    if (biggest.change < epsilon){
      break
    }
  }
  return(V)
}  


policy_iteration <- function(gamma = 0.9){
  # Step 1
  grid <- get_grid()
  possible.actions <- grid$actions & (grid$rewards == -0.1)

  # Initalize policy  
  set.seed(7)
  P <- neighbour_idx_matrix(mat = possible.actions, 
                            mask = possible.actions, 
                            diagonal = FALSE, random.select = 1)
  i.while <- 0
  
  # Repeating until convergence
  while (TRUE) {
    
    i.while <- i.while + 1
    print(i.while)
    
    V <- evaluate_policy(actions = grid$actions,
                         rewards = grid$rewards,
                         policy = P,
                         possible.actions = possible.actions)
    
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
