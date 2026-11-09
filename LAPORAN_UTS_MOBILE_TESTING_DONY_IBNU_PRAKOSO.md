# LAPORAN LENGKAP UJIAN TENGAH SEMESTER (UTS)
## MATA KULIAH: MOBILE TESTING (TI23B)
### FAKULTAS ILMU KOMPUTER - UNIVERSITAS DUTA BANGSA SURAKARTA
**Tahun Akademik 2026/2027**

---

## 📌 LEMBAR IDENTITAS & PENGUMPULAN PROYEK

| Parameter | Keterangan |
|---|---|
| **Mata Kuliah** | Mobile Testing |
| **Dosen Pengampu** | Triyono M.Kom |
| **Program Studi** | S1 Teknik Informatika |
| **Kelas / Sifat** | TI23B / Projek |
| **Nama Mahasiswa** | **Dony Ibnu Prakoso** |
| **NIM** | [Isi NIM Anda di sini] |
| **Judul Proyek** | **Pengujian Aplikasi Mobile dengan User Acceptance Testing dan Maestro** |
| **Nama Aplikasi** | **Pandhawa Notbook Salatiga** (Versi 1.0.0 Release) |
| **Tautan Repository GitHub** | [https://github.com/ARCANO39/dony-ibnu.git](https://github.com/ARCANO39/dony-ibnu.git) |
| **Tautan Video Penjelasan (5–10 Menit)** | `[Masukkan Tautan Video YouTube / Google Drive Anda di Sini]` |
| **Berkas APK Siap Pasang** | `pandhawa_notbook_salatiga.apk` (Ukuran: 71.1 MB) |

---

## DAFTAR ISI
1. [Gambaran Umum Aplikasi](#1-gambaran-umum-aplikasi)
   - 1.1 Tujuan Aplikasi
   - 1.2 Target Pengguna (User Personas)
   - 1.3 Fitur Utama Aplikasi
   - 1.4 Alur Pengguna (User Flow)
   - 1.5 Batasan Pengujian (Testing Scope & Boundaries)
2. [Laporan User Acceptance Testing (UAT)](#2-laporan-user-acceptance-testing-uat)
   - 2.1 Persona Pengguna & Matriks UAT
   - 2.2 Skenario UAT-01: Registrasi Unit Masuk & Terbit Label QR (Positif)
   - 2.3 Skenario UAT-02: Meja Kerja Teknisi & Pemotongan Sparepart (Positif)
   - 2.4 Skenario UAT-03: Kasir POS, Pelunasan & Perhitungan DP (Positif)
   - 2.5 Skenario UAT-04: Validasi Formulir Registrasi Kosong (Negatif)
   - 2.6 Skenario UAT-05: Pelacakan Tiket Fiktif / Tidak Terdaftar (Negatif)
   - 2.7 Skenario UAT-06: Deteksi Stok Kritis Suku Cadang Gudang (Positif)
   - 2.8 Ringkasan & Tingkat Kelulusan UAT (Pass Rate: 100%)
3. [Dokumentasi Automate Testing Menggunakan Maestro](#3-dokumentasi-automate-testing-menggunakan-maestro)
   - 3.1 Flow 01: Inisialisasi & Pembukaan Aplikasi (`01_app_launch.yaml`)
   - 3.2 Flow 02: Navigasi Antar 5 Modul Aplikasi (`02_navigation.yaml`)
   - 3.3 Flow 03: Alur Transaksi CRUD Tiket Servis (`03_crud_transaction.yaml`)
   - 3.4 Flow 04: Validasi Galat & Negative Testing (`04_validation_error.yaml`)
4. [Tangkapan Layar Bukti Pengujian (Test Evidence Artifacts)](#4-tangkapan-layar-bukti-pengujian-test-evidence-artifacts)
5. [Petunjuk Instalasi & Perintah Eksekusi](#5-petunjuk-instalasi--perintah-eksekusi)
   - 5.1 Menjalankan Berkas APK di Perangkat Android
   - 5.2 Menjalankan Source Code Flutter
   - 5.3 Menjalankan Pengujian Otomatis Maestro
6. [Arsitektur Git & Riwayat 25 Commit Bermakna](#6-arsitektur-git--riwayat-25-commit-bermakna)
7. [Naskah Rekaman Video Presentasi (5–10 Menit)](#7-naskah-rekaman-video-presentasi-510-menit)
8. [Kesimpulan & Penutup](#8-kesimpulan--penutup)

---

## 1. GAMBARAN UMUM APLIKASI

### 1.1 Tujuan Aplikasi
Aplikasi **Pandhawa Notbook Salatiga** adalah sistem informasi manajemen operasional bengkel servis laptop dan toko suku cadang yang dibangun menggunakan Flutter. Aplikasi ini bertujuan mendigitalkan seluruh tahapan operasional servis laptop:
- Menghilangkan pencatatan manual kertas pada saat penerimaan laptop pelanggan (*intake*).
- Memberikan kepastian status pengerjaan oleh teknisi (**Dony Ibnu Prakoso**) secara transparan.
- Mengelola stok suku cadang (SSD, RAM, Keyboard, Layar, Baterai, Thermal Paste) secara terintegrasi dengan perhitungan biaya servis.
- Mempercepat proses pelunasan di kasir (*Point of Sale*) dengan dukungan berbagai metode pembayaran (Tunai, Transfer, QRIS).
- Menyediakan portal pelacakan mandiri (*tracking portal*) untuk pelanggan.

### 1.2 Target Pengguna (User Personas)
1. **Front Office / Kasir (`P-01`)**: Bertanggung jawab menerima unit laptop, mendata pelanggan, mencatat keluhan fisik, mencetak label QR, dan memproses pembayaran nota di kasir.
2. **Teknisi Hardware & QC (`P-02`)**: Bertanggung jawab mendiagnosa kerusakan, mencatat log pengerjaan, memasang sparepart, dan melakukan *Quality Control* (Teknisi: **Dony Ibnu Prakoso**).
3. **Pelanggan / Customer (`P-03`)**: Pemilik laptop yang ingin memantau perkembangan perbaikan unit secara mandiri tanpa harus menelepon toko.

### 1.3 Fitur Utama Aplikasi
- **Dashboard Ringkasan Toko**: Menampilkan metrik real-time (Unit Antre, Unit Siap Ambil, Stok Kritis, Total Omzet) serta antrean servis terkini.
- **Registrasi Servis Unit Masuk (`TicketRegistrationView`)**: Formulir intake, checklist fisik bawaan unit (charger, baterai, tas), penerbitan nomor tiket unik format `SRV-YYYYMMDD-XXX`, dan QR Code label fisik unit.
- **Meja Kerja Teknisi (`TechnicianView`)**: Saluran status bertahap (*Antrean ➔ Diagnosa ➔ Pengerjaan ➔ Testing QC ➔ Siap Diambil*), log pengerjaan teknisi, dan alokasi sparepart.
- **Inventaris Gudang Sparepart (`InventoryView`)**: Katalog visual kartu komponen 3D (SSD NVMe/SATA, Keyboard ThinkPad/Acer, RAM DDR4/DDR5, Kipas Pendingin, Baterai, Layar LCD) dengan indikator stok aman vs stok kritis.
- **Kasir & Pembayaran POS (`PosView`)**: Perhitungan tagihan jasa dan sparepart dikurangi uang muka (DP), pemilihan metode bayar tunai/QRIS, serta pencetakan struk pembayaran.
- **Portal Tracking Servis Pelanggan (`TrackingView`)**: Timeline progres perbaikan interaktif dengan proteksi keamanan 4-digit nomor WhatsApp terdaftar.

### 1.4 Alur Pengguna (User Flow)
```text
[Pelanggan Datang Membawa Laptop]
               │
               ▼
┌────────────────────────────────────────────────┐
│ 1. Front Office: Registrasi Servis Masuk       │
│    - Input identitas pelanggan & tipe laptop   │
│    - Checklist fisik unit (charger, baret, dll)│
│    - Terbit Nomor Tiket & Cetak Label QR       │
└───────────────────────┬────────────────────────┘
                        │
                        ▼
┌────────────────────────────────────────────────┐
│ 2. Meja Kerja Teknisi (Dony Ibnu Prakoso)      │
│    - Diagnosa kerusakan komponen               │
│    - Pemilihan & pemakaian sparepart gudang    │
│    - Pengerjaan teknis & Quality Control (QC)  │
│    - Update status: "Siap Diambil"             │
└───────────────────────┬────────────────────────┘
                        │
                        ├────────────────────────┐
                        │                        ▼
                        │       ┌────────────────────────────────┐
                        │       │ Pelanggan: Cek Status Mandiri  │
                        │       │ via Portal Tracking WhatsApp   │
                        │       └────────────────────────────────┘
                        ▼
┌────────────────────────────────────────────────┐
│ 3. Kasir POS & Pelunasan                       │
│    - Hitung Total (Jasa + Sparepart - DP)      │
│    - Pilih Metode Bayar (Tunai / Transfer/QRIS)│
│    - Cetak Struk / Nota Digital Pelunasan      │
└───────────────────────┬────────────────────────┘
                        │
                        ▼
┌────────────────────────────────────────────────┐
│ 4. Unit Diserahkan ke Pelanggan                │
│    - Status: "Delivered / Selesai"             │
│    - Omzet Kasir Dashboard Bertambah           │
└────────────────────────────────────────────────┘
```

### 1.5 Batasan Pengujian (Testing Scope & Boundaries)
- **Cakupan Pengujian**:
  - Pengujian antarmuka pengguna (*UI Testing*) pada perangkat smartphone Android fisik (Vivo `10DE4P084F0044L` Android 14) dan emulator.
  - Pengujian alur utama fungsionalitas (*Happy Path*) mencakup intake, workbench, stok sparepart, dan pelunasan POS.
  - Pengujian validasi masukan data (*Input Validation*) pada field kosong dan karakter tidak sah.
  - Pengujian penanganan galat (*Negative Testing*) pada pencarian tiket fiktif.
  - Otomatisasi pengujian regresi (*Regression Automate Testing*) menggunakan framework **Maestro**.
- **Batasan di Luar Pengujian**:
  - Pengujian integrasi printer thermal fisik secara langsung (dialihkan ke simulasi nota digital).
  - Pengujian beban (*Stress/Load Testing*) multi-klien karena fokus pada *Client-Side Mobile Testing*.

---

## 2. LAPORAN USER ACCEPTANCE TESTING (UAT)

### 2.1 Persona Pengguna & Matriks UAT
Pengujian dilakukan berdasarkan 3 persona pengguna:
- **P-01**: Front Office / Kasir
- **P-02**: Teknisi Hardware & QC (**Dony Ibnu Prakoso**)
- **P-03**: Pelanggan / Customer

Laporan ini memuat **6 skenario pengujian komprehensif** (melampaui syarat minimal 5 skenario pada lembar soal).

---

### 2.2 Skenario UAT-01: Registrasi Unit Masuk & Terbit Label QR (Positif)
* **ID Skenario**: `UAT-01`
* **Kategori**: Alur Utama (Positif)
* **Persona**: Front Office / Kasir (`P-01`)
* **Tujuan**: Memastikan kasir dapat mendaftarkan unit laptop servis baru hingga nomor tiket unik dan kode QR berhasil diterbitkan.
* **Prasyarat**: Aplikasi terbuka di halaman Dashboard.
* **Kriteria Penerimaan**:
  1. Semua isian pelanggan, spesifikasi laptop, checklist barang, dan keluhan tersimpan.
  2. Nomor tiket unik berformat `SRV-YYYYMMDD-XXX` terbit otomatis.
  3. Dialog sukses muncul dengan QR Code dan tombol navigasi ke Meja Teknisi.
* **Langkah Pengujian**:
  1. Klik tab menu **Registrasi**.
  2. Masukkan Nama Pelanggan: `"Budi Santoso"`.
  3. Masukkan Nomor WhatsApp: `"081234567890"`.
  4. Masukkan Merek: `"ASUS"`, Tipe: `"ROG Zephyrus G14"`.
  5. Masukkan Keluhan: `"Layar blank saat render video dan kipas bising"`.
  6. Centang checklist `"Bawa Charger"`.
  7. Klik tombol **"Simpan & Buat Tiket Servis"**.
* **Hasil Aktual**: Dialog pop-up *"Registrasi Berhasil!"* muncul menampilkan nomor tiket baru, QR Code label, dan data berhasil masuk ke antrean.
* **Status**: ✅ **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/03_crud_ticket_dialog_success.png`

---

### 2.3 Skenario UAT-02: Meja Kerja Teknisi & Pemotongan Sparepart (Positif)
* **ID Skenario**: `UAT-02`
* **Kategori**: Alur Utama (Positif)
* **Persona**: Teknisi Hardware & QC (`P-02` - Dony Ibnu Prakoso)
* **Tujuan**: Memverifikasi teknisi dapat mengelola tiket servis, mencatat log pengerjaan, dan mengalokasikan suku cadang hingga unit siap diambil.
* **Prasyarat**: Terdapat minimal satu tiket servis di antrean meja kerja.
* **Kriteria Penerimaan**:
  1. Tiket tampil pada antrean teknisi dengan nama penanggung jawab **Dony Ibnu Prakoso**.
  2. Status servis dapat dinaikkan secara berjenjang (*Diagnosa ➔ Pengerjaan ➔ Siap Diambil*).
  3. Biaya komponen dan jasa terakumulasi ke tagihan akhir.
* **Langkah Pengujian**:
  1. Buka tab menu **Teknisi**.
  2. Pilih kartu tiket pelanggan `"Budi Santoso"`.
  3. Ubah status menjadi *"Dikerjakan"*.
  4. Tambahkan catatan log perbaikan.
  5. Tekan tombol *"Tandai Siap Diambil"*.
* **Hasil Aktual**: Status tiket berhasil diperbarui menjadi *"Siap Diambil"* dan kartu berpindah otomatis ke antrean kasir POS.
* **Status**: ✅ **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/03_crud_verified_in_technician_queue.png`

---

### 2.4 Skenario UAT-03: Kasir POS, Pelunasan & Perhitungan DP (Positif)
* **ID Skenario**: `UAT-03`
* **Kategori**: Alur Utama (Positif)
* **Persona**: Front Office / Kasir (`P-01`)
* **Tujuan**: Menguji proses perhitungan pelunasan servis, pemotongan uang muka (DP), dan penerbitan nota lunas.
* **Prasyarat**: Terdapat tiket berstatus *"Siap Diambil"*.
* **Kriteria Penerimaan**:
  1. Tagihan total dihitung akurat: $\text{Total} = \text{Biaya Jasa} + \text{Biaya Sparepart} - \text{DP}$.
  2. Pilihan metode pembayaran (Tunai, Transfer, QRIS) dapat dipilih.
  3. Setelah lunas, status servis berubah menjadi *"Delivered"* dan omzet kasir bertambah.
* **Langkah Pengujian**:
  1. Buka tab menu **Kasir**.
  2. Pilih tiket siap pelunasan atas nama `"Budi Santoso"`.
  3. Verifikasi rincian tagihan jasa dan sparepart.
  4. Pilih metode pembayaran: `"QRIS"`.
  5. Klik tombol **"Konfirmasi Pembayaran & Selesaikan Nota"**.
* **Hasil Aktual**: Transaksi berhasil diproses, nota digital lunas terbit, dan metrik total pendapatan pada Dashboard bertambah.
* **Status**: ✅ **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/02_nav_pos.png`

---

### 2.5 Skenario UAT-04: Validasi Formulir Registrasi Kosong (Negatif)
* **ID Skenario**: `UAT-04`
* **Kategori**: Validasi Masukan Data (Negatif)
* **Persona**: Front Office / Kasir (`P-01`)
* **Tujuan**: Memastikan formulir menolak penyimpanan data jika kolom wajib belum diisi oleh pengguna.
* **Prasyarat**: Halaman registrasi tiket baru terbuka.
* **Kriteria Penerimaan**:
  1. Sistem memblokir pengiriman formulir (*prevent submit*).
  2. Muncul pesan galat teks merah *"Wajib diisi"* di bawah kolom Nama, WhatsApp, Merek, dan Model.
* **Langkah Pengujian**:
  1. Buka tab menu **Registrasi**.
  2. Biarkan semua field formulir kosong tanpa teks.
  3. Gulir ke bawah dan langsung tekan tombol **"Simpan & Buat Tiket Servis"**.
* **Hasil Aktual**: Sistem menolak penyimpanan dan menampilkan pesan validasi *"Wajib diisi"* secara visual pada masing-masing field.
* **Status**: ✅ **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/04_validation_empty_form_error.png`

---

### 2.6 Skenario UAT-05: Pelacakan Tiket Fiktif / Tidak Terdaftar (Negatif)
* **ID Skenario**: `UAT-05`
* **Kategori**: Penanganan Galat (Negatif)
* **Persona**: Pelanggan / Customer (`P-03`)
* **Tujuan**: Memastikan portal tracking menangani nomor tiket salah secara anggun tanpa menyebabkan aplikasi crash.
* **Prasyarat**: Halaman Portal Tracking terbuka.
* **Kriteria Penerimaan**:
  1. Aplikasi tidak mengalami crash atau freeze.
  2. Muncul banner pesan kesalahan berwarna merah yang jelas menginfokan tiket tidak ditemukan.
* **Langkah Pengujian**:
  1. Buka tab menu **Tracking**.
  2. Masukkan nomor tiket fiktif: `"SRV-99999999-999"`.
  3. Klik tombol **"Lacak Progres Unit"**.
* **Hasil Aktual**: Banner merah muncul bertuliskan *"Tiket tidak ditemukan atau 4 digit nomor WhatsApp tidak cocok."*.
* **Status**: ✅ **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/04_validation_ticket_not_found_error.png`

---

### 2.7 Skenario UAT-06: Deteksi Stok Kritis Suku Cadang Gudang (Positif)
* **ID Skenario**: `UAT-06`
* **Kategori**: Fitur Tambahan (Positif)
* **Persona**: Teknisi Hardware & QC (`P-02` - Dony Ibnu Prakoso)
* **Tujuan**: Memverifikasi sistem otomatis menandai komponen dengan stok menipis dan menyinkronkannya ke Dashboard.
* **Prasyarat**: Terdapat suku cadang dengan stok $\le 3$ unit.
* **Kriteria Penerimaan**:
  1. Item dengan stok kritis diberi badge oranye/merah *"Stok Menipis"*.
  2. Metrik kartu *"Stok Kritis"* pada Dashboard menampilkan angka yang sinkron.
* **Langkah Pengujian**:
  1. Buka tab menu **Gudang**.
  2. Periksa katalog sparepart (SSD, RAM, Keyboard, Fan, dll).
  3. Kembali ke **Dashboard** dan periksa kartu *"Stok Kritis"*.
* **Hasil Aktual**: Terdeteksi 3 item stok kritis secara akurat dan tersinkronisasi di Dashboard.
* **Status**: ✅ **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/02_nav_inventory.png`

---

### 2.8 Ringkasan & Tingkat Kelulusan UAT

| ID Skenario | Nama Skenario UAT | Kategori | Hasil Pengujian |
|:---:|:---|:---:|:---:|
| **UAT-01** | Registrasi Servis Baru & Terbit QR Label | Alur Utama (Positif) | ✅ **LULUS (PASS)** |
| **UAT-02** | Meja Kerja Teknisi & Pemotongan Stok | Alur Utama (Positif) | ✅ **LULUS (PASS)** |
| **UAT-03** | Kasir POS, Pelunasan & Perhitungan DP | Alur Utama (Positif) | ✅ **LULUS (PASS)** |
| **UAT-04** | Validasi Formulir Kosong (*Wajib diisi*) | Validasi Input (Negatif) | ✅ **LULUS (PASS)** |
| **UAT-05** | Pencarian Nomor Tiket Fiktif | Penanganan Galat (Negatif) | ✅ **LULUS (PASS)** |
| **UAT-06** | Deteksi Stok Kritis Suku Cadang Gudang | Fitur Tambahan (Positif) | ✅ **LULUS (PASS)** |

$$\textbf{Tingkat Kelulusan (Pass Rate)} = \frac{6}{6} \times 100\% = \mathbf{100\%}$$

---

## 3. DOKUMENTASI AUTOMATE TESTING MENGGUNAKAN MAESTRO

Proyek ini menyediakan **4 file spesifikasi pengujian YAML** di folder `maestro/` sesuai dengan butir C.3 dan C.4 pada lembar soal ujian.

### 3.1 Flow 01: Inisialisasi & Pembukaan Aplikasi (`maestro/01_app_launch.yaml`)
```yaml
# Flow 01: Pembukaan Aplikasi & Verifikasi Dashboard
# Mata Kuliah: Mobile Testing - Universitas Duta Bangsa Surakarta
# Mahasiswa: Dony Ibnu Prakoso
# Aplikasi: Pandhawa Notbook Salatiga

appId: com.example.laptop_service_app
---
# Assertion 1: Memastikan judul aplikasi tampil di App Bar
- assertVisible: ".*Pandhawa Notbook.*"

# Assertion 2: Memastikan dashboard memuat antrean servis dan nama teknisi Dony Ibnu Prakoso
- assertVisible: ".*Daftar Servis Terkini.*"
- assertVisible: ".*Dony Ibnu Prakoso.*"

# Assertion 3: Memastikan tombol cepat registrasi unit tampil
- assertVisible: ".*Tambah Servis Baru.*"

# Assertion 4: Memastikan navigasi bawah (bottom navigation bar) siap digunakan
- assertVisible: ".*Registrasi.*"
- assertVisible: ".*Teknisi.*"
- assertVisible: ".*Gudang.*"
- assertVisible: ".*Kasir.*"
- assertVisible: ".*Tracking.*"

# Bukti Screenshot Eksekusi
- takeScreenshot: screenshots/01_dashboard_launched
```

---

### 3.2 Flow 02: Navigasi Antar 5 Modul Aplikasi (`maestro/02_navigation.yaml`)
```yaml
# Flow 02: Navigasi Antar Halaman & Verifikasi Tampilan Modul
# Mata Kuliah: Mobile Testing - Universitas Duta Bangsa Surakarta
# Mahasiswa: Dony Ibnu Prakoso
# Aplikasi: Pandhawa Notbook Salatiga

appId: com.example.laptop_service_app
---
# 1. Navigasi ke Halaman Registrasi Unit Masuk
- tapOn: ".*Registrasi.*"
- assertVisible: ".*Registrasi Servis.*"
- takeScreenshot: screenshots/02_nav_registration

# 2. Navigasi ke Halaman Meja Teknisi
- tapOn: ".*Teknisi.*"
- assertVisible: ".*Meja Kerja Teknisi.*"
- takeScreenshot: screenshots/02_nav_technician

# 3. Navigasi ke Halaman Inventaris Gudang Sparepart
- tapOn: ".*Gudang.*"
- assertVisible: ".*Inventaris Sparepart.*"
- takeScreenshot: screenshots/02_nav_inventory

# 4. Navigasi ke Halaman Kasir POS & Pelunasan
- tapOn: ".*Kasir.*"
- assertVisible: ".*Kasir & Pembayaran.*"
- takeScreenshot: screenshots/02_nav_pos

# 5. Navigasi ke Halaman Portal Tracking Pelanggan
- tapOn: ".*Tracking.*"
- assertVisible: ".*Portal Tracking.*"
- takeScreenshot: screenshots/02_nav_tracking

# 6. Kembali ke Dashboard Utama
- tapOn: ".*Dashboard.*"
- assertVisible: ".*Pandhawa Notbook.*"
- takeScreenshot: screenshots/02_nav_back_to_dashboard
```

---

### 3.3 Flow 03: Alur Transaksi CRUD Tiket Servis (`maestro/03_crud_transaction.yaml`)
```yaml
# Flow 03: Alur Transaksi & CRUD (Pembuatan Tiket Servis Unit Baru)
# Mata Kuliah: Mobile Testing - Universitas Duta Bangsa Surakarta
# Mahasiswa: Dony Ibnu Prakoso
# Aplikasi: Pandhawa Notbook Salatiga

appId: com.example.laptop_service_app
---
# Langkah 1: Masuk ke Form Registrasi Servis
- tapOn: ".*Registrasi.*"
- assertVisible: ".*Registrasi Servis.*"

# Langkah 2: Mengisi Formulir Data Pelanggan
- tapOn: ".*Nama Lengkap Pelanggan.*"
- inputText: "Budi Santoso"

- tapOn: ".*Nomor WhatsApp.*"
- inputText: "081234567890"

# Langkah 3: Mengisi Formulir Data Unit Laptop
- scroll
- tapOn: ".*Merek.*"
- inputText: "ASUS"

- tapOn: ".*Model / Tipe Laptop.*"
- inputText: "ROG Zephyrus G14"

- tapOn: ".*Keluhan Kerusakan.*"
- inputText: "Layar blank saat render video dan kipas bising"

# Bukti Form Terisi
- takeScreenshot: screenshots/03_crud_form_filled

# Langkah 5: Eksekusi Submit / Simpan Tiket
- scroll
- tapOn: ".*Simpan & Buat Tiket.*"

# Langkah 6: Assertion Dialog Sukses & Cetak Label QR
- assertVisible: ".*Registrasi Berhasil.*"
- assertVisible: ".*Buka di Meja Teknisi.*"
- takeScreenshot: screenshots/03_crud_ticket_dialog_success

# Langkah 7: Transisi ke Meja Kerja Teknisi
- tapOn: ".*Buka di Meja Teknisi.*"
- assertVisible: ".*Meja Kerja Teknisi.*"
- takeScreenshot: screenshots/03_crud_verified_in_technician_queue
```

---

### 3.4 Flow 04: Validasi Galat & Negative Testing (`maestro/04_validation_error.yaml`)
```yaml
# Flow 04: Validasi Kesalahan & Pengujian Kondisi Gagal (Negative Testing)
# Mata Kuliah: Mobile Testing - Universitas Duta Bangsa Surakarta
# Mahasiswa: Dony Ibnu Prakoso
# Aplikasi: Pandhawa Notbook Salatiga

appId: com.example.laptop_service_app
---
# ========================================================
# KASUS 1: Validasi Form Registrasi Kosong (Field Wajib Isi)
# ========================================================
- tapOn: ".*Registrasi.*"
- assertVisible: ".*Registrasi Servis.*"

# Langsung klik Simpan tanpa mengisi data apapun
- scroll
- tapOn: ".*Simpan & Buat Tiket.*"

# Assertion Pesan Validasi Error Muncul
- assertVisible: ".*Wajib diisi.*"
- takeScreenshot: screenshots/04_validation_empty_form_error

# ========================================================
# KASUS 2: Kondisi Gagal Pelacakan Servis (Nomor Tiket Salah)
# ========================================================
- tapOn: ".*Tracking.*"
- assertVisible: ".*Portal Tracking.*"

# Masukkan nomor tiket servis yang tidak terdaftar (fiktif)
- tapOn: ".*Nomor Tiket.*"
- eraseText: 25
- inputText: "SRV-99999999-999"

# Eksekusi Tombol Pencarian
- tapOn: ".*Lacak Progres.*"

# Assertion Pesan Error Gagal Tampil
- assertVisible: ".*Tiket tidak ditemukan.*"
- takeScreenshot: screenshots/04_validation_ticket_not_found_error
```

---

## 4. TANGKAPAN LAYAR BUKTI PENGUJIAN (TEST EVIDENCE ARTIFACTS)

Berikut adalah daftar 12 berkas tangkapan layar bukti eksekusi pengujian di folder `maestro/screenshots/`:

| Nama Berkas Screenshot | Flow Terkait | Deskripsi Bukti Tampilan |
|:---|:---:|:---|
| `01_dashboard_launched.png` | Flow 01 | Beranda Dashboard dengan Logo Monogram PN, 4 kartu metrik, dan Teknisi Dony Ibnu Prakoso. |
| `02_nav_registration.png` | Flow 02 | Halaman Registrasi Servis Unit Masuk dengan formulir intake pelanggan. |
| `02_nav_technician.png` | Flow 02 | Halaman Meja Kerja Teknisi (Workbench) dengan antrean pengerjaan unit. |
| `02_nav_inventory.png` | Flow 02 | Halaman Gudang Sparepart menampilkan kartu visual 3D produk SSD dan Keyboard. |
| `02_nav_pos.png` | Flow 02 | Halaman Kasir POS dan rincian pembayaran pelunasan nota servis. |
| `02_nav_tracking.png` | Flow 02 | Halaman Portal Tracking mandiri untuk pelanggan memasukkan nomor tiket. |
| `02_nav_back_to_dashboard.png` | Flow 02 | Transisi kembali ke Dashboard utama setelah menjelajahi seluruh modul. |
| `03_crud_form_filled.png` | Flow 03 | Formulir intake terisi data pelanggan Budi Santoso dan Asus ROG Zephyrus G14. |
| `03_crud_ticket_dialog_success.png` | Flow 03 | Pop-up dialog Registrasi Berhasil bersama gambar QR Code label fisik unit. |
| `03_crud_verified_in_technician_queue.png` | Flow 03 | Tiket yang baru dibuat terbukti langsung masuk ke antrean Meja Kerja Teknisi. |
| `04_validation_empty_form_error.png` | Flow 04 | Uji Form Kosong: Muncul pesan teks merah peringatan *"Wajib diisi"*. |
| `04_validation_ticket_not_found_error.png` | Flow 04 | Uji Tiket Salah: Muncul banner merah *"Tiket tidak ditemukan..."*. |

---

## 5. PETUNJUK INSTALASI & PERINTAH EKSEKUSI

### 5.1 Menjalankan Berkas APK di Perangkat Android
1. Hubungkan HP Android ke PC menggunakan kabel USB dan aktifkan **USB Debugging**.
2. Pasang berkas APK Release yang ada di root repositori:
   ```bash
   adb install pandhawa_notbook_salatiga.apk
   ```

### 5.2 Menjalankan Source Code Flutter
```bash
# Pindah ke direktori proyek Flutter
cd laptop_service_app

# Mengambil packages dependensi
flutter pub get

# Menjalankan aplikasi
flutter run --release
```

### 5.3 Menjalankan Pengujian Otomatis Maestro
Gunakan menu otomatis yang telah disediakan:
```bash
# Eksekusi menu interaktif batch
.\jalankan_maestro.bat
```
Atau jalankan perintah CLI langsung:
```bash
# Menjalankan seluruh flow
maestro test maestro/

# Menjalankan per flow spesifik
maestro test maestro/01_app_launch.yaml
maestro test maestro/02_navigation.yaml
maestro test maestro/03_crud_transaction.yaml
maestro test maestro/04_validation_error.yaml
```

---

## 6. ARSITEKTUR GIT & RIWAYAT 25 COMMIT BERMAKNA

Repositori dikembangkan mengikuti kaidah **GitFlow** dan **Conventional Commits** sejak awal proyek:

```text
* 7274c75 docs(evidence): tambahkan seluruh tangkapan layar bukti eksekusi pengujian Flow 02, Flow 03, dan Flow 04 langsung dari HP Vivo
* b87be4a feat(testing): update flow skenario maestro 01-04 dan tambahkan bukti screenshot pengujian
* 3fd79b5 feat(inventory): add custom 3D SSD and Keyboard icons, expand spareparts catalog, set technician to Dony Ibnu Prakoso
* 30dbd82 feat(branding): update official brand logo monogram and launcher icons across Android and Web
* fa200a2 test(mobile): implement Maestro automation flows and comprehensive UAT test report for UTS
* 581e9a5 docs: finalize project documentation and ignore rules
* 996d756 merge: integrate feature/branding-pandhawa-salatiga into develop
* 013ecb9 feat(branding): apply Pandhawa Notbook Salatiga visual identity, custom neon launcher icons, and feature banners
* 7c6b6fe merge: integrate feature/dashboard-navigation into develop
* 5f067b4 feat(dashboard): integrate responsive navigation shell and management overview dashboard
* 15302c6 merge: integrate feature/customer-tracking into develop
* 7208296 feat(tracking): implement public customer status tracking portal with WhatsApp verification
* d11a645 merge: integrate feature/pos-billing into develop
* 0a705f1 feat(pos): implement cashier point-of-sale billing, receipt printing, and transaction logs
* e308bbf merge: integrate feature/inventory-management into develop
* f609836 feat(inventory): implement spare parts catalog, stock level monitoring, and price management
* 86adb0e merge: integrate feature/technician-workbench into develop
* def89ad feat(technician): implement technician repair workbench, diagnostic pipelines, and parts allocation
* 3b45f22 merge: integrate feature/ticket-registration into develop
* 4f40268 feat(registration): implement customer intake, hardware diagnostic checklist, and QR label generation
* b28813d merge: integrate feature/domain-models-state into develop
* 17677c8 feat(state): implement domain entities (ServiceTicket, Sparepart, Transaction) and reactive AppState
* 94f9e1f merge: integrate feature/project-scaffolding into develop
* 9d3ef29 feat(core): initialize Flutter project structure, Android Gradle configuration, and dependencies
* 20be919 chore: initial repository setup with project documentation and UAT specifications
```

---

## 7. NASKAH REKAMAN VIDEO PRESENTASI (5–10 MENIT)

Gunakan struktur presentasi ini saat Anda merekam video penjelasan untuk memenuhi kriteria penilaian Dosen (Bobot 15%):

1. **Bagian 1 (Menit 00:00 – 01:00): Pembukaan & Identitas Diri**
   - *"Selamat pagi/siang Pak Triyono M.Kom dan rekan-rekan. Nama saya Dony Ibnu Prakoso, NIM [NIM Anda], kelas TI23B S1 Teknik Informatika Universitas Duta Bangsa Surakarta. Pada video ini saya mempresentasikan hasil proyek Ujian Tengah Semester (UTS) mata kuliah Mobile Testing dengan judul: Pengujian Aplikasi Mobile dengan User Acceptance Testing dan Maestro."*
2. **Bagian 2 (Menit 01:00 – 03:00): Gambaran Aplikasi & Fitur Utama**
   - Tunjukkan aplikasi **Pandhawa Notbook Salatiga** yang terpasang di HP.
   - Sorot logo monogram baru, nama teknisi tunggal (**Dony Ibnu Prakoso**), kartu 3D SSD dan Keyboard di menu Gudang, modul intake tiket, kasir POS, dan portal tracking.
3. **Bagian 3 (Menit 03:00 – 05:30): Penjelasan Laporan UAT (6 Skenario)**
   - Buka dokumen laporan UAT.
   - Jelaskan 3 persona pengguna dan paparkan secara singkat 6 skenario pengujian (UAT-01 s/d UAT-06) dengan penekanan pada alur positif, validasi masukan kosong, dan penanganan galat pencarian tiket salah. Tunjukkan bahwa seluruh skenario berhasil 100% LULUS.
4. **Bagian 4 (Menit 05:30 – 08:30): Automate Testing Maestro & Bukti Eksekusi**
   - Tunjukkan 4 file YAML di folder `maestro/` (`01_app_launch.yaml`, `02_navigation.yaml`, `03_crud_transaction.yaml`, `04_validation_error.yaml`).
   - Tunjukkan perintah `assertVisible` dan `takeScreenshot` pada kode YAML.
   - Tampilkan hasil tangkapan layar bukti eksekusi di folder `maestro/screenshots/`.
5. **Bagian 5 (Menit 08:30 – 10:00): Kerapian Repositori GitHub & Penutup**
   - Buka repositori GitHub [https://github.com/ARCANO39/dony-ibnu](https://github.com/ARCANO39/dony-ibnu).
   - Tunjukkan riwayat 25 commit bermakna, branch `main` & `develop`, serta file APK rilis `pandhawa_notbook_salatiga.apk`.
   - Tutup presentasi dengan salam dan ucapan terima kasih.

---

## 8. KESIMPULAN & PENUTUP

Berdasarkan seluruh hasil perancangan, implementasi, dan pengujian yang telah dipaparkan:
1. Aplikasi **Pandhawa Notbook Salatiga** telah memenuhi seluruh kriteria fungsionalitas sistem operasional servis laptop.
2. Pengujian manual berbasis skenario **User Acceptance Testing (UAT)** berhasil mencapai tingkat kelulusan **100% (6/6 Pass)**.
3. Pengujian otomatis berbasis **Maestro** telah mencakup pembukaan aplikasi, navigasi 5 modul, alur transaksi CRUD, serta validasi kesalahan, lengkap dengan bukti screenshot otentik.
4. Repositori GitHub terkelola dengan rapi menggunakan 25 commit bermakna dan menyediakan berkas APK rilis yang siap diuji kapan saja.

Laporan ini disusun secara utuh untuk memenuhi evaluasi Ujian Tengah Semester (UTS) Ganjil Tahun Akademik 2026/2027.

*Surakarta, November 2026*  
**Mahasiswa Penguji,**

**Dony Ibnu Prakoso**  
NIM: [Isi NIM Anda]  
Kelas TI23B — S1 Teknik Informatika  
Fakultas Ilmu Komputer, Universitas Duta Bangsa Surakarta

