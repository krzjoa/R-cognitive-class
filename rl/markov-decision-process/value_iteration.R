#' Rożnica: nie trzeba czekać, aż dokonamy ewaluacji polityki 
#' przez stwierdzenie, że polityka ta zbiega
#' Dwa kroki:
#' 1. Znajdujemy optymalną funkcję wartości
#' 2. Dobieramy do tego odpowiednią politykę
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

optimal_value_function <- function(actions, rewards, possible.actions, 
                                   gamma = 0.9, epsilon = 0.001) {
  # Zero w stanach końcoych dodane dla wygody, naprawdę nie ma tam wartości
  V <- with_same_dims(actions, 0)
  V[possible.actions] <- runif(sum(possible.actions))
  
  while (TRUE) {
    biggest.change <- 0
    
    for (ac in seq_matrix(possible.actions)) {
      state <- ac[[1]]
      value <- ac[[2]]
      old.v <- at(V, state)
      
      if(!value)
        next
      
      new.v <- - Inf
      
      for (pa in quasi_possible(state)){
        
        if(!is_idx_possible(actions, pa))
          next
        
        r <- at(rewards, pa)
        v <- r + gamma * at(V, pa)
        # print(paste0(r, " ", at(V, pa), " ", gamma, " ", at(V, pa)))
        
        if (v > new.v)
          new.v <- v
      }
      at(V, state) <- new.v
      biggest.change <- max(biggest.change, abs(old.v - at(V, state)))
    }
    print(biggest.change)
    if (biggest.change < epsilon)
      break
  }
  V
}


optimal_policy <- function(actions, rewards, possible.actions,
                           V, P, gamma = 0.9){
  for (p in seq_matrix(possible.actions)){
    s <- p[[1]]
    val <- p[[2]]

    best.a <- NULL
    best.value <- -Inf
    
    if (!val)
      next
    
    for (pa in quasi_possible(s)){
      
      if (!is_idx_possible(possible.actions, pa))
        next
    
      r <- at(rewards, pa)
      v <- r + gamma * at(V, pa)
 
      if (v > best.value){
        best.value <- v
        best.a <- pa
      }
      at(P, s) <- list(best.a)
    }
  }
  P
}



value_iteration <- function(gamma = 0.9){
  # Step 1
  grid <- get_grid()
  possible.actions <- grid$actions & (grid$rewards == -0.1)
  
  P <- neighbour_idx_matrix(mat = P, 
                            mask = possible.actions, 
                            diagonal = FALSE, 
                            random.select = 1)

  # Repeating until convergence
  V <- optimal_value_function(actions = grid$actions,
                              rewards = grid$rewards, 
                              possible.actions = possible.actions)
  
  P <- optimal_policy(actions = grid$actions,
                      rewards = grid$rewards,
                      possible.actions = possible.actions,
                      V = V, P = P)
  
  print("Values: ")
  print(V)
  print("Policy:")
  print(as.data.frame(P))
}

value_iteration()
    