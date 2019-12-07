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

a1 <- path_elem("fileA.RData")
a2 <- path_elem("fileB.RData")
a3 <- path_elem("data", list(a1, a2))
a4 <- path_elem("files", list(a3))

a4$data$fileA.RData
