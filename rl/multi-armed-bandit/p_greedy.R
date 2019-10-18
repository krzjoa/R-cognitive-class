#' Update mean
library(tidyr)
library(plotly)
library(foreach)

source('rl/bandit.R')

set.seed(7)


## Experiment
run_p_greedy <- function(m1, m2, m3, eps, N) {
  bandits <- list(bandit(m=m1), bandit(m=m2), bandit(m=m3))
  data <- vector("numeric", N)
    
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

# c1 <- run_p_greedy(1, 2, 3, .1, 10000)
# c2 <- run_p_greedy(1, 2, 3, .01, 1000)
# c3 <- run_p_greedy(1, 2, 3, .05, 1000)
# visualize(list(c1, c2, c3), 1, 2, 3)
          
