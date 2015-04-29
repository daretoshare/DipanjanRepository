# -*- coding: utf-8 -*-
"""
Created on Mon Apr 27 15:47:11 2015

@author: DPA48077
"""

import pandas as pd
import numpy as np
from sklearn import ensemble, feature_extraction, preprocessing

# import data
train = pd.read_csv('D:/new_git/OTT/data/train.csv')
test = pd.read_csv('D:/new_git/OTT/data/test.csv')
sample = pd.read_csv('D:/new_git/OTT/data/sampleSubmission.csv')

# drop ids and get labels
labels = train.target.values
train = train.drop('id', axis=1)
train = train.drop('target', axis=1)
test = test.drop('id', axis=1)

# encode labels 
lbl_enc = preprocessing.LabelEncoder()
labels = lbl_enc.fit_transform(labels)

# train a random forest classifier
clf = ensemble.RandomForestClassifier(n_jobs=-1, n_estimators=500, max_features = 80, verbose=2)
clf.fit(train, labels)

# predict on test set
preds = clf.predict_proba(test)

# create submission file
preds = pd.DataFrame(preds, index=sample.id.values, columns=sample.columns[1:])
preds.to_csv('benchmarkDipanjan.csv', index_label='id')
