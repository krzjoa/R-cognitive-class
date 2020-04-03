# Main object to store all the session objects
#' @useDynLib dl add_
#' @export
add_c <- function(x, y) .Call(add_, x, y)


library(data.table)

dt <- as.data.table(cars)
dt2 <- dt
dt$speed <- dt$speed + 100
dt
dt2
