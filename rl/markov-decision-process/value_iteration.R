#' Rożnica: nie trzeba czekać, aż dokonamy ewaluacji polityki 
#' przez stwierdzenie, że polityka ta zbiega
#' Dwa kroki:
#' 1. Znajdujemy optymalną funkcję wartości
#' 2. Dobieramy do tego odpowiednią politykę


optimal_value_function <- function(actions, rewards, gamma = 0.9) {
  # Zero w stanach końcoych dodane dla wygody, naprawdę nie ma tam wartości
  V <- with_same_dims(actions, 0)
  V[possible.actions] <- runif(sum(possible.actions))
  
  # if ()
}