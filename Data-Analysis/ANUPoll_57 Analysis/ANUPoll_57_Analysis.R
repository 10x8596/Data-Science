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

# ----------------------------------------- Correlation ------------------------------------------#

corr_variables = subset(data, select=c(A1, RA2_a, RA2_b, RA2_c, RA2_d, RA2_e))
for (variable in names(corr_variables)) {
  correlation = cor(data$A1, corr_variables[[variable]], method = 'pearson')
  print(paste("Correlation between A1 and", variable, "is:", correlation))
}
corr_matrix = cor(corr_variables)
p_values = rcorr(as.matrix(corr_variables))
print(paste("p-values: \n", p_values))

# Plot the correlation matrix
corrplot(corr_matrix, method = "color")

# ------------------------------------ Association Mining ----------------------------------------#

categoric_data = data; attach(categoric_data)

# Categorize all the numeric attributes
for (attribute in names(categoric_data)) {
  if (!is.factor(categoric_data[[attribute]])) {
    categoric_data[[attribute]] = as.factor(categoric_data[[attribute]])
  }
}

# Convert categoric dataframe to transactions
transaction_data = as(categoric_data, "transactions")

# Generating the Association rules
rules <- apriori(transaction_data, parameter=list(supp=0.25, conf=0.53, minlen=2))

# Filter rules by lift
filtered_rules = subset(rules, subset=lift > 1.5)

# Remove redundant rules
nonRedundant_rules = filtered_rules[!is.redundant(filtered_rules)]

# Remove statistically non-significant rules
significant_rules = nonRedundant_rules[!is.significant(nonRedundant_rules, tData,
                                                       method="fisher",adjust="bonferroni")]
rules_A1 = sort(subset(rules, subset=rhs %pin% "A1"), by="confidence")
summary(rules_A1); inspect(rules_A1[1:15])

# Plot the association rules for A1
plot(rules_A1[1:15], method="graph", measure="lift", shading="confidence")