#' @name backward
#' @title This function traverses the graph back and computes all the gradients where it's needed
#' @param ops tensor
#' TODO: potentially hard to handle: dimshuffles etc.
#' TODO: transform into S4 method
#'
#' https://towardsdatascience.com/pytorch-autograd-understanding-the-heart-of-pytorchs-magic-2686cd94ec95
#' https://www.cs.toronto.edu/~rgrosse/courses/csc321_2018/slides/lec10.pdf
#' http://www.cs.toronto.edu/~rgrosse/courses/csc421_2019/readings/L06%20Automatic%20Differentiation.pdf
#' https://j-towns.github.io/2017/06/12/A-new-trick.html
#' See: https://pytorch.org/docs/stable/autograd.html
#' https://github.com/HIPS/autograd/blob/master/autograd/numpy/numpy_vjps.py
#'
#' We need to propagate information, if gradient is required or not
#'
backward <- function(ops, gradient){

  # For simplicity, suppose we have only one sequence of operations
  if (!inherits(ops, "cpu_tensor"))
    stop("Error!")

  # Compute gradient


  if(is_root(tensor)) {
    # Compute gradient & finish
    return(NULL)
  }


}
