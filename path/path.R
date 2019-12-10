path_elem <- function(node = NULL, children = NULL, ...){
  
  # if(length(node) > 1){
  #   node <- node[1]
  #   children <- node[-1]
  # }
  
  if(is.null(names(children)) & !is.null(children))
    children <- setNames(children, sapply(children, function(x) attr(x, 'node')))
  nms <- names(children)
  
  path.elem <- structure(list(), class = "path_elem")
  attr(path.elem, 'node') <- node 
  for(i in seq_along(children)){path.elem[[nms[[i]]]] <- children[[i]]}
  path.elem['.'] <- node
  return(path.elem)
}

print.path_elem <- function(x, ...){
  cat(sprintf("path_elem \n root: %s \n childen: %d", 
              attr(x, 'node'),
              length(x))
      )
  x
}

`$.path_elem` <- function(a, b){
  
  if(length(a[[b]]) == 1 || b == "."){
    raw.string <- deparse(substitute(a))
    splitted.path <- strsplit(raw.string, "\\$")[[1]]
    root.object <- get(splitted.path[1], parent.frame())
    
    splitted.path <- splitted.path[-1]
    elem.to.be.removed <- grepl("`.*`", splitted.path)
    splitted.path[elem.to.be.removed] <- substr(splitted.path[elem.to.be.removed], 2,
                                                nchar(splitted.path[elem.to.be.removed]))
    
    splitted.path <- c(splitted.path, b)
    
    fun <- function(x, y){
      obj <- x[[1]]
      last.node <- attr(obj[[y]], 'node')
      last.node <- if(is.null(last.node)) "" else last.node
      list(obj[[y]], file.path(x[[2]], last.node))
    }
    
    Reduce(fun, splitted.path, list(root.object, attr(root.object, 'node')))[[2]]
  } else {
    a[[b]]
  }
}

cnf <- config::get(config = 'default', file = 'conf.yml')

file.section <- cnf$kFiles

dir_structure <- function(config.file.section, root.key = 'kRoot'){
  print(length(config.file.section))
  if(length(config.file.section) > 1){
    node <- config.file.section[[root.key]]
    children <- config.file.section[which(names(config.file.section) != root.key)]
    path_elem(node, sapply(children, dir_structure))
  } else {
    path_elem(node = config.file.section[1])
  }
}
                                          
nested_path <- function(path = ".", naming = basename){
  if(dir.exists(path)){
    file.list <- list.files(path, recursive = FALSE, 
                            include.dirs = TRUE, full.names = TRUE)
    file.list <- setNames(file.list, naming(file.list))
    c(list('.' = path), as.list(Map(nested_path, file.list)))
  } else {
    path
  }
}

                                          

cnfs <- dir_structure(file.section)

cnfs$kNestedData$kFile3..


file.section <- cnf$kFiles

file.section


# a1 <- path_elem("fileA.RData")
# a2 <- path_elem("fileB.RData")
# a3 <- path_elem("data", list(A1 = a1, A2 = a2))
# a4 <- path_elem("files", list(a3))
# 
# a4$data$A1
# a4$data$.


