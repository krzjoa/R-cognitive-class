install.packages("tsibble")
install.packages("tsibbledata")
install.packages("fable")
install.packages("feasts")
install.packages("fabletools")
devtools::install_github("tidyverts/fasster")
install.packages('fpp3', dependencies = TRUE)

library(dplyr)
library(tsibble)
library(ggplot2)
import::from(fpp, a10, .into = ts.data)

# Seasonal plots
a10 %>% 
  as_tsibble() %>%  
  feasts::gg_season(Cost, labels = "both") +
    ylab("$ million") +
    ggtitle("Seasonal plot: antidiabetic drug sales")
  

