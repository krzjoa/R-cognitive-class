# nocov start
.onLoad <- function(libname, pkgname){
  # Create global graph to track all the operations
  options("dlr.graph" = .create_graph())
}

# nocov end
