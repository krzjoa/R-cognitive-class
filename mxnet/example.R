# https://mxnet.incubator.apache.org/versions/master/tutorials/r/CallbackFunction.html#model-training-example

library(mxnet)
data(BostonHousing, package="mlbench")

train.ind = seq(1, 506, 3)
train.x = data.matrix(BostonHousing[train.ind, -14])
train.y = BostonHousing[train.ind, 14]
test.x = data.matrix(BostonHousing[-train.ind, -14])
test.y = BostonHousing[-train.ind, 14]

# Model definition
data <- mx.symbol.Variable("data")
fc1 <- mx.symbol.FullyConnected(data, num_hidden=1)
lro <- mx.symbol.LinearRegressionOutput(fc1)


mx.set.seed(0)
model <- mx.model.FeedForward.create(
  fc1, X=train.x, y=train.y,
  eval.data=list(data=test.x, label=test.y),
  ctx=mx.cpu(), num.round=10, array.batch.size=20,
  learning.rate=2e-6, momentum=0.9, eval.metric=mx.metric.rmse, array.layout='rowmajor')

preds = predict(model, test.x)
      

