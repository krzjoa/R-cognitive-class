path_elem <- function(node = NULL, children = NULL, ...){
  
  if(length(node) > 1){
    node <- node[1]
    children <- node[-1]
  }
  
  path.elem <- structure(list(), class = "path_elem")
  attr(path.elem, 'node') <- node 
  for(i in children){path.elem[[attr(i, 'node')]] <- i}
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
    path <- paste(splitted.path, collapse = .Platform$file.sep)
    last.node <- attr(a[[b]], 'node')
    last.node <- if(is.null(last.node)) "" else last.node
    file.path(attr(root.object, 'node'), path, last.node)
  } else {
    a[[b]]
  }
}

a1 <- path_elem("fileA.RData")
a2 <- path_elem("fileB.RData")
a3 <- path_elem("data", list(a1, a2))
a4 <- path_elem("files", list(a3))

a4$data$fileA.RData
