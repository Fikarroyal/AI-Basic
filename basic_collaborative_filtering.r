install.packages("recommenderlab")
install.packages("Matrix")
install.packages("ggplot2")

# Memuat pustaka yang diperlukan
library(recommenderlab)
library(Matrix)
library(ggplot2)

# Membaca dataset
data <- read.csv("?.csv")

# Membuat matriks pengguna-item dari data
rating_matrix <- as(data.frame(table(data$User, data$Item, data$Rating)), "realRatingMatrix")

# Melihat struktur data
summary(rating_matrix)

# Membuat model Collaborative Filtering
rec_model <- Recommender(rating_matrix, method = "UBCF", param = list(k = 5))

# Melakukan prediksi rekomendasi untuk pengguna tertentu
predictions <- predict(rec_model, rating_matrix[1:5], type = "topNList", n = 3)

# Menampilkan hasil rekomendasi
as(predictions, "list")

# Mengevaluasi model (menggunakan data uji dan training set)
evaluation_scheme <- evaluationScheme(rating_matrix, method = "split", train = 0.8, given = 3)
eval_results <- evaluate(evaluation_scheme, method = "UBCF", param = list(k = 5))

# Plot hasil dari evaluasi 
plot(eval_results, main = "Evaluasi Model Collaborative Filtering")
