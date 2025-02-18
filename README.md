# 🍷 Red Wine Quality Prediction using Machine Learning  

## 📌 Project Overview  
This project analyzes the physiochemical properties of red wine and predicts its quality using multiple statistical models. It was completed as part of the **MA2405 Advanced Statistical Modelling** course.  

## 📊 Models Implemented  
- ✅ Linear Regression  
- ✅ Logistic Regression (GLM)  
- ✅ Decision Tree  
- ✅ Random Forest  
- ✅ Stepwise Regression  

## 💾 Dataset  
- **Source:** [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/wine+quality)  
- **Records:** 1,599 red wine samples  
- **Features:** 11 physiochemical properties and 1 quality score  

## 🚀 Results  
- 🏆 **Best Model:** Random Forest (highest accuracy)  
- 📌 **Key Predictors of Wine Quality:**  
  - `alcohol`  
  - `sulphates`  
  - `volatile acidity`  

## 🛠️ How to Run  
### 1️⃣ **Requirements:**  
- R 4.2.0 or above  
- RStudio (recommended)  

### 2️⃣ **Install Dependencies:**  
```r
install.packages(c('corrplot', 'ggplot2', 'randomForest', 'caret', 'party', 'rpart.plot'))
```

### 3️⃣ Run Analysis:
```sh
source('src/MA2405_GROUP_PROJECT.R')
```

## 📈 Key Visualizations
- 📊 Heatmap: Correlations between variables
- 🌿 Dendrogram: Hierarchical clustering of variables
- 🌲 Decision Tree: Key decision splits for wine quality
- 🟢 Random Forest: Feature importance plot

## 📝 Group Members
Punit Rajesh Shah (14373530)  
Ellen Dinata Jo (14162236)   
Nicole Sin Yi Qin (14309923)  
Sathvika Subramanian (14262767)  
Se Dickson (14345902) 
