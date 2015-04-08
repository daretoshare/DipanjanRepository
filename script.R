ottotrain<-read.csv(choose.files())
sample(rows, size= 45350, replace=FALSE)->traininginde
tr<-ottotrain[trainingindex,]
ts<-ottotrain[-trainingindex,]
xnam<-names(tr[,2:94])
fmla <- as.formula(paste("target ~ ", paste(xnam, collapse= "+")))
