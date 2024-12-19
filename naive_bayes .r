install.packages("tm")
install.packages("e1071")
install.packages("caret")

# Memuat pustaka yang diperlukan
library(tm)
library(e1071)
library(caret)

# Langkah 1: Membaca data 
data <- read.csv("?.csv", stringsAsFactors = FALSE)

# Langkah 2: Memproses teks dengan package tm
corpus <- Corpus(VectorSource(data$text))  # Membuat korpus dari teks
corpus <- tm_map(corpus, content_transformer(tolower))  # Mengubah teks menjadi huruf kecil
corpus <- tm_map(corpus, removePunctuation)  # Menghapus tanda baca
corpus <- tm_map(corpus, removeNumbers)  # Menghapus angka
corpus <- tm_map(corpus, removeWords, stopwords("en"))  # Menghapus kata-kata umum (stopwords)
corpus <- tm_map(corpus, stripWhitespace)  # Menghapus spasi ekstra

# Langkah 3: Membuat matriks kata (Document-Term Matrix)
dtm <- DocumentTermMatrix(corpus)

# Langkah 4: Membagi data menjadi data latih dan data uji
set.seed(42)  # Menetapkan seed agar hasil bisa direproduksi
trainIndex <- createDataPartition(data$label, p = 0.7, list = FALSE)
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]
trainDTM <- dtm[trainIndex, ]
testDTM <- dtm[-trainIndex, ]

# Langkah 5: Melatih model Naive Bayes
model <- naiveBayes(as.matrix(trainDTM), trainData$label)

# Langkah 6: Memprediksi data uji
predictions <- predict(model, as.matrix(testDTM))

# Langkah 7: Mengevaluasi model dengan Matriks
confMatrix <- confusionMatrix(predictions, testData$label)
print(confMatrix)

# Langkah 8: Menampilkan akurasi
accuracy <- confMatrix$overall['Accuracy']
cat("Akurasi Model Naive Bayes: ", accuracy * 100, "%")
