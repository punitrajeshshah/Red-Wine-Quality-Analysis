#---
#  title: "MA2405_GROUP_PROGECT"
#output: html_document
#date: "2023-05-26"
#---
  ##### By: Ellen Dinata Jo (14162236), Nicole Sin Yi Qin (14309923), Punit Rajesh Shah (14373530), Sathvika Subramanian (14262767), Se Dickson (14345902)
  
  ## Read file
  #```{r}
# Load required dependencies.
library(corrplot)
library(ggplot2)
library(dendextend)
library(randomForest)
library(e1071)
library(glmnet)
library(caret)
library(party)
library(ggfortify)
library(rpart)
library(rpart.plot)

# Set working directory to file location.
setwd("D:/JCU/Semester/2023 SP51 trisemester 2/MA2405 Advanced Statistical Modelling/Group project")

# Read 'winequality-red.csv' file.
red_wine <- read.csv('winequality-red.csv', header = TRUE, sep = ";")
#```

## Data Analysis
#``` {r}
# Print summary of data set.
summary(red_wine)

# Observe structure of data set.
str(red_wine)

# Check for missing values.
missing_counts <- colSums(is.na(red_wine))
missing_counts
# No missing values in data set.
#```

#``` {r}
# Plot heat map of all variables.
cor_matrix <- cor(red_wine)
corrplot(cor_matrix, method = "color", type = "upper", tl.col = "black", tl.srt = 45)

# Bar plot of red wine quality distribution.
ggplot(red_wine,aes(x=as.factor(quality),fill=as.factor(quality)))+
  geom_bar(width = 0.5)+
  ggtitle("Distribution of wine quality")+
  theme(legend.position = "none")+
  xlab("quality")

# Select the input and output variables.
input_vars <- red_wine[, 1:11]
output_var <- red_wine[, 12]

# Calculate the correlation matrix.
cor_matrix <- cor(input_vars)

# Create a hierarchical clustering dendrogram.
dend <- as.dendrogram(hclust(as.dist(1 - cor_matrix)))

# Plot dendrogram.
par(mar = c(9, 5, 1, 1) + 0.1) # to adjust plot dimensions
plot(dend, main = "Dendrogram: Wine Dataset", xlab = "Input Variables", ylab = "Correlation with Quality")
#```


## Data Normality
#``` {r}
# Create a QQ plot of the 'quality' variable.
qqnorm(red_wine$quality)
# Plot QQ line.
qqline(red_wine$quality, col = "red")

# Shapiro Test.
shapiro.test(red_wine$quality)
# Shows that 'quality' variable is not normally distributed.

#```

## Splitting of data
#``` {r}
# Split the data into training and testing sets at 80:20 ratio respectively.
set.seed(123)
train_indices <- sample(1:nrow(red_wine), 0.8 * nrow(red_wine))
train_set <- red_wine[train_indices, ]
test_set <- red_wine[-train_indices, ]
#```

## Linear and Multiple reggression
#```{r}
# Perform linear regression
lm_model <- lm(quality ~ ., data = red_wine)

# Make predictions on the test set
lm_predictions <- predict(lm_model, newdata = test_set)

# Calculate the root mean squared error (RMSE)
lm_rmse <- sqrt(mean((lm_predictions - test_set$quality)^2))

# Print the summary of the linear regression model
summary(lm_model)

# Print the results of root mean squared error (RMSE)
cat("RMSE:", lm_rmse, "\n")


#Pvalue and T value for all the independent variables
summary(lm_model)$coefficients[, c("Pr(>|t|)", "t value")]

# Set the layout for multiple plots
par(mfrow = c(2, 2))

plot(lm_model)

# Plot the line of best fit for each variable
par(mfrow = c(3, 4))  # Set the layout for multiple plots

for (i in 1:11) {
  variable <- names(red_wine)[i]
  
  # Plot the data points
  plot(red_wine[, variable], red_wine$quality, xlab = variable, ylab = "Quality", main = paste("Line of Best Fit:", variable))
  
  # Add the line of best fit
  abline(lm_model$coefficients[i + 1], lm_model$coefficients[1], col = "red")
}

