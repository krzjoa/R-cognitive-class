library(mxnet)

set.seed(0)

# Dummy data
X1 <- rnorm(1000)
X2 <- rnorm(1000)

LR <- X1 * 2 + X2 * 3 + rnorm(1000)
PROP <- 1/(1 + exp(-LR))

Y <- as.integer(PROP > runif(1000))

X.array <- array(rbind(X1, X2), dim = c(2, 1000))

# Architecture
data <- mx.symbol.Variable(name = "data")
label <- mx.symbol.Variable(name = "label")mx.symbol.LogisticRegressionOutput(data = fc_layer, label = label, name = 'out_layer')
fc_layer <- mx.symbol.FullyConnected(data = data, num.hidden = 1, name = 'fc_layer')
out_layer <- mx.symbol.LogisticRegressionOutput(data = fc_layer, label = label, name = 'out_layer')

# Training
my.eval.metric.CE <- mx.metric.custom(
  name = "Cross-Entropy (CE)", 
  function(real, pred) {
    real1 = as.numeric(real)
    pred1 = as.numeric(pred)
    pred1[pred1 <= 1e-6] = 1e-6
    pred1[pred1 >= 1 - 1e-6] = 1 - 1e-6
    return(-mean(real1 * log(pred1) + (1 - real1) * log(1 - pred1), na.rm = TRUE))
  }
)


logger <- mx.metric.logger$new()

logistic_model <-  mx.model.FeedForward.create(out_layer,
                                             X = X.array, y = Y,
                                             ctx = mx.cpu(), num.round = 50,
                                             array.batch.size = 100, learning.rate = 0.1,
                                             momentum = 0, wd = 0, array.layout = "colmajor",
                                             eval.metric = my.eval.metric.CE,
                                             epoch.end.callback = mx.callback.log.train.metric(5, logger))
