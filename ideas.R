tsunami::add_lags(PRICE ~ lags(1,2,3,4) + fill_na(na.locf), 
                  LOW.COST ~ lags(3, 7) + fill_na(na.locf))
                  
add_lags.data.frame
add_lags.data.table
add_lags.tsibble
