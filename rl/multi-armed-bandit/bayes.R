
run_bayes <- function(m1, m2, m3, N){
  bandits <- list(bayesian.bandit(m1),
                  bayesian.bandit(m2),
                  bayesian.bandit(m3))
  data <- vector("numeric", N)
  
  for(i in 1:N){
    j <- which.max(foreach(b=bandits) %do% b$sample())
    x <- bandits[[j]]$pull()
    bandits[[j]]$update(x)
    data[i] <- x
  }
  cumulative.average <- cumsum(data) / (1:N)
  cumulative.average
}

bayes <- run_bayes(1.0, 2.0, 3.0, 100000)
