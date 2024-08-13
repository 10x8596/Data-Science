library(ggplot2);library("Hmisc");library(corrplot);library(arules);library(party); library(GGally)
library(arulesViz);library(dplyr);library(tidymodels);library(caret);library(rpart);library(pROC)
library(rpart.plot); library(tree); library(e1071); library(kernlab); library(factoextra)
library(neuralnet); library(tidyverse); library(cluster); library(gridExtra); library(ggplot2)

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

normalize <- function(x) {
  return((x-min(x)) / (max(x) - min(x)))
}

RD7_variables = subset(data, select=c(RD7_a, RD7_b, RD7_c, RD7_d, RD7_e))

# Scale the dataset to fall in the range [0-1]
RD7_variables <- RD7_variables %>% mutate_all(normalize)

# ------------------------------------------ Clustering ------------------------------------------#

distance <- get_dist(RD7_variables)
fviz_dist(distance, gradient=list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

# Hyperparameter tuning (Elbow Method)
fviz_nbclust(RD7_variables, kmeans, method="wss")
# Hyperparameter tuning (Silhouette Method)
fviz_nbclust(RD7_variables, kmeans, method="silhouette")
# Hyperparameter tuning (Silhouette Method)
gap_stat <- clusGap(RD7_variables, FUN=kmeans, nstart=25, K.max=10, B=50)
fviz_gap_stat(gap_stat)

# 4, 5, 10
kmeans_model <- kmeans(RD7_variables, centers=4, nstart = 25); print(kmeans_model)

# Plots to compare
str(kmeans_model); kmeans_model; fviz_cluster(kmeans_model, data=RD7_variables)
p <- fviz_cluster(kmeans_model, geom = "point", data=RD7_variables) + ggtitle("k = 4"); p

# Calculate the sum of the within-cluster-sum-of-squares
wcss <- sum(kmeans_model$tot.withinss); wcss; str(kmeans_model)

# Interpret results
RD7_variables %>% mutate(Cluster = kmeans_model$cluster) %>% group_by(Cluster) %>%
  summarise_all("mean")

# Create scatterplot matrix
pairs(RD7_variables, col = kmeans_model$cluster)
