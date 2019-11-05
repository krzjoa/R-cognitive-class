agent <- R6Class(
  classname = 'agent',
  
  public = list(
    # Params
    symbol = NA,
    eps = 0,
    alpha = 0,
    value.function = NA,
    state.history = c(),
    
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
    
    take_action = function(env){
      # Taking an action based on epsilon-greedy strategy
      r <- runif(1)
      best.state <- NA
      possible.moves <- which(is.na(env$board %>% as.vector()))
      
      if(r < self$eps){
        idx <-  sample(possible.moves, 1)
        next.move <- possible.moves[idx]
      } else {
        next.move <- NA
        best.value <- -1
        tmp.board <- env$board
        for(i in possible.moves){
          tmp.board[i] <- self$symbol
          state.hash <- ttt_hash_state(tmp.board)
          
          browser()
          
          value <- self$value.function[self$value.function$hash == state.hash]
          cond <- value > best.value
          if(cond){
            best.value <- value
            best.state <- state.hash
            next.move <- i
          }
        }
      }
    },
    update_state_history = function(s){
      self$state.history <- c(self$state.history, s)
    },
    
    update = function(env){
      reward <- env$reward(self$sym)
      target <- reward
      for(prev in rev(self$state.history)){
        value <- self$value.function[prev] + self$alpha * (target - self$value.funcion[prerv])
        taget <- value
      }
      self$history <- c()
    }
    
  )
)


