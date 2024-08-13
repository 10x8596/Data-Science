library(ggplot2);library("Hmisc");library(corrplot);library(arules);library(party); library(GGally)
library(arulesViz);library(dplyr);library(tidymodels);library(caret);library(rpart);library(pROC)
library(rpart.plot); library(tree); library(e1071); library(kernlab); library(neuralnet) 
library(tidyverse); library(vip); library(RColorBrewer)

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

# ------------------------------------------ Classification --------------------------------------#

# Analyse how people voted in the referendum (yes or no)
data_tmp = data; attach(data_tmp)

# Create a new variable RB1_V2 mapping Yes from RB1 to TRUE, No to FALSE and others to NA
data_tmp <- data_tmp %>%
  mutate(RB1_V2 = ifelse(RB1 == 1, TRUE,
                         ifelse(RB1 == 2, FALSE, NA)))

# Check whether the mapping is 1 to 1
RB1_count = table(data_tmp$RB1); RB1_v2_count = table(data_tmp$RB1_V2)
RB1_count; RB1_v2_count # checks out

# Remove all rows that contain NA in RB1_V2
data_tmp = data_tmp[complete.cases(data_tmp$RB1_V2), ]

# Remove RB1 itself
data_tmp = data_tmp[, -which(names(data_tmp) == "RB1")]
data_tmp = data_tmp[, -which(names(data_tmp) == "SRCID")]
data_tmp = data_tmp[, -which(names(data_tmp) == "IntDate")]

# For classification, RB1_V2 will be the target class, every other /srcid is input (independent)
# Split the data into train and test sets
split = initial_split(data_tmp, prop = 0.7, strata = RB1_V2)
train = split %>% training()
test  = split %>% testing()

# Logistic Regression Classifier ##################################################################
lr_model = glm(RB1_V2 ~ ., data=train, family=binomial(link='logit'))
summary(lr_model)
predictions = predict(lr_model, newdata=test, type='response')
predicted_classes = ifelse(predictions > 0.5, TRUE, FALSE)
confusion_matrix <- confusionMatrix(factor(predicted_classes), factor(test$RB1_V2), 
                                    mode='everything')
print(confusion_matrix)

# Decision Tree Classifier ########################################################################
tune_spec <- decision_tree(cost_complexity=tune(), tree_depth=tune(), min_n=tune()) %>%
  set_engine("rpart") %>% set_mode("classification")
# Tuning grid
tree_grid <- grid_regular(cost_complexity(), tree_depth(), min_n(), levels=5)
# Cross validation
cv_folds <- vfold_cv(train)
# Model Tuning with a Grid
tree_workflow <- workflow() %>% add_model(tune_spec) %>% add_formula(factor(RB1_V2) ~ .)
tree_res <- tree_workflow %>% tune_grid(resamples = cv_folds, grid = tree_grid)
tree_res %>% collect_metrics() %>% mutate(tree_depth = factor(tree_depth)) %>%
  ggplot(aes(cost_complexity, mean, color = tree_depth)) + geom_line(linewidth=1.5, alpha=0.6) +
  geom_point(size = 2) + facet_wrap(~ .metric, scales = "free", nrow = 2) +
  scale_x_log10(labels = scales::label_number()) +
  scale_color_viridis_d(option = "plasma", begin = .9, end = 0)
best_tree <- tree_res %>% select_best(metric="accuracy")

# Finalise workflow
final_workflow <- tree_workflow %>% finalize_workflow(best_tree)
final_fit <- final_workflow %>% last_fit(split)
final_tree <- extract_workflow(final_fit)
final_tree %>% extract_fit_engine() %>% rpart.plot(roundint = FALSE)
final_tree %>% extract_fit_parsnip() %>% vip()

# Optimal Classification tree
control <- rpart.control(cp=1e-10, minsplit=30, maxdepth=4, minbucket=5)
optimal_tree_model <- rpart(RB1_V2 ~ ., data=train, method='class',
                            control=control)
pruned_tree_model <- prune(optimal_tree_model, cp=1e-10)
rpart.plot(pruned_tree_model)
printcp(pruned_tree_model); plotcp(pruned_tree_model)
pred_tree <- predict(pruned_tree_model, newdata=test, type='class')
confusion_matrix <- confusionMatrix(data=factor(pred_tree), reference=factor(test$RB1_V2), 
                                    mode='everything')
print(confusion_matrix)
# ROC Curve
predictions <- predict(optimal_tree_model, test, type = "prob")
pred_probs = predictions[, "TRUE"]
roc_curve <- roc(test$RB1_V2, pred_probs)
plot(roc_curve, main = "ROC Curve", col = "blue", lwd = 2)
auc_score <- auc(roc_curve)
text(0.5, 0.5, paste("AUC =", round(auc_score, 3)), adj = c(0.5, 0.5), col = "black", cex = 1.2)

# SVM Classifier ##################################################################################
# Hypertuning parameters
tuned_model = tune(svm, factor(RB1_V2) ~ ., data=train, kernel="radial", 
                   ranges=list(cost=c(0.001, 0.01, 0.1, 1, 5, 10, 100),
                               gamma=c(0.5,1,2,3,4)))
plot(tuned_model)
best_model <- tuned_model$best.model; best_model

