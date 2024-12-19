import carla
import random
import time
import numpy as np
import cv2
import tensorflow as tf


# CARLA: Platform simulasi sumber terbuka untuk mengembangkan dan menguji sistem kendaraan otonom.
# Udacity Self-Driving Car Simulator: Platform simulasi kendaraan otonom yang dapat digunakan untuk mengembangkan dan menguji AI di lingkungan yang terkontrol.
# ROS (Robot Operating System): Sistem operasi untuk robot yang menyediakan alat dan pustaka untuk mengembangkan kendaraan otonom.
# TensorFlow/PyTorch: Digunakan untuk pelatihan model deep learning, terutama untuk pengenalan objek atau kontrol kendaraan.


# Fungsi untuk memulai simulasi dan menghubungkan ke server CARLA
def connect_to_carla():
    client = carla.Client('localhost', 2000)
    client.set_timeout(10.0)
    world = client.get_world()
    return world

# Fungsi untuk mendapatkan gambar dari kamera dan mengubahnya menjadi array numpy
def process_image(image):
    image_array = np.array(image.raw_data)
    image_array = image_array.reshape((image.height, image.width, 4))
    image_array = image_array[:, :, :3]
    return image_array

# Fungsi untuk memprediksi arah (steering) kendaraan menggunakan model deep learning
def predict_steering(model, image_array):
    image_array = np.expand_dims(image_array, axis=0)  # Menambahkan batch dimension
    steering_angle = model.predict(image_array)
    return steering_angle[0][0]

# Fungsi untuk mengendalikan kendaraan
def control_vehicle(steering_angle, vehicle):
    # Mengarahkan kendaraan ke arah yang diinginkan berdasarkan prediksi model
    control = carla.VehicleControl()
    control.steer = steering_angle
    control.throttle = 0.5  # Menambah kecepatan
    control.brake = 0.0  # Tidak ada pengereman
    vehicle.apply_control(control)

# Menginisialisasi dunia simulasi CARLA dan kendaraan
world = connect_to_carla()
blueprint_library = world.get_blueprint_library()
vehicle_bp = blueprint_library.find('vehicle.tesla.model3')
spawn_point = random.choice(world.get_map().get_spawn_points())
vehicle = world.spawn_actor(vehicle_bp, spawn_point)

# Menyambungkan kamera untuk mendapatkan gambar
camera_bp = blueprint_library.find('sensor.camera.rgb')
camera_transform = carla.Transform(carla.Location(x=1.5, z=2.5))
camera = world.spawn_actor(camera_bp, camera_transform, attach_to=vehicle)
camera.listen(lambda image: process_image(image))  # Mengambil gambar dari kamera

# Menggunakan model deep learning untuk dapat memprediksi 
model = tf.keras.models.load_model('steering_model.h5')

# Menjalankan simulasi kendaraan
try:
    while True:
        image_array = process_image(image)  # Mengambil gambar dari kamera
        steering_angle = predict_steering(model, image_array)  # Memprediksi steering
        control_vehicle(steering_angle, vehicle)  # Menerapkan kontrol pada kendaraan
        time.sleep(0.1)  # Memberi sedikit jeda antara langkah-langkah kontrol
finally:
    vehicle.destroy()  # Menghentikan kendaraan dan menghancurkan objek ketika simulasi berakhir
