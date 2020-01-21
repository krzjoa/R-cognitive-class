neighbour_idx_matrix <- function(mat, mask = NULL, diagonal = TRUE, random.select = NULL){
  n.row <- nrow(mat)
  n.col <- ncol(mat)
  
  idx.matrix <- matrix(list(), nrow = n.row, ncol = n.col)
  
  for (i in 1:n.row) {
    for (j in 1:n.col) {
      
      if (!is.null(mask))
        if (!mask[i, j])
          next
      
      neighbours <- neighbour_idx(mat,
                                  idx      = c(i, j),
                                  mask     = mask,
                                  diagonal = diagonal)
      
      if (is.numeric(random.select))
        neighbours <- sample(neighbours, random.select)[[1]]
      
      idx.matrix[[i, j]] <- neighbours
    }
  }
  idx.matrix
}


as_idx <- function(x){
  n.row <- nrow(x)
  n.col <- ncol(x)
  
  result <- matrix(list(), nrow = n.row, ncol = n.col)
  
  for (i in 1:n.row){
    for (j in 1:n.col){
      coords <- c(i, j)
      
      if (is.na(at(x, coords)))
        next
      
      x.val <- x[i, j]
      
      switch (x.val,
              U = c(i - 1, j),
              D = c(i + 1, j),
              L = c(i, j - 1),
              R = c(i, j + 1),
      ) -> move.idx
      
      if (!is_idx_possible(x, move.idx))
        next
      
      result[i, j] <- list(move.idx)
    }
  }
  result
}