install.packages("mlbench")
install.packages("caret")
install.packages("randomForest")
install.packages("ggplot2")

# Memuat pustaka yang diperlukan
library(mlbench)
library(caret)
library(randomForest)
library(ggplot2)

# Memuat dataset Boston Housing
data(BostonHousing)

# Memeriksa struktur data
str(BostonHousing)

# Melihat beberapa baris pertama dari dataset
head(BostonHousing)

# Memisahkan data menjadi data latih dan data uji
set.seed(42)
trainIndex <- createDataPartition(BostonHousing$medv, p = 0.8, list = FALSE)
trainData <- BostonHousing[trainIndex, ]
testData <- BostonHousing[-trainIndex, ]

# Membangun model Random Forest untuk prediksi harga rumah
model_rf <- randomForest(medv ~ ., data = trainData)

# Melihat ringkasan model
print(model_rf)

# Memprediksi harga properti menggunakan model yang telah dilatih
predictions <- predict(model_rf, testData)

# Membuat matriks
postResample(predictions, testData$medv)

# Menghitung MSE (Mean Squared Error) untuk mengevaluasi model
mse <- mean((predictions - testData$medv)^2)
cat("MSE (Mean Squared Error): ", mse)

# Visualisasi prediksi vs harga asli
ggplot(data = testData, aes(x = medv, y = predictions)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Prediksi vs Harga Asli Properti",
       x = "Harga Asli (medv)",
       y = "Harga Prediksi")

# Menghitung R-squared untuk mengevaluasi positif model
rsq <- 1 - sum((predictions - testData$medv)^2) / sum((mean(testData$medv) - testData$medv)^2)
cat("R-squared: ", rsq)