# Optimal svm model
svm_model <- svm(factor(RB1_V2) ~ ., data=train, kernel="radial", cost=5, 
                 scale=TRUE, probability=TRUE)
pred_svm <- predict(svm_model, newdata = test)
confusion_matrix <- confusionMatrix(data=factor(pred_svm), reference=factor(test$RB1_V2), 
                                    mode='everything')
print(confusion_matrix)
# Feature ranking
coeff = sort(abs(coef(svm_model)), decreasing=TRUE)
print(coeff)
# SVM classification plot using most important features
plot(svm_model, train, formula=RB1_V2~RD4_b+RD4_d, fill=TRUE, grid=50)
# ROC Curve
predictions <- predict(svm_model, newdata = test, probability = TRUE)
predicted_probabilities <- attr(predictions, "probabilities")[, "TRUE"]
roc_curve <- roc(test$RB1_V2, predicted_probabilities)
auc_score <- auc(roc_curve)
plot(roc_curve, main = "ROC Curve", col = "blue", lwd = 2)
text(0.5, 0.5, paste("AUC =", round(auc_score, 3)), adj = c(0.5, 0.5), col = "black", cex = 1.2)

# Neural Net Classifier ###########################################################################
split1 = initial_split(data_tmp, prop = 0.2, strata = RB1_V2)
train1 = split1 %>% training()
test1  = split1 %>% testing()
normalize <- function(x) {
  return((x-min(x)) / (max(x) - min(x)))
}
scaled_train = train1 %>% mutate_all(normalize)
scaled_test = test1 %>% mutate_all(normalize)

# neural net classification models
# 2-Hidden Layers, Layer-1 2-neurons, Layer-2, 1-neuron
nn1 <- neuralnet(RB1_V2 ~ ., data=scaled_train, hidden=c(2,1),
                 linear.output=FALSE, threshold=0.05,
                 err.fct='ce', likelihood=TRUE)
# 2-Hidden Layers, Layer-1 2-neurons, Layer-2, 2-neurons
nn2 <- neuralnet(RB1_V2 ~ ., data=scaled_train, hidden=c(2,2),
                 linear.output=FALSE, threshold=0.05, stepmax=1e+06,     
                 err.fct='ce', likelihood=TRUE)
# 2-Hidden Layers, Layer-1 1-neuron, Layer-2, 2-neuron
nn3 <- neuralnet(RB1_V2 ~ ., data=scaled_train, hidden=c(1,2),
                 linear.output=FALSE, threshold=0.05, stepmax=1e+06,
                 err.fct='ce', likelihood=TRUE)
# 2-Hidden Layers, Layer-1 1-neuron, Layer-2, 1-neuron
nn4 <- neuralnet(RB1_V2 ~ ., data=scaled_train, hidden=c(1,1),
                 linear.output=FALSE, threshold=0.05, stepmax=1e+06,
                 err.fct='ce', likelihood=TRUE)
# Bar plot of results
Class_NN_ICs <- tibble('Network'=rep(c("NN1", "NN2", "NN3", "NN4"), each=3),
                       'Metric'=rep(c('AIC', 'BIC', 'ce Error * 100'), length.out = 12),
          'Value'=c(nn1$result.matrix[4,1], nn1$result.matrix[5,1], 100*nn1$result.matrix[1,1],
                    nn2$result.matrix[4,1], nn2$result.matrix[5,1], 100*nn2$result.matrix[1,1],
                    nn3$result.matrix[4,1], nn3$result.matrix[5,1], 100*nn3$result.matrix[1,1],
                    nn4$result.matrix[4,1], nn4$result.matrix[5,1], 100*nn4$result.matrix[1,1]))
Class_NN_ICs %>% 
  ggplot(aes(Network, Value, fill=Metric)) +
  geom_col(position='dodge') + ggtitle("AIC, BIC, and Cross-Entropy Error of the NNs")

plot(nn1, rep='best')
paste("CE Error: ", round(nn1$result.matrix[1,1], 3))
paste("AIC: ", round(nn1$result.matrix[4,1],3))
paste("BIC: ", round(nn1$result.matrix[5,1],3))

# Test the resulting output
test_tmp = test %>% select(-RB1_V2)
nn.results = compute(nn1, test_tmp)
results = data.frame(actual=test$RB1_V2, prediction=nn.results$net.result)

# Confusion matrix
roundedResults = sapply(results, round, digits=0)
roundedResultsdf = data.frame(roundedResults)
attach(roundedResultsdf); cf_matrix = table(actual, prediction); cf_matrix

# Calculate TP, TN, FP, FN from the confusion matrix
TP <- cf_matrix[2, 2]; TN <- cf_matrix[1, 1]; FP <- cf_matrix[1, 2]; FN <- cf_matrix[2, 1]
accuracy <- (TP + TN) / sum(cf_matrix); precision <- TP / (TP + FP)
sensitivity <- TP / (TP + FN); specificity <- TN / (TN + FP)
F1 <- 2 * (precision * sensitivity) / (precision + sensitivity)
print(cat("acc:", accuracy, "\n", "precision:", precision, "\n", "sens:", sensitivity, "\n",
          "spec:", specificity, "\n", "F1:", F1))