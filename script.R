ottotrain<-read_csv(choose.files())
sample(rows, size= 45350, replace=FALSE)->traininginde
tr<-ottotrain[trainingindex,]
ts<-ottotrain[-trainingindex,]
xnam<-names(tr[,2:94])
fmla <- as.formula(paste("target ~ ", paste(xnam, collapse= "+")))

titanicDF <- read.csv('http://math.ucdenver.edu/RTutorial/titanic.txt',sep='\t')

createDataPartition(ottotrain$target, p = .75, list=FALSE)->partition
ctrl<-trainControl(method="repeatedcv",repeats=5,classProbs=TRUE)
gbmTune<-train(target~.,data=tr,method="gbm",metric="ROC",tuneGrid=grid,verbose=FALSE,trControl=ctrl)


fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)

gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9),
                        n.trees = (1:30)*50,
                        shrinkage = 0.1)

gbmFit2 <- train(target ~ ., data = ottotrain,
                 method = "gbm",
                 ##trControl = fitControl,
                 verbose = FALSE,
                 ## Now specify the exact models 
                 ## to evaludate:
                 tuneGrid = gbmGrid)

gbmFit1 <- train(target ~ ., data = ottotrain,
                 method = "gbm",
                 #trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE)