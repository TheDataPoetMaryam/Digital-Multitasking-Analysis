# ---------------------------
# 1. Setup
# ---------------------------
library(psych)
library(car)
library(corrplot)
library(lm.beta)
library(relaimpo)
library(rpart)
library(rpart.plot)
library(factoextra)

# ---------------------------
# 2. Load Data
# ---------------------------
data <- read.csv("C:\Users\Maryam\MSc\Field Project\multitasking_analysis_dataset.csv")

data$gender <- as.factor(data$gender)
data$age_group <- as.factor(data$age_group)

# ---------------------------
# 3. Descriptive Statistics
# ---------------------------
describe(data[,c("score",
                 "multitasking_index",
                 "screen_time_code",
                 "notifications_code",
                 "focus_level")])

hist(data$score, col="skyblue", main="Task Score Distribution")

plot(data$multitasking_index, data$score,
     col="blue", pch=19,
     xlab="Multitasking Index",
     ylab="Task Score")

# ---------------------------
# 4. Correlation
# ---------------------------
cor_matrix <- cor(data[,c("score",
                          "multitasking_index",
                          "screen_time_code",
                          "notifications_code",
                          "focus_level")])

corrplot(cor_matrix, method="color")

# ---------------------------
# 5. Regression Models
# ---------------------------
model1 <- lm(score ~ multitasking_index, data=data)

model2 <- lm(score ~ multitasking_index + screen_time_code, data=data)

model3 <- lm(score ~ multitasking_index +
               screen_time_code +
               notifications_code +
               focus_level,
             data=data)

summary(model3)
vif(model3)

# ---------------------------
# 6. Interaction Model
# ---------------------------
data$MTI_notifications <- data$multitasking_index * data$notifications_code

model_interaction <- lm(score ~ multitasking_index +
                          notifications_code +
                          MTI_notifications +
                          screen_time_code +
                          focus_level,
                        data=data)

summary(model_interaction)

# Effect size
r2 <- summary(model_interaction)$r.squared
f2 <- r2/(1-r2)
f2

# Standardized coefficients
lm.beta(model_interaction)

# Relative importance
calc.relimp(model_interaction, type="lmg", rela=TRUE)

# ---------------------------
# 7. Decision Tree
# ---------------------------
tree_model <- rpart(score ~ multitasking_index +
                      screen_time_code +
                      notifications_code +
                      focus_level,
                    data = data,
                    method = "anova")

rpart.plot(tree_model)

# ---------------------------
# 8. Clustering
# ---------------------------

# Select relevant features
cluster_data <- data[,c("multitasking_index",
                        "notifications_code",
                        "screen_time_code",
                        "focus_level")]

# Scale data
cluster_scaled <- scale(cluster_data)

# ---------------------------
# Determine optimal clusters (Elbow Method)
# ---------------------------
wss <- numeric(10)

for (i in 1:10) {
  wss[i] <- kmeans(cluster_scaled, centers=i, nstart=20)$tot.withinss
}

plot(1:10, wss,
     type="b",
     pch=19,
     xlab="Number of Clusters",
     ylab="Within-cluster Sum of Squares",
     main="Elbow Method")

# ---------------------------
# Apply K-Means (k = 3)
# ---------------------------
set.seed(123)

kmeans_model <- kmeans(cluster_scaled,
                       centers=3,
                       nstart=25)

data$cluster <- kmeans_model$cluster

# ---------------------------
# Cluster Interpretation
# ---------------------------

# Cluster centers
kmeans_model$centers

# Mean score per cluster
aggregate(score ~ cluster, data=data, mean)

# Visualization
boxplot(score ~ cluster,
        data=data,
        col="skyblue",
        xlab="Cluster",
        ylab="Task Score",
        main="Performance by Cluster")

# ---------------------------
# 9. ANOVA (Group Analysis)
# ---------------------------
data$MTI_group <- cut(data$multitasking_index,
                      breaks=c(-Inf,1,2,Inf),
                      labels=c("Low","Moderate","High"))

anova_model <- aov(score ~ MTI_group, data=data)
summary(anova_model)

# ---------------------------
# 10. Time Analysis (Optional)
# ---------------------------
data$time_seconds <- as.numeric(as.difftime(data$time_taken, units="secs"))

data_clean <- data[data$time_seconds <= 900, ]

model_time <- lm(score ~ multitasking_index +
                   notifications_code +
                   focus_level +
                   screen_time_code +
                   time_seconds,
                 data=data_clean)

summary(model_time)

# ---------------------------
# 11. Mediation Analysis
# ---------------------------
library(mediation)

model_m <- lm(focus_level ~ multitasking_index, data=data_clean)
model_y <- lm(score ~ multitasking_index + focus_level, data=data_clean)

med_model <- mediate(model_m, model_y,
                     treat="multitasking_index",
                     mediator="focus_level",
                     boot=TRUE, sims=5000)

summary(med_model)