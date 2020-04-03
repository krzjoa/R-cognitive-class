# Install drat
install.packages("drat")

# Install RcppArayFire
drat::addRepo("daqana")
install.packages("RcppArrayFire")
install.packages("RcppArrayFire", configure.args = "--with-arrayfire=/usr/local")
