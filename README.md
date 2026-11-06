# Pandhawa Notbook Salatiga - Service Management & POS System
### Ujian Tengah Semester (UTS) Ganjil Tahun Akademik 2026/2027
**Mata Kuliah:** Mobile Testing  
**Dosen Pengampu:** Triyono M.Kom  
**Program Studi:** S1 Teknik Informatika  
**Fakultas:** Fakultas Ilmu Komputer, Universitas Duta Bangsa Surakarta  

---

## 👨‍🎓 Identitas Mahasiswa

| Informasi | Detail |
|---|---|
| **Nama Lengkap** | Dony Ibnu |
| **NIM** | [Isi NIM Mahasiswa, contoh: 230101xxx] |
| **Kelas** | TI23B |
| **Peran Proyek** | Full-stack Mobile Developer, Quality Assurance & Mobile Automation Tester |

---

## 🔗 Tautan Pengumpulan Proyek (Submission Links)

- **Tautan Repository GitHub**: [https://github.com/ARCANO39/dony-ibnu](https://github.com/ARCANO39/dony-ibnu)
- **Tautan Video Penjelasan & Demo (Durasi 5–10 menit)**: `[Masukkan Tautan Video YouTube / Google Drive Anda di Sini]`
- **Dokumen Laporan UAT**: [LAPORAN_UAT.md](file:///C:/laptop_service_app/LAPORAN_UAT.md)
- **Folder Flow Automate Testing Maestro**: [maestro/](file:///C:/laptop_service_app/maestro/)
- **Berkas APK Siap Pasang**: [pandhawa_notbook_salatiga.apk](file:///C:/laptop_service_app/pandhawa_notbook_salatiga.apk)

---

## 📖 Gambaran Umum Aplikasi

### 1. Tujuan Aplikasi
Aplikasi **Pandhawa Notbook Salatiga** dirancang untuk mendigitalkan seluruh siklus hidup perbaikan laptop di pusat servis, mulai dari pencatatan fisik unit masuk (*intake*), pembagian kerja teknisi, alokasi suku cadang (*inventory sparepart*), kasir pembayaran (*POS & billing*), hingga portal pelacakan mandiri (*tracking*) yang transparan bagi pelanggan tanpa perlu menelepon kasir.

### 2. Target Pengguna (User Personas)
1. **Front Office / Kasir**: Menerima unit, mencatat keluhan & checklist fisik laptop, mencetak label QR, dan memproses pelunasan di kasir.
2. **Teknisi Servis & QC**: Melakukan diagnosa perbaikan, mencatat log pengerjaan, mengambil sparepart gudang, dan melakukan pengujian akhir.
3. **Pelanggan / Konsumen**: Melacak progres servis laptop secara mandiri lewat portal tracking menggunakan nomor tiket dan 4-digit nomor WhatsApp.

### 3. Fitur Utama
- **Dashboard Operasional**: Ringkasan metrik unit aktif, unit siap diambil, stok kritis, dan total pendapatan secara real-time.
- **Registrasi Servis Unit Masuk (`TicketRegistrationView`)**: Formulir penerimaan laptop, checklist fisik (baret, charger, baut, tas), penerbitan nomor tiket unik (`SRV-YYYYMMDD-XXX`), dan QR Code label fisik unit.
- **Meja Kerja Teknisi (`TechnicianView`)**: Antrean tiket berjenjang (Diagnosa, Konfirmasi, Pengerjaan, Testing QC, Siap Diambil), log perbaikan teknisi, dan pemotongan stok suku cadang otomatis.
- **Inventaris Suku Cadang Gudang (`InventoryView`)**: Katalog sparepart laptop (LCD, RAM, SSD, Baterai, Keyboard, Pasta Thermal) lengkap dengan peringatan stok kritis (*minimum stock warning*).
- **Kasir POS & Pelunasan (`PosView`)**: Perhitungan tagihan jasa + sparepart dikurangi uang muka (DP), metode bayar tunai/QRIS, serta cetak struk pembayaran.
- **Portal Pelacakan Mandiri (`TrackingView`)**: Timeline progres perbaikan interaktif dengan proteksi keamanan 4-digit nomor WhatsApp terdaftar.

### 4. Alur Pengguna (End-to-End User Flow)
```text
[Pelanggan Datang] 
       │
       ▼
[Front Office: Registrasi Servis & Terbit Label QR]
       │
       ▼
[Teknisi: Diagnosa Kerusakan & Pemakaian Sparepart]
       │
       ▼
[Teknisi: Pengerjaan & Testing QC (Quality Control)]
       │
       ▼
[Status: Siap Diambil] ◄── [Pelanggan: Lacak Progres via Portal Tracking]
       │
       ▼
[Kasir POS: Pelunasan Sisa Biaya & Pengambilan Unit]
       │
       ▼
[Selesai & Total Pendapatan Toko Bertambah]
```

### 5. Batasan Pengujian (Testing Scope & Boundaries)
- **Cakupan Pengujian**:
  - Pengujian fungsionalitas antarmuka (*UI Testing*) pada perangkat Android (resolusi smartphone & tablet).
  - Pengujian alur utama bisnis (*Happy Path*): registrasi, perbaikan teknisi, pemotongan stok, dan kasir POS.
  - Pengujian validasi masukan data (*Input Validation*): field kosong, tipe data, dan format teks.
  - Pengujian kondisi gagal (*Negative Testing*): pencarian tiket fiktif/salah dan form submission tidak lengkap.
  - Automate testing menggunakan **Maestro** untuk regression testing.
- **Batasan di Luar Pengujian**:
  - Pengujian integrasi printer thermal fisik secara langsung (disimulasikan via preview dokumen PDF).
  - Pengujian beban jaringan ekstrem (*Stress/Load Testing*) karena aplikasi difokuskan pada pengujian mobile sisi klien (*Client-side Mobile Testing*).

---

## 🧪 Automate Testing Menggunakan Maestro

Proyek ini telah dilengkapi dengan **4 skenario file YAML Maestro** di dalam folder `maestro/` sesuai ketentuan teknis soal:

| No | Berkas Flow | Skenario Pengujian | Komponen Assertion & Verifikasi |
|:---:|:---|:---|:---|
| **1** | `01_app_launch.yaml` | Pembukaan Aplikasi & Inisialisasi | Memverifikasi App Bar title "Pandhawa Notbook Salatiga", banner sambutan, 4 metric cards (Unit Aktif, Siap Diambil, Stok Kritis, Pendapatan), dan 6 tab navigasi. |
| **2** | `02_navigation.yaml` | Navigasi Antar Halaman | Memverifikasi perpindahan mulus antara 5 modul utama (Registrasi ➔ Teknisi ➔ Gudang ➔ Kasir ➔ Tracking ➔ Kembali ke Dashboard). |
| **3** | `03_crud_transaction.yaml` | Alur Transaksi / CRUD | Mengisi form unit laptop baru ("Budi Santoso", "ROG Zephyrus G14"), checklist charger, submit form, verifikasi popup QR Code, dan verifikasi tiket masuk ke antrean teknisi. |
| **4** | `04_validation_error.yaml` | Validasi Kesalahan & Negative Testing | Menguji penolakan form kosong (assertion pesan "Wajib diisi") dan pengujian pencarian tracking tiket salah (assertion pesan error "Tiket tidak ditemukan..."). |

### Perintah Eksekusi Maestro:
```bash
# 1. Pastikan emulator atau HP terhubung
adb devices

# 2. Jalankan seluruh automate test
maestro test maestro/

# 3. Atau jalankan per flow
maestro test maestro/01_app_launch.yaml
maestro test maestro/02_navigation.yaml
maestro test maestro/03_crud_transaction.yaml
maestro test maestro/04_validation_error.yaml
```
*Panduan instalasi dan tangkapan layar bukti eksekusi tersedia lengkap di [maestro/README.md](file:///C:/laptop_service_app/maestro/README.md).*

---

## 📋 Laporan User Acceptance Testing (UAT)

Laporan pengujian penerimaan pengguna telah disusun dalam dokumen [LAPORAN_UAT.md](file:///C:/laptop_service_app/LAPORAN_UAT.md) dengan memuat:
1. **Tujuan Pengujian**
2. **Profil Persona Pengguna**: Front Office/Kasir (`P-01`), Teknisi Hardware & QC (`P-02`), Pelanggan (`P-03`).
3. **Kriteria Penerimaan (Acceptance Criteria)**
4. **Prasyarat Pengujian (Preconditions)**
5. **Langkah-langkah Pengujian Terperinci (Test Steps)**
6. **Hasil Aktual (Actual Results)**
7. **Status Kelulusan (Pass Rate: 100%)**
8. **Bukti Tangkapan Layar Pengujian (Test Evidence)**

---

## 🚀 Petunjuk Menjalankan Aplikasi & Pemasangan APK

### 1. Pemasangan Langsung Berkas APK (Android)
File APK Release telah tersedia pada root repositori:
```text
C:\laptop_service_app\pandhawa_notbook_salatiga.apk
```
Pasang ke perangkat/emulator menggunakan ADB:
```bash
adb install pandhawa_notbook_salatiga.apk
```

### 2. Menjalankan Melalui Source Code (Flutter)
```bash
# Masuk ke direktori flutter
cd C:\laptop_service_app\laptop_service_app

# Ambil dependencies
flutter pub get

# Jalankan pada perangkat yang aktif
flutter run
```

---

## 🌿 Arsitektur Git & Riwayat Commit

Repositori ini dikembangkan menggunakan standar **GitFlow** dengan commit bertahap sejak awal pengembangan:
- Branch `main`: Cabang produksi terverifikasi rilis stabil (`v1.0.0`).
- Branch `develop`: Cabang integrasi pengembangan fitur.
- Branch `feature/*`:
  - `feature/project-scaffolding`
  - `feature/domain-models-state`
  - `feature/ticket-registration`
  - `feature/technician-workbench`
  - `feature/inventory-management`
  - `feature/pos-billing`
  - `feature/customer-tracking`
  - `feature/dashboard-navigation`
  - `feature/branding-pandhawa-salatiga`
  - `feature/maestro-automate-testing` (Testing suite & laporan UAT)
