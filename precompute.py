# precompute.py

import cv2
import numpy as np
import json
import os

# --- KONFIGURASI ---
# Pastikan path ini sesuai dengan struktur folder Anda.
# Skrip ini mengasumsikan ia dijalankan dari folder root proyek.
LEVELS_FILE_PATH = 'assets/levels.json'
BASE_ASSET_PATH = '' # Sesuaikan jika Anda menaruh folder assets di dalam folder lain, misal 'lib/'

def process_all_levels():
    """
    Fungsi utama untuk membaca levels.json dan memproses setiap level.
    """
    print("🚀 Starting pre-computation script...")

    # 1. BACA FILE levels.json
    try:
        with open(LEVELS_FILE_PATH, 'r') as f:
            all_levels = json.load(f)
    except FileNotFoundError:
        print(f"❌ ERROR: File '{LEVELS_FILE_PATH}' tidak ditemukan! Pastikan Anda menjalankan skrip dari folder yang benar.")
        return

    # 2. LOOPING SETIAP LEVEL
    for level in all_levels:
        image_path = os.path.join(BASE_ASSET_PATH, level['imagePath'])
        contour_output_path = os.path.join(BASE_ASSET_PATH, level['contourPath'])

        print(f"⚙️  Processing: {image_path}")

        # 3. BACA GAMBAR PNG
        # Menggunakan IMREAD_UNCHANGED agar bisa membaca alpha channel (transparansi)
        img = cv2.imread(image_path, cv2.IMREAD_UNCHANGED)

        if img is None:
            print(f"  [WARNING] Gambar tidak ditemukan di path: {image_path}")
            continue

        # 4. PROSES GAMBAR UNTUK MENDAPATKAN MASK HITAM-PUTIH
        # Jika gambar punya 4 channel (RGBA), kita gunakan alpha channel sebagai sumber.
        if img.shape[2] == 4:
            # Alpha channel (channel ke-4) sudah menjadi representasi bentuk
            mask = img[:, :, 3]
        else:
            # Jika hanya 3 channel (RGB), konversi ke grayscale
            gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            # Karena objek kita hitam (0) dan background putih (255), kita Invert
            mask = cv2.bitwise_not(gray_img)

        # 5. THRESHOLDING UNTUK MEMASTIKAN HANYA HITAM & PUTIH
        _ , thresh = cv2.threshold(mask, 1, 255, cv2.THRESH_BINARY)

        # 6. CARI KONTUR
        contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        if not contours:
            print(f"  [WARNING] Tidak ada kontur yang terdeteksi untuk {image_path}")
            continue

        # 7. AMBIL KONTUR TERBESAR
        largest_contour = max(contours, key=cv2.contourArea)

        # 8. UBAH FORMAT KONTUR UNTUK DISIMPAN KE JSON
        # OpenCV menyimpan kontur dalam format numpy array, kita ubah ke list of dictionaries
        points_list = [{'x': int(point[0][0]), 'y': int(point[0][1])} for point in largest_contour]

        output_data = {'points': points_list}

        # 9. TULIS KE FILE JSON
        # Pastikan direktori untuk menyimpan file JSON ada
        output_dir = os.path.dirname(contour_output_path)
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)

        with open(contour_output_path, 'w') as f:
            json.dump(output_data, f, indent=2)

        print(f"  ✅ Success! Saved {len(points_list)} points to {contour_output_path}")

    print("\n🎉 Pre-computation finished successfully!")

# Ini adalah titik awal eksekusi skrip
if __name__ == "__main__":
    process_all_levels()