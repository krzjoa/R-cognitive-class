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
#' TODO: unify names ops vs ops_ptr
#' TODO: flatten graph(?)
#'
#' We need to propagate information, if gradient is required or not
#' @examples
#' library(dlr)
#' ctx <- get_context()
#' register_ops(ctx, cars)
#' register_ops(ctx, data.frame)
#' x <- cpu_tensor(5, dims = 1)
#' y <- (x ** 3) / 2
#' all.ops <- get_all_ops_ptr(ctx)
#' backward(y, 1)
#' Błąd w poleceniu 'get_inputs(ops)':attempt to set index 2/2 in SET_VECTOR_ELT
backward <- function(ops, gradient){

  # For simplicity, suppose we have only one sequence of operations
  # if (!inherits(ops, "cpu_tensor"))
  #   stop("Error!")
  inputs <- get_inputs(ops)

  # Tensors has only one "inputs", i.e. backward functions
  if (inherits(ops, "cpu_tensor")) {
    backward_fun <- inputs[[1]]
    print(backward_fun)
    backward(backward_fun, gradient)
    return(NULL)
  } else if (inherits(ops, "function")) {
    deriv <- get_paired_object(ops)
    print(inputs)
    #' For every input to the function
    #' 1. Find all the argumnets
    #' 2. Get matching function
    for (inp in seq_along(inputs)) {
      deriv.at <- deriv[[inp]]
      print("Deriv")
      print(deriv.at)

    }
  }

  # Compute gradient


  # if(is_root(tensor)) {
  #   # Compute gradient & finish
  #   return(NULL)
  # }


}

# backward.function and backwad.cpu_tensor


match_deriv <- function(ops){

}


