library(ggplot2);library("Hmisc");library(corrplot);library(arules);library(party); library(GGally)
library(arulesViz);library(dplyr);library(tidymodels);library(caret);library(rpart);library(pROC)
library(rpart.plot); library(tree); library(e1071); library(kernlab)
library(neuralnet); library(tidyverse);

setwd("/Users/razeenwasif/Documents/ANU/ANU_Y4_S1/COMP3425/Assignment2/Assignment 2-20240408/")
filename = '02_ANUPoll_57_CSV_100150_general.csv'
data = read.csv(filename, sep=',', header=TRUE)
attach(data);
sample_size = nrow(data); print(sample_size)

# ----------------------------------- Information on the Data ------------------------------------#

# Display data type of all columns
for (col in colnames(data)) {
  data_type = class(data[[col]])
  print(paste("data type of",col,"is:",data_type))
}
ggpairs(data, title = "Scatterplot Matrix of the Features of the Data Set")

# ----------------------------------------- Data Cleaning ----------------------------------------#

# Remove unnecessary columns from categoric data
data <- data %>% select(-contains(c("ORDER", "VERB", "RB11")))

# Find and Remove missing values
missing_counts = colSums(is.na(data))
columns_with_missing = names(missing_counts[missing_counts > 0])
print(columns_with_missing)

# Replace missing values
data$Z1_ANCESTRY_2[is.na(data$Z1_ANCESTRY_2)] <- 9999
data[is.na(data)] <- -99
colSums(is.na(data))

# ------------------------------------------ Regression ------------------------------------------#

data_reg = data; attach(data_reg)
data_reg = data_reg[, -which(names(data_reg) == "IntDate")]

# Partition the dataset
set.seed(108596)
split = initial_split(data_reg, prop = 0.7, strata = weight_final_ref)
train_reg = split %>% training(); test_reg  = split %>% testing()

predictors = names(data_reg)[startsWith(names(data_reg), "p")]
fm = as.formula(paste("weight_final_ref ~", paste(predictors, collapse="+")))

normalize <- function(x) {
  return((x-min(x)) / (max(x) - min(x)))
}

# Scale data for neural network (tree as well)
scaled_train_reg <- train_reg %>% mutate_all(normalize)
scaled_test_reg <- test_reg %>% mutate_all(normalize)
# Rescale for tanh activation
scale <- function(x) {
  (2 * ((x - min(x))/(max(x) - min(x)))) - 1
}
scaled_train_reg_tanh = scaled_train_reg %>% mutate_all(scale)
scaled_test_reg_tanh = scaled_test_reg %>% mutate_all(scale)

# Regression Tree #################################################################################
# Hyperparameter tuning grid
hyper_grid <- expand.grid(minsplit=seq(0,20,1), maxdepth=seq(5,15,1), 
                          cp=seq(0.01,0.5,0.01), minbucket=seq(0,10,1))
# Loop through each parameter to train a model
reg_tree_models <- list()
for (i in 1:nrow(hyper_grid)) {
  minsplit = hyper_grid$minsplit[i]
  maxdepth = hyper_grid$maxdepth[i]
  cp = hyper_grid$cp[i]
  minbucket = hyper_grid$minbucket[i]
  reg_tree_models[[i]] <- rpart(formula=fm, data=scaled_train_reg, method="anova", 
                                control=list(cp=cp, xval=10, minsplit=minsplit, 
                                             maxdepth=maxdepth, minbucket=minbucket))
}
# function to get optimal cp
get_cp <- function(x) {
  min = which.min(x$cptable[, "xerror"])
  cp = x$cptable[min, "CP"]
}
# function to get min error
get_min_error <- function(x) {
  min = which.min(x$cptable[, "xerror"])
  xerror = x$cptable[min, "xerror"]
}
hyper_grid %>% mutate(cp=purrr::map_dbl(reg_tree_models, get_cp),
                      error=purrr::map_dbl(reg_tree_models, get_min_error)) %>%
  arrange(error) %>% top_n(n=5, wt=error)

# Bagging and Cross_validation
ctrl <- trainControl(method = "cv",  number = 10) 
bagged_cv <- caret::train(weight_final_ref~.,
                          data=scaled_train_reg, method = "treebag", trControl = ctrl, importance = TRUE)
plot(varImp(bagged_cv), 20)

