ottotrain<-read.csv(choose.files())
sample(rows, size= 45350, replace=FALSE)->traininginde
tr<-ottotrain[trainingindex,]
ts<-ottotrain[-trainingindex,]
xnam<-names(tr[,2:94])
fmla <- as.formula(paste("target ~ ", paste(xnam, collapse= "+")))

titanicDF <- read.csv('http://math.ucdenver.edu/RTutorial/titanic.txt',sep='\t')

createDataPartition(ottotrain$target, p = .75, list=FALSE)->partition\
ctrl<-trainControl(method="repeatedcv",repeats=5,classProbs=TRUE)
gbmTune<-train(target~.,data=tr,method="gbm",metric="ROC",tuneGrid=grid,verbose=FALSE,trControl=ctrl)
