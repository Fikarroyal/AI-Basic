install.packages("plumber")
install.packages("jsonlite")
install.packages("httr")

# Memuat pustaka plumber
library(plumber)

# Endpoint untuk menjalankan robot maju
#* @post /move_forward
function() {
  list(
    status = "Robot bergerak maju",
    command = "move_forward"
  )
}

# Endpoint untuk menjalankan robot mundur
#* @post /move_backward
function() {
  list(
    status = "Robot bergerak mundur",
    command = "move_backward"
  )
}

# Endpoint untuk memutar robot ke kiri
#* @post /turn_left
function() {
  list(
    status = "Robot berbelok ke kiri",
    command = "turn_left"
  )
}

# Endpoint untuk memutar robot ke kanan
#* @post /turn_right
function() {
  list(
    status = "Robot berbelok ke kanan",
    command = "turn_right"
  )
}

# Endpoint untuk menghentikan robot
#* @post /stop
function() {
  list(
    status = "Robot berhenti",
    command = "stop"
  )
}

library(plumber)

# Memuat dan menjalankan file API
r <- plumb("robot_api.R")
r$run(port = 8000)

library(httr)

# Fungsi untuk mengirim perintah ke API
send_command <- function(command) {
  url <- paste0("http://127.0.0.1:8000/", command)
  response <- POST(url)
  
  if (status_code(response) == 200) {
    message <- content(response, "parsed")
    print(paste("Perintah:", message$command, "-", message$status))
  } else {
    print("Gagal mengirim perintah ke robot.")
  }
}

# Fungsi untuk menjalankan robot maju
move_forward <- function() {
  send_command("move_forward")
}

# Fungsi untuk menjalankan robot mundur
move_backward <- function() {
  send_command("move_backward")
}

# Fungsi untuk memutar robot ke kiri
turn_left <- function() {
  send_command("turn_left")
}

# Fungsi untuk memutar robot ke kanan
turn_right <- function() {
  send_command("turn_right")
}

# Fungsi untuk menghentikan robot
stop_robot <- function() {
  send_command("stop")
}

# Contoh penggunaan fungsi
move_forward()   # Robot bergerak maju
turn_left()      # Robot berbelok ke kiri
stop_robot()     # Robot berhenti


