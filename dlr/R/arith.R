# Arithmetic operations
library(dlr)
x <- cpu_tensor(5, dims = 1)
y <- x ** 3
y

# backward(y)
