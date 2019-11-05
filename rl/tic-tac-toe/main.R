play_game <- function(p1, p2, env, draw=FALSE){
  current.player <- list(symbol = 5)
  
  # Przechodzimy pętlę, póki gra się nie skończyła
  while(!env$is_game_over()){
    
    if(current.player$symbol == p1$symbol){
      current.player <- p2
    } else {
      current.player <- p1
    }

    # player makes a move
    current.player$take_action(env)
  
    # Update state histories
    state <- env$get_state()
    p1$update_state_history(state)
    p2$update_state_history(state)
  }

  # Update value function
  p1$update(env)
  p2$update(env)
}


# Create two agents
player1 <- agent$new()
player2 <- agent$new()

# Environment
ttt <- tic_tac_toe$new()
state.winner.triples <- ttt_state_triples()

value.function.x <- ttt_init_value_function(state_triples = state.winner.triples,
                                            player = 'x')
player1$set_value_function(value.function.x)
player1$set_symbol(1)

value.function.o <- ttt_init_value_function(state_triples = state.winner.triples,
                                            player = 'o')
player2$set_value_function(value.function.o)
player2$set_symbol(0)

T <- 1000

for(t in 1:T){
  play_game(player1, player2, env = ttt)
}

