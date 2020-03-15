tsunami::add_lags(PRICE ~ lags(1,2,3,4) + fill_na(na.locf), 
                  LOW.COST ~ lags(3, 7) + fill_na(na.locf))
                  
add_lags.data.frame
add_lags.data.table
add_lags.tsibble

# looplyr
cars %>% 
  looplyr::loop_mutate(loop_cols(), {mx <- max(Revenue); glue("col_{mx}")} := {.x})
  looplyr::loop_summarise(loop_cols(), {} := {.x})

loop_mutate <- function(.data, idx, ...){
  
  `:=` <- function(a, b) b
  
  # browser()
  for (.idx in idx) {
    browser()
    for (ops in as.list(...)) {
      .data <- mutate(data, )
    }
  }
  return(.data)
}

sls %>% 
  group_by(id) %>% 
  loop_mutate(1:5, glue::glue("lag.{.idx}") := lag(value, .idx))

dplyr:::mutate.tbl_df()

rlang::ensyms(...)
