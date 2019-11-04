# play_game <- function(p1, p2, env, draw=FALSE){
#   current.player <- NA
#   # Przechodzimy pętlę, póki gra się nie skończyła
#   while(!env$game_over()){
#     if(current.player == p1)
#       current.player <- p2
#     else
#       current.player <- p1
#   }
#   
#   if(draw){
#     if(draw == 1 & current.player == p1){
#       env$draw_board()
#     }
#     if(draw == 2 & current.player == p2){
#       env$draw_board()
#     }
#   }
#   # player makes a move
#   current.player$take_action(env)
#   
#   # Update state histories
#   state <- env$get_state()
#   p1$update_state_history(state)
#   p2$update_state_history(state)
#   
#   if(draw)
#     env$draw_board()
#   
#   # Update value function
#   p1$update(env)
#   p2$update(env)
# }
# 
# 
# diag(3) %>% antidiagonal()

agent <- R6Class(
  classname = 'agent',
  
  public = list(
    # Params
    symbol = NA,
    eps = 0,
    alpha = 0,
    value.function = NA,
    state.history = list(),
    
    initialize = function(eps=0.1, alpha=0.5){
      self$eps <- eps
      self$alpha <- alpha
    },
    
    set_value_function = function(V){
      self$value.function = V
    },
    
    set_symbol = function(symbol){
      self$symbol <- symbol
    },
    
    take_action <- function(env){
      # Taking an action based on epsilon-greedy strategy
      r <- runif(1)
      best.state <- NA
      
      if(r < self$eps)
        possible.moves <- list()
        for(i in 1:9){
          for(j in 1:9){
            
          }
        }
    }
    
  )
)


