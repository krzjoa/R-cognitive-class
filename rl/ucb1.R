#' Update mean
library(tidyr)
library(plotly)
library(foreach)

source("rl/p_greedy.R")

set.seed(7)

## Experiment
run_ucb <- function(m1, m2, m3, N, alpha=0.0001) {
  bandits <- list(bandit(m=m1, n=alpha), 
                  bandit(m=m2, n=alpha), 
                  bandit(m=m3, n=alpha))
  data <- vector("numeric", N)
  
  for(i in 1:N){
    j <- which.max(foreach(b=bandits) %do% (b$cm + sqrt(2*log(i) / b$n)))
    x <- bandits[[j]]$pull()
    bandits[[j]]$update(x)
    data[i] <- x
  }
  cumulative.average <- cumsum(data) / (1:N)
  cumulative.average
}


c1 <- run_p_greedy(1, 2, 3, .01, 10000)
c2 <- run_ucb(1, 2, 3, 1000)
visualize(list(c1, c2), 1, 2, 3)
          
