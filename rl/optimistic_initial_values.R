#' Update mean
library(tidyr)
library(plotly)
library(foreach)

source("rl/bandit.R")

set.seed(7)

## Experiment
run_oiv <- function(m1, m2, m3, N, upper_limit) {
  bandits <- list(bandit(m=m1), 
                  bandit(m=m2), 
                  bandit(m=m3))
  data <- vector("numeric", N)
  
  for(i in 1:N){
    j <- which.max(foreach(b=bandits) %do% b$cm)
    x <- bandits[[j]]$pull()
    bandits[[j]]$update(x)
    data[i] <- x
  }
  cumulative.average <- cumsum(data) / (1:N)
  cumulative.average
}


# run_oiv <- function(m1, m2, m3, N, upper_limit) {
#   bandits <- list(bandit(m=m1, upper_limit=upper_limit), 
#                   bandit(m=m2, upper_limit=upper_limit), 
#                   bandit(m=m3, upper_limit=upper_limit))
#   data <- vector("numeric", N)
#   
#   for(i in 1:N){
#     j <- which.max(foreach(b=bandits) %do% b$cm)
#     x <- bandits[[j]]$pull()
#     bandits[[j]]$update(x)
#     data[i] <- x
#   }
#   #browser()
#   cumulative.average <- cumsum(data) / (1:N)
#   cumulative.average
# }

# c1 <- run_p_greedy(1, 2, 3, .01, 10000)
# c2 <- run_oiv(1, 2, 3, 1000, 10)
# visualize(list(c1, c2), 1, 2, 3)