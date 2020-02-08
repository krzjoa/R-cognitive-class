# setRefClass()
# function (Class, fields = character(), contains = character(), 
#           methods = list(), where = topenv(parent.frame()), inheritPackage = FALSE, 
#           ...) 
# {
#   fields <- inferProperties(fields, "field")
#   info <- refClassInformation(Class, contains, fields, methods, 
#                               where)
#   superClasses <- refSuperClasses <- fieldClasses <- fieldPrototypes <- refMethods <- NULL
#   for (what in c("superClasses", "refSuperClasses", "fieldClasses", 
#                  "fieldPrototypes", "refMethods")) assign(what, info[[what]])
#   classFun <- setClass(Class, contains = superClasses, where = where, 
#                        ...)
#   classDef <- new("refClassRepresentation", getClassDef(Class, 
#                                                         where = where), fieldClasses = fieldClasses, refMethods = as.environment(refMethods), 
#                   fieldPrototypes = as.environment(fieldPrototypes), refSuperClasses = refSuperClasses)
#   .setObjectParent(classDef@refMethods, if (inheritPackage) 
#     refSuperClasses
#     else NULL, where)
#   assignClassDef(Class, classDef, where)
#   generator <- new("refGeneratorSlot")
#   env <- as.environment(generator)
#   env$def <- classDef
#   env$className <- Class
#   .declareVariables(classDef, where)
#   value <- new("refObjectGenerator", classFun, generator = generator)
#   invisible(value)
# }

# refObjectGenerator
## the refClassGenerator class
# setClass("refObjectGenerator", representation(generator ="refGeneratorSlot"),
#          contains = c("classGeneratorFunction", "refClass"), where = envir)
# 
# setMethod("$", "refObjectGenerator",
#           function(x, name) eval.parent(substitute(x@generator$name)), where = envir)
# 
# setMethod("$<-", "refObjectGenerator",
#           function(x, name, value) eval.parent(substitute(x@generator$name <- value)),
#           where = envir)
## next call is touchy:  setRefClass() uses an object of class
## refGeneratorSlot, but the class should have been defined before
## that object is created.
# setRefClass("refGeneratorSlot",
#             fields = list(def = "ANY", className = "ANY"),
#             methods = .GeneratorMethods, where = envir)
# setMethod("show", "refClassRepresentation",
#           function(object) showRefClassDef(object), where = envir)
# setMethod("show", "refObjectGenerator",
#           function(object) showRefClassDef(object$def, "Generator for class"),
#           where = envir)

setClass()

trollo <- setRefClass("trollo", methods = list(lol = function(x) x + 7))

env <- as.environment(cars)



function (classDef, env = topenv(parent.frame())) 
{
  if (is(classDef, "classRepresentation")) {
  }
  else if (is(classDef, "character")) {
    if (is.null(packageSlot(classDef))) 
      classDef <- getClass(classDef, where = env)
    else classDef <- getClass(classDef)
  }
  else stop("argument 'classDef' must be a class definition or the name of a class")
  fun <- function(...) NULL
  body(fun) <- substitute(new(CLASS, ...), list(CLASS = classDef@className))
  environment(fun) <- env
  fun <- as(fun, "classGeneratorFunction")
  fun@className <- classDef@className
  fun@package <- classDef@package
  fun
}

crs <- cars

fun <- function(...) NULL
environment(fun) <- as.environment(crs)
# body(fun) <- substitute(cars, list(CLASS = classDef@className))
# as(fun, "data.frame")
class(fun) <- c("data.frame", "function", "callable")

environment(fun) %>% objects(envir = .)

environment(crs) <- function(x) x + 3

class(crs) <- c("data.frame", "function", "callable")

`[`   <- function(...) {UseMethod("["  )}
`[<-` <- function(...) {UseMethod("[<-")}
`$`   <- function(...) {UseMethod("$"  )}
`$<-` <- function(...) {UseMethod("$<-")}

`[.function` <- `[.closure` <- function(func, arg_name) {
  if (arg_name %in% names(formals(func))) {
    formals(func)[[arg_name]]
  } else {
    warning("No such formal argument: ", arg_name)
  }
}

`$<-.function` <- `$<-.closure` <- function(func, arg_name, value) {
  print("lol")
}


`$.function` <- function(a, b, val){
  print("lol")
}

get_grid$lollo <- "qwer"

trol <- function(x) x - 10
class(trol) <- "callable"
trol$tr <- 2

library(dplyr)

class(trol) <- "data.frame"

trol %>% 
  mutate(x = 1:20)

as.matrix(trol)
as.matrix(runif_same_dims)

https://github.com/wch/r-source/blob/54fbdca9d3fc63437d9e697f442d32732fb4f443/src/include/Rinlinedfuns.h