par(mfrow = c(1, 1))

#```

# Split the data into training and testing sets at 80:20 ratio respectively.
#``` {r}
# Split the data into training and testing sets at 80:20 ratio respectively.
red_wine <- read.csv('winequality-red.csv', header = TRUE, sep = ";")
red_wine$quality<-ifelse(red_wine$quality > 6,1,0) # Turning the quality variable into a 0 (bad wine) or 1 (good wine), it is considered bad wine if the quality is 6 or lower and good wine if the quality is 7 or higher.
red_wine$quality<- as.factor(red_wine$quality)

train_indices <- sample(1:nrow(red_wine), 0.8 * nrow(red_wine))
train_set <- red_wine[train_indices, ]
test_set <- red_wine[-train_indices, ]
#```

## Random Forest
#```{r}
# Train a random forest classifier.
rf_model <- randomForest(factor(quality) ~ ., data = train_set)

# Predict the quality labels for the testing set.
rf_predictions <- predict(rf_model, newdata = test_set)

# Create a confusion matrix
confusionMatrix(table(rf_predictions, test_set$quality))

# Plot variable importance
varImpPlot(rf_model)
#```

## Logistic Regression
#``` {r}
# Check dimensions of the train and test sets.
dim(train_set)
dim(test_set)

# Fitting model to GLM.
fit <- glm(quality~.,train_set,family = "binomial")
summary(fit)

# We can identify that sulphates, alcohol, total sulfur dioxide, chloride and residual sugar are significant variables.

# Apply the model to the test set.
test.step <- predict(fit,test_set)
# Convert the probability value to good or bad.
test.step <- ifelse(test.step > 0.5,1,0)
# create confusion matrix
confusionMatrix(table(test.step,test_set$quality))
#```

## Decision Tree
#```{r}
# Build decision tree.
tree1=ctree(quality~.,data = train_set)
tree1

# Alcohol is the most predictive variable.
plot(tree1, type = "simple")

# predict
pred <- predict(tree1, test_set)

pred_df <- data.frame(pred = pred)
test_df <- data.frame(quality = test_set$quality)

# Convert predicted labels and test data into a data frame as 'test_set$quality' is an atomic vector.
df <- cbind(pred_df, test_df)
confusion_matrix <- confusionMatrix(df$pred, df$quality)
confusion_matrix
#```

## Stepwise Regression with Logistic Regression
#```{r}
fit.step<-step(fit,direction="both")
summary(fit.step)

# Apply the model to the test set.
test.step <- predict(fit.step,test_set)
# Convert the probability value to good or bad.
test.step <- ifelse(test.step > 0.5,1,0)
# create confusion matrix
confusionMatrix(table(test.step,test_set$quality))
#```

## Stepwise Regression with Decision Tree
#```{r}
# Plot Decision Tree.
tree2 = ctree(quality~alcohol + sulphates + total.sulfur.dioxide + residual.sugar + chlorides + fixed.acidity + volatile.acidity + density, data = train_set)
tree2
plot(tree2, type = "simple")

# Calculate prediction and accuracy.
pred2 <- predict(tree2, newdata = test_set)

pred2_df <- data.frame(pred2 = pred2)
test2_df <- data.frame(quality = test_set$quality)

df <- cbind(pred2_df, test2_df)
confusion_matrix <- confusionMatrix(df$pred2, df$quality)
confusion_matrix
#```

## Stepwise Regression with Random Forest
#```{r}
# Train a random forest classifier.
rf_model2 <- randomForest(factor(quality) ~ alcohol + sulphates + total.sulfur.dioxide + residual.sugar + chlorides + fixed.acidity + volatile.acidity + density, data = train_set)

# Predict the quality labels for the testing set.
rf_predictions <- predict(rf_model2, newdata = test_set)

# Create a confusion matrix
confusionMatrix(table(rf_predictions, test_set$quality))
#```
