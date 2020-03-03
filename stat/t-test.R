#' Welch test - generalization of t-Student test
#' In t-student we assume that both distributions have the same variance

#' Test t-studenta
#' 1. dla prób niezależnych - porównanie dwóch grup
#' 2. dla prób zależnych - ta sama grupa, wiele obserwacji. Badamy wielkość zmian
#' 3. dla jednej próby - porównujemy wynik grupy ze znaną watością teoretyczną
#' 
#' Test t-Studenta jest testem parametrycznym (jednak dość odpornym)
#' Nieparametrycznym odpowiednikiem testu jest 
#' * dla prób niezależnych: test U Manna-Whitneya
#' * dla prób zależenych: test Wilcoxona
#' 

set.seed(7)
x <- rnorm(100)
y <- rnorm(100)

boxplot(x, y)

t.test(x, y)
