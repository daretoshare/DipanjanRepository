ottotrain<-read.csv(choose.files())
sample(rows, size= 45350, replace=FALSE)->trainingindex
tr<-ottotrain[trainingindex,]
ts<-ottotrain[-trainingindex,]