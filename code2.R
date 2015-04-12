library(caret)
library(doSNOW)
##Read the raw file
ottotrain<-read.csv(choose.files())

##draw 75% stratified sample for training and rest for testing
createDataPartition(ottotrain$target, p = .75, list=FALSE)->partition
tr<-ottotrain[partition,c(2:95)]
row.names(tr)<-NULL

ts<-ottotrain[-partition,c(2:95)]
row.names(ts)<-NULL

set.seed(1)
## creating 5 fold cross validation for training control 
fitControl <- trainControl(
  method = "repeatedcv",
  number = 5,
  ## repeated ten times
  repeats = 5)

cl <- makeCluster(3)
registerDoSNOW(cl)
## fitting a Gradient Boosting Machine with 5 CV training control
set.seed(1)
gbmFit <- train(target ~ ., data = tr,
                 method = "gbm",
                 trControl = fitControl,
                 verbose = FALSE)

stopCluster(cl)
