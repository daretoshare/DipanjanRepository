from sklearn.ensemble import RandomForestClassifier
import numpy as np
import pandas as pd
from sklearn.cross_validation import cross_val_score


test=pd.read_csv('data/test.csv', sep=',')
test2=test.drop('id', axis=1)

train=pd.read_csv('data/train.csv', sep=',')
y=train['target']
X = train[list(train.columns)[:-1]]
X2=X.drop('id', axis=1)

rf = RandomForestClassifier(n_estimators=100)
rf.fit(X2, y)
predicted_probs = rf.predict_proba(test2)
predicted_probs = [["%f" % x[1]] for x in predicted_probs]

predicted = rf.predict(test2)
import csv_io

csv_io.write_csv('data/w.csv',predicted)