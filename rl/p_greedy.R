#' Update mean
library(tidyr)
library(plotly)
library(foreach)

set.seed(7)

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
## Rewrite as S3 class 
# bandit <- function(m){
#   object <- list(m=m, 
#                  calculated.mean = 0,
#                  n = 0)
#   structure(object, class = "bandit")
# }
# 
# pull.bandit <- function(bandit){
#   rnorm(1) + bandit$m
# }
# 
# update <- function(bandit, x){
#   bandit$n <- bandit$n + 1
#   bandit$calculcated.mean <- update_mean(bandit$calculcated.mean,
#                                          x,
#                                          bandit$n)
# }

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

## Experiment
run_p_greedy <- function(m1, m2, m3, eps, N) {
  bandits <- list(bandit(m=m1), bandit(m=m2), bandit(m=m3))
  data <- vector("numeric", N)
  
  #browser()
  for(i in 1:N){
    # print(foreach(b=bandits) %do% b$cm %>% unlist())
    p <- runif(1)
    if(p < eps){
      j <- sample(3, 1)}
    else{
      j <- which.max(foreach(b=bandits) %do% b$cm)
    }
    x <- bandits[[j]]$pull()
    bandits[[j]]$update(x)
    data[i] <- x
    # print(paste0(x, " ", j, " "))
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
  
  p <- plot_ly()
      
  for(d in data){
    p <- p %>% 
      add_lines(x = 1:length(d), y = d)
  }  
  
  p <- p %>% 
    layout(shapes = lines, xaxis = list(type = "log"))
  p
}

c1 <- run_p_greedy(1, 2, 3, .1, 10000)
c2 <- run_p_greedy(1, 2, 3, .01, 1000)
c3 <- run_p_greedy(1, 2, 3, .05, 1000)
visualize(list(c1, c2, c3), 1, 2, 3)
          
