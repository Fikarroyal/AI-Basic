from flask import Flask, request, jsonify
import random
from faker import Faker
from prettytable import PrettyTable

# Menginstall pustaka yg diperlukan: pip install flask scapy faker requests prettytable

# Membuat aplikasi Flask
app = Flask(__name__)
fake = Faker()

# Fungsi untuk simulasi brute force attack
def brute_force_simulation():
    passwords = ["123456", "password", "admin", "qwerty", "letmein"]
    attempts = random.randint(5, 20)
    guessed = random.choice(passwords)
    return {
        "attack_type": "Brute Force",
        "attempts": attempts,
        "guessed_password": guessed,
    }

# Fungsi untuk simulasi SQL Injection
def sql_injection_simulation():
    payloads = [
        "' OR '1'='1",
        "'; DROP TABLE users;--",
        "' UNION SELECT * FROM users --",
    ]
    chosen_payload = random.choice(payloads)
    return {
        "attack_type": "SQL Injection",
        "payload_used": chosen_payload,
        "success": random.choice([True, False]),
    }

# Fungsi untuk simulasi phishing
def phishing_simulation():
    email = fake.email()
    domain = fake.domain_name()
    return {
        "attack_type": "Phishing",
        "fake_email": f"support@{domain}",
        "victim_email": email,
        "click_rate": f"{random.randint(20, 90)}%",
    }

# Endpoint untuk menjalankan simulasi brute force
@app.route('/simulate/brute_force', methods=['GET'])
def simulate_brute_force():
    result = brute_force_simulation()
    return jsonify(result)

# Endpoint untuk menjalankan simulasi SQL Injection
@app.route('/simulate/sql_injection', methods=['GET'])
def simulate_sql_injection():
    result = sql_injection_simulation()
    return jsonify(result)

# Endpoint untuk menjalankan simulasi phishing
@app.route('/simulate/phishing', methods=['GET'])
def simulate_phishing():
    result = phishing_simulation()
    return jsonify(result)

# Endpoint untuk laporan lengkap semua serangan
@app.route('/simulate/all', methods=['GET'])
def simulate_all():
    results = [
        brute_force_simulation(),
        sql_injection_simulation(),
        phishing_simulation(),
    ]
    table = PrettyTable()
    table.field_names = ["Attack Type", "Details"]

    for result in results:
        attack_type = result["attack_type"]
        details = "\n".join([f"{k}: {v}" for k, v in result.items() if k != "attack_type"])
        table.add_row([attack_type, details])

    return f"<pre>{table}</pre>"

# Menjalankan aplikasi
if __name__ == '__main__':
    app.run(debug=True, port=5000)
