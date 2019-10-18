update_mean <- function(old.mean, X, N){
  (1-1/N)*old.mean + X/N
}

bandit <- setRefClass(
  "bandit",
  
  fields = list(
    m = "numeric",
    cm = "numeric",
    n = "numeric"
  ),
  
  methods = list(
    initialize = function(m, upper_limit=0, n=0){
      m <<- m
      cm <<- upper_limit
      n <<- n
    },
    
    pull = function(){
      rnorm(1) + .self$m
    },
    
    update = function(x){
      n <<- .self$n + 1
      cm <<- update_mean(.self$cm, x, .self$n)
    }
  )
)


bayesian.bandit <- setRefClass(
  "bayesian.bandit",
  
  fields = list(
    m = "numeric", # real values 
    # parameters for mu = prior; N(0, 1)
    m0 = "numeric", # computed values ()
    lambda0 = "numeric",
    sum.x = "numeric",
    tau = "numeric"
  ),
  
  methods = list(
    initialize = function(m){
      m <<- m
      m0 <<- 0
      lambda0 <<- 1
      sum.x <<- 0
      tau <<- 1
    },
    
    pull = function(){
      rnorm(1) + .self$m
    },
    
    sample = function(){
      rnorm(1) / sqrt(.self$lambda0) + .self$m0
    },
    
    update = function(x){
      lambda0 <<- .self$lambda0 + 1
      sum.x <<- .self$sum.x + x
      m0 <<- .self$tau + .self$sum.x / .self$lambda0
    }
  )
)

