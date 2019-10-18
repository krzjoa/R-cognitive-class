library(ggplot2)
library(magrittr)

plot_beta_distribution <- function(a, b){
  linspace <- seq(0, 1, length.out = 200)
  beta.distribution <- dbeta(linspace, a, b)
  inputs <- data.frame(y=beta.distribution,
                       x=linspace)
  ggplot(inputs) +
    geom_line(aes(x=x, y=y))
}

run_experiment <- function(n.tosses = 20, true.rate = 0.3, show = c(1, 10, 100)){
  # Prior - beta parameters
  a <- 1
  b <- 1
  
  for(i in 1:n.tosses){
    coin.toss.result <- runif(1) < true.rate
    if (coin.toss.result)
      a <- a + 1
    else
      b <- b + 1
    
    if (i %in% show){
      plot_beta_distribution(a, b) %>% 
        print()
    }
  }
}

run_experiment(n.tosses = 1000, show = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
                                         20, 50, 100, 200, 300, 400, 500, 
                                         600, 700, 800, 900, 1000))