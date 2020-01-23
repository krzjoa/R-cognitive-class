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
#' TODO: add getOption("sponge.default.env")
erase_functions <- function(pattern = NULL, envir = globalenv()){
  objects <- as.character(lsf.str(pattern = pattern, envir = envir))
  rm(list = objects, envir = envir)
}

#' @name erase_non_functions
#' @title Remove non-functions
#' @inheritParams erase_functions
erase_non_functions <- function(pattern = NULL, envir = globalenv()){
  objects <- setdiff(ls(pattern = pattern, envir = envir), 
                     lsf.str(envir = envir))
  rm(list = objects, envir = envir)
}


#' @name erase_data
#' @title Remove data, which is 
erase_data <- function(pattern = NULL, envir = globalenv()){
  objects <- Filter(function(x) !is.vector(get(x, envir = envir)), 
                    ls(pattern = pattern, envir = envir))
  print(objects)
  rm(list = objects, envir = envir)
}


Filter(function(x) !is.vector(get(x)) | is.list(get(x)), 
       ls(pattern = "p"))

erase <- function(pattern = NULL, envir = globalenv()){
  if (is.null(envir))
    envir <- as.environment(-1L)

  object.list <- if(!is.null(pattern)) ls(envir = envir, pattern = pattern) else ls(envir = envir)
  rm(list = object.list, envir = envir)
}



erase_data <- function(pattern = NULL, envir = globalenv()){
  filter.function <- function(x) if (!inherits(get(x, envir = envir), 'function')) x else NULL
  .abstract_erase(pattern = pattern, filter.function = filter.function, envir = envir)
}



.abstract_erase <- function(pattern = NULL, filter.function, envir = globalenv()){
  
  if (is.null(envir))
    envir <- as.environment(-1L)
  
  object.list <- if(!is.null(pattern)) ls(envir = envir, pattern = pattern) else ls(envir = envir)
  object.list <- Map(filter.function, object.list)
  object.list <- as.vector(unlist(object.list))
  rm(list = object.list, envir = envir)
}


