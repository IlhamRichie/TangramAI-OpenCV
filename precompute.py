# precompute.py (Versi Perbaikan)

import cv2
import numpy as np
import json
import os

# --- KONFIGURASI ---
LEVELS_FILE_PATH = 'assets/levels.json'
BASE_ASSET_PATH = '' 

def process_all_levels():
    print("🚀 Starting pre-computation script (v2)...")
    
    try:
        with open(LEVELS_FILE_PATH, 'r') as f:
            all_levels = json.load(f)
    except FileNotFoundError:
        print(f"❌ ERROR: File '{LEVELS_FILE_PATH}' tidak ditemukan!")
        return

    for level in all_levels:
        image_path = os.path.join(BASE_ASSET_PATH, level['imagePath'])
        contour_output_path = os.path.join(BASE_ASSET_PATH, level['contourPath'])
        
        print(f"⚙️  Processing: {image_path}")
        
        # --- BAGIAN YANG DIPERBAIKI ---

        # 1. Baca gambar sebagai gambar berwarna biasa.
        img = cv2.imread(image_path, cv2.IMREAD_COLOR)

        if img is None:
            print(f"  [WARNING] Gambar tidak ditemukan di path: {image_path}")
            continue

        # 2. Konversi ke Grayscale.
        # Kita bekerja dengan intensitas warna, bukan warna itu sendiri.
        gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        # 3. Thresholding dengan INVERT.
        # Ini adalah kunci perbaikannya.
        # Objek kita hitam (<127) dan background putih (>127).
        # THRESH_BINARY_INV akan mengubah objek hitam menjadi PUTIH dan background putih menjadi HITAM.
        # findContours bekerja dengan mendeteksi objek PUTIH.
        _ , thresh = cv2.threshold(gray_img, 127, 255, cv2.THRESH_BINARY_INV)
        
        # --- AKHIR BAGIAN YANG DIPERBAIKI ---

        # 4. Cari Kontur
        contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        if not contours:
            print(f"  [WARNING] Tidak ada kontur yang terdeteksi untuk {image_path}")
            continue

        # 5. Ambil Kontur Terbesar
        largest_contour = max(contours, key=cv2.contourArea)

        # 6. Ubah Format Kontur
        points_list = [{'x': int(point[0][0]), 'y': int(point[0][1])} for point in largest_contour]
        output_data = {'points': points_list}

        # 7. Tulis ke File JSON
        output_dir = os.path.dirname(contour_output_path)
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)

        with open(contour_output_path, 'w') as f:
            json.dump(output_data, f, indent=2)
        
        print(f"  ✅ Success! Saved {len(points_list)} points to {contour_output_path}")

    print("\n🎉 Pre-computation finished successfully!")

if __name__ == "__main__":
    process_all_levels()