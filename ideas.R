tsunami::add_lags(PRICE ~ lags(1,2,3,4) + fill_na(na.locf), 
                  LOW.COST ~ lags(3, 7) + fill_na(na.locf))
                  
add_lags.data.frame
add_lags.data.table
add_lags.tsibble

# looplyr
cars %>% 
  looplyr::loop_mutate(loop_cols(), {mx <- max(Revenue); glue("col_{mx}")} := {.x})
  looplyr::loop_summarise(loop_cols(), {} := {.x})

library(magrittr)
library(dplyr)  

.extract_calls <- function(...){
  expressions <- as.list(substitute(list(...)))[-1]
}
    
#' @name loop_mutate
#' @title `mutate` in loop
#' @param .data a data.frame
#' @param idx idx vector
#' @param ...
loop_mutate <- function(.data, idx, ...){
  
  # TODO: 
  # * optimize?
  # * processing order
  .calls <- .extract_calls(...)
  
  for (.idx in idx) {
    for (ops in .calls) {
      call.args <- rlang::call_args(ops)
      ops.lhs <- eval(call.args[[1]])
      ops.rhs <- call.args[[2]]
      string.expr <- sprintf("mutate(.data, !!ops.lhs := %s)", deparse(substitute(ops.rhs)))
      .data <- eval(parse(text = string.expr))
      # .data <- mutate(.data, !!ops.1 := rlang::expr(deparse(substitute(ops.2))))
    }
  }
  return(.data)
}



iris %>% 
  group_by(Species) %>% 
  loop_mutate(1:5, 
              glue::glue("lag.{.idx}") := lag(Sepal.Length, .idx),
              {mx <- 20; glue::glue("lag.{.idx + mx}")} := lag(Sepal.Length, .idx + 2))

# dplyr:::mutate.tbl_df()
# rlang::ensyms(...)