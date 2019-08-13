#' Update mean
update_mean <- function(old.mean, X, N){
  (1-1/N)*old.mean + X/N
}


### S3 Class
multiarm.bandit <- function(n.arms=1){
  object <- list(win.probability=runif(n.arms))
  structure(object, class = "multiarm.bandit")
}  

pull <- function(multiarm.bandit){
  UseMethod("pull", multiarm.bandit)
}

pull.multiarm.bandit <- function(multiarm.bandit){
  rbinom(length(multiarm.bandit$win.probability), 1, 
         multiarm.bandit$win.probability)
}

## Bandit for experiment
## Rewrite as S4 class 
bandit <- function(m){
  object <- list(m=m, 
                 calculated.mean = 0,
                 n = 0)
  structure(object, class = "bandit")
}

pull.bandit <- function(bandit){
  rnorm(1) + bandit$m
}

update <- function(bandit, x){
  bandit$n <- bandit$n + 1
  bandit$calculcated.mean <- update_mean(bandit$calculcated.mean,
                                         x,
                                         bandit$n)
  }


## Experiment
run_experiment <- function(m1, m2, m3, eps, N) {
  library(foreach)
  bandits <- list(bandit(m1), bandit(m2), bandit(m3))
  data <- vector("numeric", N)
  
  #browser()
  for(i in 1:N){
    print(foreach(b=bandits) %do% b$calculated.mean %>% unlist())
    # epsilon gready
    p <- rnorm(1)
    if(p < eps){
      j <- sample(3, 1)}
    else{
      j <- which.max(foreach(b=bandits) %do% b$calculated.mean)
    }
    x <- pull(bandits[[j]])
    update(bandits[[j]], x)
    data[i] <- x
    print(paste0(x, " ", j, " "))
  }
  #browser()
  cumulative.average <- cumsum(data) / (1:N)
  cumulative.average
}


visualize <- function(data, m1, m2, m3){
  
  line <- list(
    type = "line",
    line = list(color = "pink"),
    xref = "x",
    yref = "y"
  )
  
  lines <- list()
  for (i in c(m1, m2, m3)) {
    line[["x0"]] <- 1
    line[["x1"]] <- length(c1)
    line[c("y0", "y1")] <- i
    lines <- c(lines, list(line))
  }
  
  plot_ly() %>% 
    add_lines(x = 1:length(c1), y = data) %>% 
    layout(shapes = lines)
}


c1 <- run_experiment(1, 2, 3, .01, 1000)
visualize(c1, 1, 2, 3)
  
