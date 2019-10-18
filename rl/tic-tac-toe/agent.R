library(R6)

agent <- R6Class(
  classname = 'agent',
  
  public = list(
    
  )
)

# MApping tic-tac-toe states to numbers
ttt.states.mapping <- {
  f
}


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