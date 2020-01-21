erase <- function(pattern = NULL, envir = globalenv()){

  if (is.null(envir))
    envir <- as.environment(-1L)

  object.list <- if(!is.null(pattern)) ls(envir = envir, pattern = pattern) else ls(envir = envir)
  object.list <- as.vector(unlist(object.list))
  rm(list = object.list, envir = envir)
}




#' @name erase_functions
#' @title Remove (all) functions from environment
#' @param pattern regex pattern to select a set of functions; default: NULL
#' @param envir environment; default: global environment
#' @examples
#' create_data <- function() data.frame(a = 1:10, b = 11:20)
#' x <- cars
#' y <-
#' erase_functions()
#' ls()
erase_functions <- function(pattern = NULL, envir = globalenv()){

  if (is.null(envir))
    envir <- as.environment(-1L)

  object.list <- if(!is.null(pattern)) ls(envir = envir, pattern = pattern) else ls(envir = envir)
  object.list <- Map(function(x) if (inherits(get(x, envir = envir), 'function')) x else NULL, object.list)
  object.list <- as.vector(unlist(object.list))
  rm(list = object.list, envir = envir)
}


sponge::erase_functions()
sponge::erase_data()

