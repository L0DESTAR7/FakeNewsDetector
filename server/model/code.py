# %% [markdown]
# # Fake news Detection

# %% [markdown]
# ![I-Newspaper2.jpg](attachment:I-Newspaper2.jpg)

# %% [markdown]
# ### Importing required library
# Here I am going to importing some of the required library, if extra library is required to install It will be install later on.

# %%
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.metrics import classification_report
import re
import string
import sys

# %% [markdown]
# ### Inserting fake and real dataset

# %%
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')


df_fake = pd.read_csv("./server/model/Fake.csv")
df_fake["text"] = df_fake["text"].astype(str)
df_true = pd.read_csv("./server/model/True.csv")
df_true["text"] = df_true["text"].astype(str)

# %%
df_fake.head(5)

# %%
df_true.head(5)

# %% [markdown]
# Inserting a column called "class" for fake and real news dataset to categories fake and true news. 

# %%
df_fake["class"] = 0
df_true["class"] = 1

# %% [markdown]
# Removing last 10 rows from both the dataset, for manual testing  

# %%
df_fake.shape, df_true.shape

# %%
df_fake_manual_testing = df_fake.tail(10)
for i in range(23480,23470,-1):
    df_fake.drop([i], axis = 0, inplace = True)
df_true_manual_testing = df_true.tail(10)
for i in range(49,39,-1):
    df_true.drop([i], axis = 0, inplace = True)

# %%
df_fake.shape, df_true.shape

# %% [markdown]
# Merging the manual testing dataframe in single dataset and save it in a csv file

# %%
df_fake_manual_testing["class"] = 0
df_true_manual_testing["class"] = 1

# %%
df_fake_manual_testing.head(10)

# %%
df_true_manual_testing.head(10)

# %%
df_manual_testing = pd.concat([df_fake_manual_testing,df_true_manual_testing], axis = 0)
df_manual_testing.to_csv("./server/model/manual_testing.csv")

# %% [markdown]
# Merging the main fake and true dataframe

# %%
df_marge = pd.concat([df_fake, df_true], axis =0 )
df_marge.head(10)

# %%
df_marge.columns

# %% [markdown]
# #### "title",  "subject" and "date" columns is not required for detecting the fake news, so I am going to drop the columns.

# %%
df = df_marge.drop(["title", "subject","date"], axis = 1)

# %%
df.isnull().sum()

# %% [markdown]
# #### Randomly shuffling the dataframe 

# %%
df = df.sample(frac = 1)

# %%
df.head()

# %%
df.reset_index(inplace = True)
df.drop(["index"], axis = 1, inplace = True)

# %%
df.columns

# %%
df.head()

# %% [markdown]
# #### Creating a function to convert the text in lowercase, remove the extra space, special chr., ulr and links.

# %%
def wordopt(text):
    text = text.lower()
    text = re.sub('\[.*?\]', '', text)
    text = re.sub("\\W"," ",text) 
    text = re.sub('https?://\S+|www\.\S+', '', text)
    text = re.sub('<.*?>+', '', text)
    text = re.sub('[%s]' % re.escape(string.punctuation), '', text)
    text = re.sub('\n', '', text)
    text = re.sub('\w*\d\w*', '', text)    
    return text

# %%
df["text"] = df["text"].apply(wordopt)

# %% [markdown]
# #### Defining dependent and independent variable as x and y

# %%
x = df["text"]
y = df["class"]

# %% [markdown]
# #### Splitting the dataset into training set and testing set. 

# %%
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.25)

# %% [markdown]
# #### Convert text to vectors

# %%
from sklearn.feature_extraction.text import TfidfVectorizer

# %%
vectorization = TfidfVectorizer()
xv_train = vectorization.fit_transform(x_train)
xv_test = vectorization.transform(x_test)

# %% [markdown]
# ### 1. Logistic Regression

# %%
from sklearn.linear_model import LogisticRegression

# %%
LR = LogisticRegression()
LR.fit(xv_train,y_train)

# %%
pred_lr=LR.predict(xv_test)

# %%
LR.score(xv_test, y_test)

# %%
print(classification_report(y_test, pred_lr))

# %% [markdown]
# ### 2. Decision Tree Classification

# %%
from sklearn.tree import DecisionTreeClassifier

# %%
DT = DecisionTreeClassifier()
DT.fit(xv_train, y_train)

# %%
pred_dt = DT.predict(xv_test)

# %%
DT.score(xv_test, y_test)

# %%
print(classification_report(y_test, pred_dt))

# %% [markdown]
# # Model Testing With Manual Entry
# 
# ### News

# %%
def output_lable(n):
    if n == 0:
        return "Fake News"
    elif n == 1:
        return "Not A Fake News"
    
def manual_testing(news):
    testing_news = {"text":[news]}
    new_def_test = pd.DataFrame(testing_news)
    new_def_test["text"] = new_def_test["text"].apply(wordopt) 
    new_x_test = new_def_test["text"]
    new_xv_test = vectorization.transform(new_x_test)
    pred_LR = LR.predict(new_xv_test)
    pred_DT = DT.predict(new_xv_test)
    

    return print("\n\nLR Prediction: {} \nDT Prediction: {}".format(output_lable(pred_LR[0]), 
                                                                                                              output_lable(pred_DT[0])))

# %%
manual_testing(sys.argv[1])


