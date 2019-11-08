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
        next.move <-  sample(possible.moves, 1)
      } else {
        next.move <- NA
        best.value <- -1
        
        for(i in possible.moves){
          tmp.board <- env$board
          tmp.board[i] <- self$symbol
          state.hash <- ttt_hash_state(tmp.board)
          
          value <- self$value.function[self$value.function$hash == state.hash, ]$value
          cond <- value > best.value
          
          if(cond){
            best.value <- value
            best.state <- state.hash
            next.move <- i
          }
        }
      }
      env$board[next.move] <- self$symbol
    },
    update_state_history = function(s){
      self$state.history <- c(self$state.history, s)
    },
    
    update = function(env){
      reward <- env$reward(self$symbol)
      target <- reward
      for(prev in rev(self$state.history)){
        # Value function update
        previous.state <- self$value.function[self$value.function$hash == prev, ]$value
        value <- previous.state + self$alpha * (target - previous.state)
        self$value.function[self$value.function$hash == prev, ]$value <- value
        taget <- value
      }
      self$state.history <- c()
    }
    
  )
)


