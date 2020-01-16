erase_functions <- function(pattern = NULL, envir = NULL){
  if (is.null(envir))
    envir <- as.environment(-1L)
  object.list <- ls(envir = envir, pattern = pattern)
  object.list <- Map(function(x) if (inherits(get(x, envir = envir), 'function')) x else NULL, object.list)
  object.list <- as.vector(unlist(object.list))
  rm(list = object.list, envir = envir)
}
