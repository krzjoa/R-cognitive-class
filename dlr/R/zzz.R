# nocov start
.onLoad <- function(libname, pkgname){
  # Create global graph to track all the operations
  options("dlr.context" = .create_context())
}

# nocov end
