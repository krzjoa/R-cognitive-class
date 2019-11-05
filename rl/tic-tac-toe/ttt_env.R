library(magrittr)
library(R6)
library(ggplot2)


#' A class to store current state and check, if game is finished
tic_tac_toe <- R6Class(
  classname = 'tic_tac_toe',
  
  public = list(
    
    # Variables
    board = matrix(NA, 3, 3),
    winner = NA,
    
    # Methods
    is_game_over = function(){
      
      # Columns
      who.won <- apply(self$board, 2, mean)
      if(na_false(any(who.won == 0)| any(who.won == 1))){
        self$winner <- who.won[(who.won == 0) | (who.won == 1)]
        return(TRUE)
      }
      
      # Rows
      who.won <- apply(self$board, 1, mean)
      if(na_false(any(who.won == 0)| any(who.won == 1))){
        self$winner <- who.won[(who.won == 0) |( who.won == 1)]
        return(TRUE)
      }
       
      # Diagonal
      who.won <- mean(diag(self$board))
      if(na_false(who.won == 0 | who.won == 1)){
        self$winner <- who.won
        return(TRUE)
      }

      # Antidiagonal
      who.won <- mean(antidiagonal(self$board))
      if(na_false(who.won == 0 | who.won == 1)){
        self$winner <- who.won
        return(TRUE)
      }

      # Game is over, if all the places are busy
      if(all(!is.na(self$board)))
        return(TRUE)
      
      return(FALSE)
    },
    
    #' Each state is mapped to a single integer number
    get_state = function(){
      ttt_hash_state(self$board)
    },
      
    reward = function(sym){
      if(!self$is_game_over())
        return(0)

    if(self$winner == sym) 
      return(1)
    else
      return(0)
    },
    
    print_board = function(){
      
    }
    
  )
)

#' NA = 2
ttt_hash_state <- function(board){
  flattened.board <- board %>% as.vector()
  flattened.board[is.na(flattened.board)] <- 2
  sum((rep(3, 9) ** (8:0)) * flattened.board)
}

#' @title Get the winner
#' @name ttt_get_winner
#' @description 
#' Gets the winner of the tic-tac-toe game
#' @return 
ttt_get_winner <- function(board){
  
  if(class(board) != 'vector')
    board <- matrix(board, nrow = 3, ncol = 3)
  
  # Columns
  who.won <- apply(board, 2, mean)
  if(na_false(any(who.won == 0)| any(who.won == 1))){
    winner <- who.won[na_false(who.won == 0 | who.won == 1)]
    return(winner)
  }
  
  # Rows
  who.won <- apply(board, 1, mean)
  if(na_false(any(who.won == 0)| any(who.won == 1))){
    winner <- who.won[na_false(who.won == 0 | who.won == 1)]
    return(winner)
  }
  
  # Diagonal
  who.won <- mean(diag(board))
  if(na_false(who.won == 0 | who.won == 1)){
    return(who.won)
  }
  
  # Antidiagonal
  who.won <- mean(antidiagonal(board))
  if(na_false(who.won == 0 | who.won == 1)){
    return(who.won)
  }
  return(NA)
}

#' @title Check, if tic-tac-toe state is possible
#' @name ttt_is_state_possible
#' @param board matrix or vector
#' @description 
#' Generally, there are two type of states that are not possible
#' on the tic-tac-toe board:
#' * One player put more symbols than the second one
#' * There are two lines of nougths or crosses
#' @return logical value 
ttt_is_state_possible <- function(board){
  
  if(class(board) != 'vector')
    board <- matrix(board, nrow = 3, ncol = 3)
  
  # 1st condition: number of turns made by one player
  is.possible.1 <- abs(sum(board == 0, na.rm = TRUE) - sum(board == 1, na.rm = TRUE)) < 2
    
  # 2nd condition: two players cannot win in the same time
  is.possible.2 <- sum(apply(board, 1, var) == 0, na.rm = TRUE) < 2
  
  # columns
  is.possible.3 <- sum(apply(board, 2, var) == 0, na.rm = TRUE) < 2
  
  return(is.possible.1 & is.possible.2 & is.possible.3)
}


#' @title Triples for tic-tac-toe with possible states and answer: is game ended?
#' @name ttt_state_triples
ttt_state_triples <- function(){
  x <- rep(list(c(NA, 0, 1)), 9)
  all.states <- expand.grid(x) 
  
  is_possible <- function(...) ttt_is_state_possible(unlist(list(...)))

  # TODO: optimize!!!
  filtered <-purrr::pmap(all.states, is_possible) %>% unlist()
  possible.states <- all.states %>% dplyr::filter(filtered)
   
  # Add is ended & winner
  is.ended <- !is.na(purrr::pmap(possible.states, sum))
  
  # Get winner
  who.won.unlisted <- function(...) ttt_get_winner(unlist(list(...)))
  who.won <- purrr::pmap(possible.states, who.won.unlisted) %>% unlist()
  
  is.ended <- ifelse(is.ended, is.ended, (!is.na(who.won)))
  
  # Get state hashes
  hashes <- purrr::pmap(possible.states, function(...) ttt_hash_state(unlist(list(...)))) %>% unlist()
  data.frame(hash = hashes, is.ended = is.ended, who.won = who.won)
}

ps <- ttt_state_triples()

#' Works on logical vetors
na_false <- function(x){
  ifelse(is.na(x), FALSE, x)
}

#' @title Init value function
#' @name ttt_init_value_function
#' @description 
#' Inits value 
ttt_init_value_function <- function(state_triples, player){
  player <- if(player == 'x') 1 else 0
  value.function <- dplyr::case_when(
    state_triples$who.won == player ~ 1,
    is.na(state_triples$who.won) & state_triples$is.ended ~ 0,
    !state_triples$is.ended ~ 0.5,
    state_triples$who.won != player ~ 0
  )
  cbind(state_triples, value.function)
}

ps <- ttt_state_triples()
st <- ttt_init_value_function(ps, player = 'x')

ttt <- tic_tac_toe$new()
ttt$board
ttt$get_state()
ttt$is_game_over()

ttt$board <- diag(3)

ttt$reward(sym = 1)
