install.packages("randomForest")
install.packages("caret")
install.packages("dplyr")

# Memuat pustaka yang diperlukan
library(randomForest)
library(caret)
library(dplyr)

# Langkah 1: Membaca dataset
data <- read.csv("?.csv")

# Langkah 2: Memeriksa struktur data
str(data)

# Langkah 3: Membagi data menjadi data latih dan data uji
set.seed(42)  # Menetapkan seed agar hasil bisa direproduksi
trainIndex <- createDataPartition(data$Class, p = 0.7, list = FALSE)
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# Langkah 4: Membuat model Random Forest
model_rf <- randomForest(Class ~ ., data = trainData, importance = TRUE, ntree = 100)

# Langkah 5: Memprediksi data uji
predictions <- predict(model_rf, testData)

# Langkah 6: Mengevaluasi model dengan Matriks
confMatrix <- confusionMatrix(predictions, as.factor(testData$Class))
print(confMatrix)

# Langkah 7: Menampilkan akurasi
accuracy <- confMatrix$overall['Accuracy']
cat("Akurasi Model Random Forest: ", accuracy * 100, "%")
