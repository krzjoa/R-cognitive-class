#' @name erase_masking_objects
#' @title Erase objects from GlobalEnv, which are masking objects from attached packages
#' @param pattern a regex pattern
#' @details We have to highglight, that for now it only allows us to remove objects from
#' the Global Environment
#' @examples
#' matrix <- matrix(0, 3, 3)
#' gamma <- 0.9
#' erase_masking_objects(verbose = TRUE)
#' @export
erase_masking_objects <- function(pattern = NULL, verbose = FALSE){
  conflict.objects <- conflicts(detail = TRUE)
  global.ev.conflicts <- conflict.objects$.GlobalEnv
  
  if (!is.null(pattern))
    global.ev.conflicts <- global.ev.conflicts[grepl(pattern = pattern,
                                                     global.ev.conflicts)]
  
  if (verbose)
    print(global.ev.conflicts)
  
  browser()
  
  if (!is.null(global.ev.conflicts))
    rm(list = global.ev.conflicts, envir = globalenv())
  
}
