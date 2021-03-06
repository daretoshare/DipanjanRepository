library(caret)
library(doSNOW)
library(reshape2)
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

cl <- makeCluster(4)
registerDoSNOW(cl)
## fitting a Gradient Boosting Machine with 5 CV training control
set.seed(1)
rfFit <- train(target ~ ., data = tr,
                 method = "rf",
                 trControl = fitControl,
                 verbose = FALSE)

stopCluster(cl)

save(rfFit,file="rf.RData")
predict(rfFit, newdata = ts)->pre
confusionMatrix(ts$target, pre)

save(gbmFit,file="gbm.RData")
predict(gbmFit, newdata = ts)->pre
confusionMatrix(ts$target, pre)

pred.py<-read.csv("data/w.csv", header=FALSE)

library(reshape2)
## model scoring on new data
ottotest<-read.csv(paste0(getwd(),"/data/test.csv"))
##predict(gbmFit, newdata = ottotest)->prediction
predict(rfFit, newdata = ottotest)->prediction
ottotest$pred<-pred.py.v
ottotest<-ottotest[,c(1,95)]
dcast(ottotest, id ~ pred)->int
int->final
final[!is.na(final)]<-1
final[is.na(final)]<-0
final$id<-int$id
write.csv(final,"pySub.csv", row.names=FALSE)

knnfit<-train(target ~ ., data = tr,
                 method = "knn",
                preProcess = c("center","scale"),
              tuneLength = 20,
              trControl = fitControl)





MultiLogLoss <- function(act, pred)
{
  eps = 1e-15;
  nr <- nrow(pred)
  pred = matrix(sapply( pred, function(x) max(eps,x)), nrow = nr)      
  pred = matrix(sapply( pred, function(x) min(1-eps,x)), nrow = nr)
  ll = sum(act*log(pred) )
  ll = ll * -1/(nrow(act))      
  return(ll);
}