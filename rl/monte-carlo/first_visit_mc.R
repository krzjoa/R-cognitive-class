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
  
# First unique value
first_unique <- function(tuple.list){
  first.elem <- purrr::map(tuple.list, ~ .x[[1]])
  first.uniques <- !duplicated(first.elem)
  tuple.list[first.uniques]
}


#' Calculating returns from rewards
#' Tutaj mam macierz nagód określoną z góry
#' W rzeczywistości sprawa może wyglądać zgoła inaczej.
#' Np. w szachach, nagrda nie aależy od stanięcia na jakimś polu, lecz
#' od wyniku gry. Przekazywanie obiektu `grid` to po prostu uproszczony model gry
#' @return states & returns
play_game <- function(actions, rewards, P, possible.actions, gamma = 0.9){
  
  # TODO: states.rewads - mieszam typy, raz macierz, raz lista
  max.iter <- length(P)
  
  #' We choose random start state
  start.state <- sample(matricks::matrix_idx(P, mask = possible.actions), 1)[[1]]
  states.and.rewards <- list(list(start.state, 0)) #with_same_dims(P, list(NULL))
  # at(states.and.rewards, start.state) <- 0
  
  s <- start.state
  is.game.over <- FALSE
  
  counter <- 0
  
  while (!is.game.over) {
    
    counter <- counter + 1 
    
    # print(s)
    
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
    # print("Hey")
    # print(sr)
    c(s, r) %<-% sr
    # print(s)
    if (first)
      first <- FALSE
    else
      states.and.returns <- c(states.and.returns, list(list(s, G)))
    G <- r + gamma * G
  }
  return(states.and.returns)  
}


run_first_mc <- function(P, iter = 100){
  grid <- get_grid()
  possible.actions <- grid$actions & (grid$rewards == -0.1)

  V <- with_same_dims(P, 0)
  
  # Already seen states
  seen.states <- with_same_dims(P, FALSE)
  returns     <- with_same_dims(P, list(NULL))
  
  # Sample mean
  # * nie trzeba za każdym razem liczyć średniej od nowa
  # * dla problemów niestacjonarnych można liczyć średnią ruchomą
  # * cnetralne twierdzenie graniczne
  # * vaiance estimate = variance of RV / N (RV = andom variable)
  for (i in 1:iter) {
    res <- play_game(actions = grid$actions,
                     rewards = grid$rewards,
                     possible.actions = possible.actions,
                     P = P)
    
    for (i in 1:length(res)) {
      c(s, G) %<-% res[[i]]
      if (!at(seen.states, s)){
        at(returns, s)[[1]] <- c(at(returns, s), list(G))
        at(V, s) <- mean(unlist(at(returns, s)[[1]]))
        at(seen.states, s) <- TRUE
      }
    }
  }
  print(possible.actions)
  print(V)
  print(as.data.frame(P))
}

set.seed(9)

P <- neighbour_idx_matrix(mat = possible.actions, 
                          mask = possible.actions, 
                          diagonal = FALSE, 
                          random.select = 1)
run_first_mc(P, 100)

