#' Update mean
update_mean <- function(old.mean, X, N){
  (1-1/N)*old.mean + X/N
}

  trololo <- function(x){
    structure(x, class = "trololo")
  }

# z <- c(1,3,4,5,6,7,8,9,10)
# mean(z)
# old.mean <- mean( z[1:(length(z)-1)])
# old.mean
# update_mean(old.mean, 10, length(z))

### S4 Class
casino.machine <- function(){
  object <- list(win.probability = runif(1, 0, 1))
  structure(object, class = "casino.machine")
}

pull <- function(casino.machine){
  UseMethod("pull")
}

pull.default<- function(casino.machine){
  rbinom(1, 1, casino.machine$win.probability)
}

bandit1 <- casino.machine()
bandit2 <- casino.machine()

pull(bandit1)
bandit1$win.probability
