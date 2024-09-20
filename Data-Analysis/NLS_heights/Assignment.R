library(modelr); library(dplyr); library(ggplot2); library(car)

data = heights

# Find the sample size of the dataset
sample_size <- nrow(data); sample_size
# Which are numeric variables
numeric_vars <- select_if(data, is.numeric); numeric_vars 
# Which are categoric variables
categoric_vars <- select_if(data, is.factor); categoric_vars

# Draw a Random Sample of 100
set.seed(7283652)
random_sample <- data[sample(nrow(data), size=100, replace=FALSE), ]

# Convert weight to kg and height to meters
random_sample$weight_kg <- random_sample$weight * 0.453592
random_sample$height_m <- random_sample$height * 0.0254

# Define BMI, Obese and levels variable
random_sample <- random_sample %>% mutate(BMI = weight_kg / (height_m)^2)
random_sample <- random_sample %>% mutate(Obese = ifelse(BMI >= 30, TRUE, FALSE))
random_sample <- random_sample %>% mutate(Levels = case_when(
  BMI < 25 ~ "normal", BMI >= 25 & BMI < 30 ~ "overweight", BMI >= 30 ~ "Obese"
))

# Create a plot that shows the distribution of BMI for men and women
ggplot(random_sample, aes(x=BMI, color=sex, fill=sex)) +
  geom_density(alpha=0.5) +
  geom_vline(xintercept = mean(random_sample$BMI), color="black", size=1) +
  labs(title="Distribution of BMI for Men and Women", 
       x="BMI",
       y="Frequency",
       color="BMI",
       fill="BMI") +
  theme_minimal()

# Remove rows with missing values
random_sample <- na.omit(random_sample)

# Show the association between income and afqt (armed forces qualification test score)
ggplot(random_sample, aes(x=afqt, y=income)) +
  geom_point() +
  labs(title="Scatterplot of income vs afqt", x="afqt", y="income") +
  theme_minimal()
# Quantitatively measure association using correlation coefficient
correlation = cor(random_sample$income, random_sample$afqt); correlation

# Create a subset of the random sample
subset_df <- random_sample[, c("afqt", "education")]
post_education <- subset_df[subset_df$education >= 13, "afqt"]
no_post_education <- subset_df[subset_df$education < 13, "afqt"]
# Null Hypothesis (H0): µ_post_edu = µ_no_post_edu
# Alternate Hypothesis (HA): µ_post_edu ≠ µ_no_post_edu
# afqt scores are independent between individuals
# Check for normality
par(mfrow = c(1, 2))
qqnorm(post_education$afqt)
qqnorm(no_post_education$afqt)
# Both post education and no post education approximately follow a straight line
# So we can assume they are both approximately normal
# t.test to check if there is a statistically significant difference b/w the means
test_statistic <- t.test(post_education, no_post_education)
p_value <- test_statistic$p.value
if (p_value < 0.05) {
  print("Reject the null hypothesis")
} else {
  print("Fail to reject the null hypothesis")
}

# Create subsets
# school-only = 0; some post edu = 1; more post edu = 2
subset_df$education_group <- cut(subset_df$education,
                                 breaks = c(-Inf, 12, 15, Inf),
                                 labels = c("0", "1", "2"),
                                 include.lowest = TRUE)
# Null Hypothesis (H0): There is no difference in the mean afqt scores among the three groups
# Alternate Hypothesis (HA): There is a difference
# Assume independence and distributions seem normal approximately
par(mfrow=c(1,1))
qqnorm(subset_df$afqt)
# Check if variance is equal among the distributions
levene_test = leveneTest(afqt ~ education_group, data=subset_df)
print(levene_test)
anova_result <- aov(afqt ~ education_group, data=subset_df)
print(summary(anova_result))

plot(random_sample$education, random_sample$afqt)

##############################################################################################
# Proving alpha = type I error
# H_0 : µ = 0.5  # H_A : µ ≠ 0.5
set.seed(7283652)
# Define the parameters
n=30; alpha=0.05; mu=0.5;
# number of simulations to perform
num_simulations = 80000
reject_count = 0

# Perform simulations
for (i in 1:num_simulations) {
  # Generate the uniform dist. sample with given range
  sample_data <- runif(n, min=0, max=1)
  # Perform hypothesis test
  test_statistic <- t.test(sample_data, mu=mu, alternative="two.sided")
  # Calculate the p-value for the two-sided test
  p_value = test_statistic$p.value
  # CHeck if null hypothesis should be rejected
  if (p_value < alpha) {
    reject_count <- reject_count + 1
  }
}

# Estimate type 1 error rate
type_1_error_rate = reject_count / num_simulations; print(type_1_error_rate)
