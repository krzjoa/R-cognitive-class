library(magrittr)
library(R6)
library(ggplot2)

#' Works on logical vetors
na_false <- function(x){
  ifelse(is.na(x), FALSE, x)
}

#' A class to store current state and check, if game is finished
tic.tac.toe <- R6Class(
  classname = 'tic.tac.toe',
  
  public = list(
    
    # Variables
    board = matrix(NA, 3, 3),
    
    # Methods
    is_game_over = function(){
      # Game is over, if all the places are busy
      if(all(!is.na(self$board)))
        return(TRUE)
      # Columns
      if(apply(self$board, 2, var) %>% equals(., 0) %>% na_false %>% any())
        return(TRUE)
      # Rows
      if(apply(self$board, 1, var) %>% equals(., 0) %>% na_false %>% any())
        return(TRUE)
      # Diagonal
      if((var(diag(self$board)) == 0) %>% na_false)
        return(TRUE)
      # Antidiagonal
      if((var(antidiagonal(self$board)) == 0) %>% na_false)
        return(TRUE)
      return(FALSE)
    },
    
    get_state = fucntion(){
      
    }
    
  )
)

ttt <- tic.tac.toe$new()
ttt$board

ttt$is_game_over()

ttt$board <- diag(3)

apply(ttt$board, 2, var) %>% equals(0) %>% neg %>% any()

# Testing
m <- matrix(NA, 3, 3)
m[, 1] <- 1
apply(m, 2, var)



ttt$board <- diag(3)

ttt$is_game_over()

diag(3) %>% antidiagonal()


  agent <- R6Class(
  classname = 'agent',
  
  public = list(
    
  )
)

# Mapping tic-tac-toe states to numbers
ttt.states.mapping <- matrix(NA, 3, 3)

  # plot_board <- function(board){
  #   ggplot(boad, aes(x = Var2, y = Var1)) +
  #     geom_
  # }


play_game <- function(p1, p2, env, draw=FALSE){
  current.player <- NA
  # Przechodzimy pętlę, póki gra się nie skończyła
  while(!env$game_over()){
    if(current.player == p1)
      current.player <- p2
    else
        current.player <- p1
  }
  
  if(draw){
    if(draw == 1 & current.player == p1){
      env$draw_board()
    }
    if(draw == 2 & current.player == p2){
      env$draw_board()
    }
  }
  # player makes a move
  current.player$take_action(env)
  
  # Update state histories
  state <- env$get_state()
  p1$update_state_history(state)
  p2$update_state_history(state)
  
  if(draw)
    env$draw_board()
  
  # Update value function
  p1$update(env)
  p2$update(env)
}