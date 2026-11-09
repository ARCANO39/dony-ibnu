# 📱 Panduan Automate Testing Maestro - Pandhawa Notbook Salatiga

Dokumentasi implementasi pengujian otomatis (*Automate Mobile Testing*) menggunakan **Maestro** untuk aplikasi **Pandhawa Notbook Salatiga**.  
Dibuat untuk memenuhi ketentuan **UTS Mata Kuliah Mobile Testing - Universitas Duta Bangsa Surakarta (Dosen: Triyono M.Kom)**.

---

## 📂 Struktur File Maestro Flow

Seluruh skenario pengujian disimpan di folder `maestro/`:

```text
maestro/
├── 01_app_launch.yaml          # Flow 1: Pembukaan aplikasi & assertion dashboard
├── 02_navigation.yaml          # Flow 2: Navigasi antar 5 modul halaman utama
├── 03_crud_transaction.yaml   # Flow 3: Alur transaksi & CRUD registrasi tiket servis
├── 04_validation_error.yaml    # Flow 4: Validasi kesalahan input & negative search testing
├── README.md                   # Panduan instalasi dan eksekusi pengujian
└── screenshots/                # Folder otomatis hasil capture bukti pengujian
```

---

## ⚙️ Persyaratan Sistem & Instalasi Maestro

### 1. Prasyarat
- Perangkat Android fisik terhubung via USB (USB Debugging aktif) ATAU Android Emulator (AVD) menyala.
- Pastikan perangkat terdeteksi dengan perintah:
  ```bash
  adb devices
  ```

### 2. Cara Instalasi Maestro CLI

- **Windows (via PowerShell / Scoop / NPM)**:
  ```powershell
  # Menggunakan NPM (Global):
  npm install -g maestro

  # Atau menggunakan script instalasi resmi:
  powershell -c "irm https://get.maestro.mobile.dev | iex"
  ```

- **macOS / Linux**:
  ```bash
  curl -fsSL "https://get.maestro.mobile.dev" | bash
  ```

- **Verifikasi Instalasi**:
  ```bash
  maestro --version
  ```

---

## 🚀 Perintah Eksekusi Pengujian

Sebelum menjalankan pengujian, pastikan aplikasi telah terpasang di perangkat (`pandhawa_notbook_salatiga.apk` atau jalankan via `flutter run`).

### 1. Menjalankan Seluruh Flow Sekaligus
```bash
# Menjalankan semua flow secara berurutan
maestro test maestro/
```

### 2. Menjalankan Pengujian per Flow (Spesifik)

- **Flow 1: Inisialisasi & Launching Aplikasi**
  ```bash
  maestro test maestro/01_app_launch.yaml
  ```
  *Fokus Uji:* Memverifikasi splash screen, app bar title "Pandhawa Notbook Salatiga", dan ketersediaan seluruh metrik operasional dashboard.

- **Flow 2: Navigasi Antar Halaman**
  ```bash
  maestro test maestro/02_navigation.yaml
  ```
  *Fokus Uji:* Menguji kelancaran perpindahan tab bar (Registrasi ➔ Teknisi ➔ Gudang ➔ Kasir ➔ Tracking ➔ Dashboard).

- **Flow 3: Alur Transaksi / CRUD Tiket Servis**
  ```bash
  maestro test maestro/03_crud_transaction.yaml
  ```
  *Fokus Uji:* Pengisian formulir penerimaan unit laptop baru, checklist fisik, submit form, verifikasi popup QR Code, dan transisi ke antrean teknisi.

- **Flow 4: Validasi Kesalahan & Negative Testing**
  ```bash
  maestro test maestro/04_validation_error.yaml
  ```
  *Fokus Uji:* Menguji reaksi aplikasi terhadap pengiriman form kosong (*validation error*) dan pencarian nomor tiket tidak terdaftar (*ticket not found error*).

---

## 📊 Hasil Pengujian & Bukti Eksekusi (Artifacts)

Setiap flow dilengkapi perintah `takeScreenshot` yang otomatis menyimpan bukti pengujian ke folder `maestro/screenshots/`:
1. `01_dashboard_launched.png`
2. `02_nav_registration.png`, `02_nav_technician.png`, `02_nav_inventory.png`, `02_nav_pos.png`, `02_nav_tracking.png`
3. `03_crud_form_filled.png`, `03_crud_ticket_dialog_success.png`, `03_crud_verified_in_technician_queue.png`
4. `04_validation_empty_form_error.png`, `04_validation_ticket_not_found_error.png`

Pengujian ini dapat direkam menjadi format video MP4 sebagai bahan lampiran video penjelasan UTS.

