library(magrittr)
library(R6)
library(ggplot2)

#' A class to store current state and check, if game is finished
tic_tac_toe <- R6Class(
  classname = 'tic_tac_toe',
  
  public = list(
    
    # Variables
    board = matrix(NA, 3, 3),
    winner = NULL,
    
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
      f(na_false(any(who.won == 0)| any(who.won == 1))){
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
      flattened.board <- self$board %>% as.vector()
      flattened.board[is.na(flattened.board)] <- 2
      sum((rep(3, 9) ** (8:0)) * flattened.board)
    },
    
    
            possible_turns = function(){

    }
    
  )
)

ttt_state_triples <- function(){
  x <- rep(list(c(NA, 0, 1)), 9)
  all.states <- expand.grid(x) 
  # Remove impossible states
  is_possible <- function(...){
    abs(sum(list(...) == 0, na.rm = TRUE) - sum(list(...) == 1, na.rm = TRUE)) < 2
  }  
    
  }
  
  filtered <-purrr::pmap(all.states, is_possible) %>% unlist()
  all.states %>% dplyr::filter(filtered) -> possible.states
  
  # Add is ended & winner
  
  
  
}

  #' Works on logical vetors
na_false <- function(x){
  ifelse(is.na(x), FALSE, x)
}


ttt <- tic_tac_toe$new()
ttt$board
ttt$get_state()

ttt$is_game_over()

ttt$board <- diag(3)

# apply(ttt$board, 2, var) %>% equals(0) %>% neg %>% any()
# 
# # Testing
# m <- matrix(NA, 3, 3)
# m[, 1] <- 1
# apply(m, 2, var)

ttt$board <- diag(3)

ttt$is_game_over()

if(NA){
  print("trolo")
}else{
  print('lolo')
}

