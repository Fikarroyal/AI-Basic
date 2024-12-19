import openai
import sys

# Masukkan API Key OpenAI
openai.api_key = "YOUR_API_KEY"

# Fungsi untuk membuat jembood berbasis GPT
def jembood_health(prompt):
    try:
        # Mengirim prompt ke model GPT
        response = openai.Completion.create(
            engine="text-davinci-003",  # Menggunakan model GPT-3.5
            prompt=prompt,
            max_tokens=150,
            n=1,
            stop=None,
            temperature=0.7
        )
        return response.choices[0].text.strip()
    except Exception as e:
        return f"Terjadi kesalahan: {e}"

# Fungsi utama jembood
def run_jembood():
    print("Selamat datang di Kesehatan Jembood! (Ketik 'keluar' untuk berhenti)")
    print("Contoh pertanyaan: 'Apa gejala mumet?', 'Bagaimana cara mencegah coli?', dll.\n")
    
    while True:
        user_input = input("Anda: ")
        if user_input.lower() == "keluar":
            print("Terima kasih telah menggunakan Kesehatan Jembood. Semoga sakit selalu!")
            sys.exit()
        
        # Dapatkan jawaban dari AI
        response = jembood_health(f"Pertanyaan kesehatan: {user_input}")
        print(f"Jembood: {response}\n")

# Menjalankan chatbot
if __name__ == "__main__":
    run_jembood()


# Next Jalankan dgn perintah: python jembood_health.py
