# Monte Calo policy evaluation
# W MC nie musimy iterować po wszystkich możliwych stanach
source("markov-decision-process/grid_world.R")
source("markov-decision-process/idx.R")
library(zeallot)
library(matricks)
  
  runif_same_dims <- function(mat, min = 0, max = 1){
    data <- runif(length(mat), min = min, max = max)
    matrix(data = data, nrow = nrow(mat), ncol = ncol(mat))
  }

first_visit_mc <- function(P, N){
  # Random initialization
  V <- runif_same_dims(P)
  V[is.null(P)] <- NULL
  
  
  # Sample mean
  # * nie trzeba za każdym razem liczyć średniej od nowa
  # * dla problemów niestacjonarnych można liczyć średnią ruchomą
  # * cnetralne twierdzenie graniczne
  # * vaiance estimate = variance of RV / N (RV = andom variable)
  all.returns <- list()
  
  for(episode in 1:N){
    c(states, returns) %<-% play_episode()
    
    for (idx in 1:length(states)){
      s <- states[[idx]]
      g <- returns[[idx]]
      
      if (!(s %in% names(all.returns))){
        all.returns[[s]] <- c(all.returns[[s]], g)
        # TODO: sample_mean
        at(V, s) <- sample_mean(all.returns[[s]])
      }
    }
  }
  return(V)
}

#' Calculating returns from rewards
#' Tutaj mam macierz nagód określoną z góry
#' W rzeczywistości sprawa może wyglądać zgoła inaczej.
#' Np. w szachach, nagrda nie aależy od stanięcia na jakimś polu, lecz
#' od wyniku gry. Przekazywanie obiektu `grid` to po prostu uproszczony model gry
#' @return states & returns
play_game <- function(actions, rewards, P, possible.actions, gamma = 0.9){
  
  max.iter <- length(P)
  
  #' We choose random start state
  set.seed(runif(1))
  start.state <- sample(matricks::matrix_idx(P, mask = possible.actions), 1)[[1]]
  states.and.rewards <- with_same_dims(P, list(NULL))
  at(states.and.rewards, start.state) <- 0
  
  
  s <- start.state
  is.game.over <- FALSE
  
  counter <- 0
  
  while (!is.game.over) {
    
    counter <- counter + 1 
    
    print(s)
    
    a <- at(P, s)[[1]]
    
    if(is.null(a))
      next
    
    if(!at(actions, a))
      next
    
    r <- at(rewards, a)
    s <- a
    states.and.rewards <- c(states.and.rewards, list(list(s, r)))
    
    if(!at(possible.actions, s) | counter >= max.iter){
      is.game.over <- TRUE
      next
    }
  }
  
  #' Obliczamy wartość dla całej przejdzionej drogi,
  #' zaczynając od końca
  
  G <- 0
  states.and.returns <- list()
  first <- TRUE
  
  for (sr in rev(states.and.rewards)){
    if (first)
      first <- FALSE
    else
      states.and.returns <- c(states.and.returns, list(list(s, G)))
    G <- r + gamma * G
  }
  return(states.and.returns)  
}

grid <- get_grid()
possible.actions <- grid$actions & (grid$rewards == -0.1)

P <- neighbour_idx_matrix(mat = P, 
                          mask = possible.actions, 
                          diagonal = FALSE, 
                          random.select = 1)

res <- play_game(actions = grid$actions,
          rewards = grid$rewards,
          possible.actions = possible.actions,
          P = P)
  



trollo <- function(matrix, min, max){
  browser()
  
}


