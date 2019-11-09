human <- R6Class(
  classname = 'human',
  
  public = list(
    take_action = function(env){
      
    }
  )
  
)

cpu <- player2
cpu.player <- agent$new()
cpu.player$symbol <- 0
cpu.player$value.function <- player2$value.function


play_vs_cpu <- function(cpu){
  
  symbol <- -1
  env <- tic_tac_toe$new()
  human <- list(symbol = 1)
  
  while(!env$is_game_over()){
    
    print(env$board)
    
    if(symbol == cpu$symbol){
      cpu$play(env)
      symbol <- human$symbol
    } else {
      move <- readline()
      move <- strsplit(move, ",") %>% unlist() %>% as.numeric()
      env$board[move[1], move[2]] <- 1
      symbol <- cpu$symbol
    }
  }
  
  print(env$board)
  
  print("Game over!")
  print("Winner: ", env$winner)
  
}


play_vs_cpu(cpu.player)
