install.packages("rpart")
install.packages("caret")
install.packages("rpart.plot")

# Memuat pustaka yang diperlukan
library(rpart)
library(caret)
library(rpart.plot)

# Langkah 1: Memuat dataset Iris
data(iris)

# Langkah 2: Membagi dataset menjadi data latih dan data uji
set.seed(42)  # Menetapkan seed agar hasil bisa direproduksi
trainIndex <- createDataPartition(iris$Species, p = 0.7, list = FALSE)  # Membagi data 70% latih
trainData <- iris[trainIndex, ]
testData <- iris[-trainIndex, ]

# Langkah 3: Membuat model Decision Tree
treeModel <- rpart(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
                   data = trainData, method = "class")

# Langkah 4: Menampilkan model tree
rpart.plot(treeModel)

# Langkah 5: Memprediksi data uji
predictions <- predict(treeModel, testData, type = "class")

# Langkah 6: Mengevaluasi model dengan menghitung akurasi
confMatrix <- confusionMatrix(predictions, testData$Species)
print(confMatrix)

# Langkah 7: Menampilkan akurasi model
accuracy <- confMatrix$overall['Accuracy']
cat("Akurasi Model Decision Tree: ", accuracy * 100, "%")
