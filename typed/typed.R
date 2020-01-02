typed(x, type = int) <- 2

typed(x ~ [immutable, int]) <- 2
typed(z ~ data.frame) <- NULL
# Set in variable attribute

x <- 123
attributes(x)
attr(x, "typed") <- "int"
x

enable_autotyping <- function(){
  `<-` <- function(x, value){
    
  }
}

autocast(data.frame = data.table,
         double     = integer)

casted(data.table)(x) <- data.frame(lol = c(1,2,3))
autocasted(x) <- data.frame(lol = c(1,2,3))

col_typed(x, lol = integer) <- data.frame(lol = c(1,2,3)) 
