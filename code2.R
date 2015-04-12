library(caret)
library(doSNOW)
##Read the raw file
##ottotrain<-read.csv("/home/dipanjan/DipanjanRepository/train.csv/train.csv")
ottotrain<-read.csv(paste0(getwd(),"/train.csv/train.csv"))
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

save(gbmFit,file="gbm.RData")
predict(gbmFit, newdata = ts)->pre
confusionMatrix(ts$target, pre)


## model scoring on new data
ottotest<-read.csv(paste0(getwd(),"/test.csv/test.csv"))
predict(gbmFit, newdata = ottotest)->prediction
ottotest$pred<-prediction
ottotest<-ottotest[,c(1,95)]
dcast(ottotest, id ~ pred)->int
int->final
final[!is.na(final)]<-1
final[is.na(final)]<-0
final$id<-int$id

