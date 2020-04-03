library("readr")
library("dplyr")
library("mxnet")
library("abind")


## Preprocessing steps
Data <- read.csv(file = "https://archive.ics.uci.edu/ml/machine-learning-databases/00381/PRSA_data_2010.1.1-2014.12.31.csv",
                 header = TRUE,
                 sep = ",")

## Extracting specific features from the dataset as variables for time series We extract
## pollution, temperature, pressue, windspeed, snowfall and rainfall information from dataset
df <- data.frame(Data$pm2.5,
                 Data$DEWP,
                 Data$TEMP,
                 Data$PRES,
                 Data$Iws,
                 Data$Is,
                 Data$Ir)
df[is.na(df)] <- 0

## Now we normalise each of the feature set to a range(0,1)
df <- matrix(as.matrix(df),
             ncol = ncol(df),
             dimnames = NULL)

rangenorm <- function(x) {
  (x - min(x))/(max(x) - min(x))
}
df <- apply(df, 2, rangenorm)
df <- t(df)


n_dim <- 7
seq_len <- 100
num_samples <- 430

## extract only required data from dataset
trX <- df[1:n_dim, 25:(24 + (seq_len * num_samples))]

## the label data(next PM2.5 concentration) should be one time step
## ahead of the current PM2.5 concentration
trY <- df[1, 26:(25 + (seq_len * num_samples))]

## reshape the matrices in the format acceptable by MXNetR RNNs
trainX <- trX
dim(trainX) <- c(n_dim, seq_len, num_samples)
trainY <- trY
dim(trainY) <- c(seq_len, num_samples)  


batch.size <- 32

# take first 300 samples for training - remaining 100 for evaluation
train_ids <- 1:300
eval_ids <- 301:400

## The number of samples used for training and evaluation is arbitrary.  I have kept aside few
## samples for testing purposes create dataiterators
train.data <- mx.io.arrayiter(data = trainX[, , train_ids, drop = F], 
                              label = trainY[, train_ids],
                              batch.size = batch.size, shuffle = TRUE)

eval.data <- mx.io.arrayiter(data = trainX[, , eval_ids, drop = F], 
                             label = trainY[, eval_ids],
                             batch.size = batch.size, shuffle = FALSE)

## Create the symbol for RNN
symbol <- rnn.graph(num_rnn_layer = 1,
                    num_hidden = 5,
                    input_size = NULL,
                    num_embed = NULL,
                    num_decode = 1,
                    masking = F, 
                    loss_output = "linear",
                    dropout = 0.2, 
                    ignore_label = -1, 
                    cell_type = "lstm", 
                    output_last_state = T,
                    config = "one-to-one")



mx.metric.mse.seq <- mx.metric.custom("MSE", function(label, pred) {
  label = mx.nd.reshape(label, shape = -1)
  pred = mx.nd.reshape(pred, shape = -1)
  res <- mx.nd.mean(mx.nd.square(label - pred))
  return(as.array(res))
})



ctx <- mx.cpu()

initializer <- mx.init.Xavier(rnd_type = "gaussian",
                              factor_type = "avg", 
                              magnitude = 3)

optimizer <- mx.opt.create("adadelta",
                           rho = 0.9, 
                           eps = 1e-05, 
                           wd = 1e-06, 
                           clip_gradient = 1, 
                           rescale.grad = 1/batch.size)

logger <- mx.metric.logger()
epoch.end.callback <- mx.callback.log.train.metric(period = 10, 
                                                   logger = logger)

## train the network
system.time(model <- mx.model.buckets(symbol = symbol, 
                                      train.data = train.data, 
                                      eval.data = eval.data,
                                      num.round = 1, 
                                      ctx = ctx, 
                                      verbose = TRUE, 
                                      metric = mx.metric.mse, 
                                      initializer = initializer,
                                      optimizer = optimizer, 
                                      batch.end.callback = NULL, 
                                      epoch.end.callback = epoch.end.callback))