# Optimal Regression Tree
control <- rpart.control(cp=0.00435, minsplit=15, maxdepth=5, minbucket=3, xval=10)
optimal_regression_tree_model <- rpart(formula=fm, data=scaled_train_reg, method="anova", 
                                       control=control)
rpart.plot(optimal_regression_tree_model)
plotcp(optimal_regression_tree_model); optimal_regression_tree_model$cptable

# Pruning the regression tree
# cp=0.02 b/c xerror doesn't decrease significantly after 5th split
pruned_regression_tree = prune(optimal_regression_tree_model, cp=0.02)

# Metrics for Evaluating the regression tree model performance
reg_tree_pred = predict(pruned_regression_tree, scaled_test_reg)
print(paste("RMSE:", RMSE(reg_tree_pred, scaled_test_reg$weight_final_ref)))
print(paste("R-Square:", (cor(scaled_test_reg$weight_final_ref, reg_tree_pred))^2))
print(paste("MAE:", MAE(reg_tree_pred, scaled_test_reg$weight_final_ref)))

# ROC Curve
predicted_labels <- ifelse(predicted_values > 0.5, 1, 0)
roc_curve <- roc(scaled_test_reg$weight_final_ref, predicted_labels)
plot(roc_curve, main = "ROC Curve", col = "blue")

# Neural Network ##################################################################################
# Hyperparameter tuning
hyper_grid_nn <- expand.grid(rep=seq(1,10,1), hidden1=seq(1,5,1), hidden2=seq(1,5,1),
                             threshold=seq(0.01,0.1,0.01))

# Loop through each parameter to train a logistic activation function model
reg_nn_models_log <- list()
for (i in 1:nrow(hyper_grid_nn)) {
  rep = hyper_grid_nn$rep[i]
  hidden1 = hyper_grid_nn$hidden1[i]
  hidden2 = hyper_grid_nn$hidden2[i]
  threshold = hyper_grid_nn$threshold[i]
  reg_nn_models_log[[i]] <- neuralnet(formula=fm, data=scaled_train_reg, 
                                      hidden=c(hidden1, hidden2), act.fct="logistic", rep=rep,
                                      stepmax=1e+07, threshold=threshold)
}
# Loop through each parameter to train a tanh activation function model
reg_nn_models_tanh <- list()
for (i in 1:nrow(hyper_grid_nn)) {
  rep = hyper_grid_nn$rep[i]
  hidden1 = hyper_grid_nn$hidden1[i]
  hidden2 = hyper_grid_nn$hidden2[i]
  threshold = hyper_grid_nn$threshold[i]
  reg_nn_models_tanh[[i]] <- neuralnet(formula=fm, data=scaled_train_reg_tanh,
                                       hidden=c(hidden1, hidden2), act.fct="tanh", rep=rep,
                                       stepmax=1e+07, threshold=threshold)
}

# Plot error of all models
error_metrics <- list()
# Loop through each model in the list
for (i in seq_along(reg_nn_models_log)) {
  # Make predictions using the current model
  predictions <- compute(reg_nn_models_log[[i]], scaled_test_reg[predictors])$net.result
  # Calculate error metric(s) based on your requirements
  # For example, you can calculate Mean Squared Error (MSE)
  sse <- sum((predictions - scaled_test_reg$weight_final_ref)^2)/2
  # Store the error metric(s) in the list
  error_metrics[[i]] <- sse
  # Print or display the error for the current model
  print(paste("Model", i, "SSE:", sse))
}

# Access error metrics for each model from the 'error_metrics' list
for (i in seq_along(error_metrics)) {
  print(paste("Model", i, "SSE:", error_metrics[[i]]))
}
# Look up the parameters of Model i

# Optimal neural net regression model
optimal_regression_nn_model <- neuralnet(formula=fm,data=scaled_train_reg, act.fct='logistic',
                                         hidden=c(4,3), rep=1, stepmax=1e+06, threshold=0.05)
plot(optimal_regression_nn_model, rep='best')

# Metrics to evaluate the model performance
reg_nn_pred = predict(optimal_regression_nn_model, scaled_test_reg)
print(paste("RMSE:", RMSE(reg_nn_pred, scaled_test_reg$weight_final_ref)))
print(paste("R-Square:", (cor(scaled_test_reg$weight_final_ref, reg_nn_pred))^2))
print(paste("MAE:", MAE(reg_nn_pred, scaled_test_reg$weight_final_ref)))