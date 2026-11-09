# LAPORAN USER ACCEPTANCE TESTING (UAT)
## PENGUJIAN APLIKASI MOBILE "PANDHAWA NOTBOOK SALATIGA"

**Mata Kuliah** : Mobile Testing  
**Program Studi / Kelas** : S1 Teknik Informatika / TI23B  
**Fakultas / Universitas** : Fakultas Ilmu Komputer, Universitas Duta Bangsa Surakarta  
**Dosen Pengampu** : Triyono M.Kom  
**Waktu Pengujian** : Semester Ganjil 2026/2027  
**Penguji / Mahasiswa** : Dony Ibnu (NIM: [Isi NIM Mahasiswa])  
**Target Aplikasi** : Pandhawa Notbook Salatiga v1.0.0 (Release Build: `pandhawa_notbook_salatiga.apk`)

---

## 1. Pendahuluan & Ringkasan Eksekutif

Laporan ini disusun untuk memenuhi instrumen evaluasi **Ujian Tengah Semester (UTS) Ganjil Mata Kuliah Mobile Testing**.  
Aplikasi yang diuji adalah sistem informasi operasional servis komputer jinjing **Pandhawa Notbook Salatiga**, mencakup alur penerimaan unit laptop masuk, manajemen pengerjaan teknisi, inventarisasi suku cadang (*sparepart*), kasir *Point of Sale* (POS), serta pelacakan servis mandiri oleh pelanggan.

Pengujian penerimaan pengguna (*User Acceptance Testing* / UAT) ini bertujuan untuk memastikan seluruh fungsionalitas, alur bisnis, validasi masukan data (*input validation*), dan penanganan galat (*error handling*) telah berjalan sesuai dengan ekspektasi pengguna nyata di lapangan.

---

## 2. Profil Persona Pengguna (User Personas)

| ID Persona | Peran Pengguna | Deskripsi & Tanggung Jawab Operasional |
|:---:|:---|:---|
| **P-01** | **Front Office / Kasir** | Bertanggung jawab atas penerimaan laptop pelanggan, pencatatan checklist fisik, pencetakan label QR, serta pemrosesan pembayaran nota di kasir POS. |
| **P-02** | **Teknisi Hardware & QC** | Bertanggung jawab memeriksa kerusakan fisik/mesin, diagnosa, penggantian suku cadang, pencatatan log pengerjaan, dan pengujian kelayakan (*quality control*). |
| **P-03** | **Pelanggan / Customer** | Pemilik laptop yang memanfaatkan portal pelacakan mandiri (*Self-service Tracking*) menggunakan nomor tiket dan 4-digit nomor WhatsApp untuk mengetahui estimasi dan status unitnya secara berkala. |

---

## 3. Matriks Skenario Pengujian UAT

Laporan ini memuat **5 skenario pengujian utama** (mencakup alur utama, validasi input, kondisi gagal, dan hasil yang diharapkan) serta **1 skenario pengujian tambahan**:

```text
[UAT-01] Alur Utama - Registrasi Servis Laptop Baru & Penerbitan Label QR (Positif)
[UAT-02] Alur Utama - Meja Kerja Teknisi, Penggunaan Sparepart & QC (Positif)
[UAT-03] Alur Utama - Pelunasan Pembayaran di Kasir POS & Cetak Nota (Positif)
[UAT-04] Validasi Input - Pengiriman Formulir Registrasi Kosong (Negatif / Validasi)
[UAT-05] Kondisi Gagal - Pelacakan Mandiri dengan Nomor Tiket Tidak Terdaftar (Negatif)
[UAT-06] Fitur Tambahan - Peringatan Stok Kritis pada Modul Gudang Sparepart (Positif)
```

---

## 4. Lembar Rincian Skenario Pengujian UAT

### Skenario 1: UAT-01 (Alur Utama - Registrasi Unit Masuk)
* **ID Skenario**: `UAT-01`
* **Tujuan Pengujian**: Menguji alur pencatatan tiket servis baru untuk pelanggan yang datang ke toko hingga tiket tersimpan dan QR Code penerimaan terbit.
* **Persona**: Front Office / Kasir (`P-01`)
* **Kriteria Penerimaan**:
  1. Sistem berhasil menyimpan seluruh atribut pelanggan, spesifikasi laptop, checklist kelengkapan fisik, dan keluhan.
  2. Sistem otomatis menggenerasi Nomor Tiket unik (`SRV-YYYYMMDD-XXX`).
  3. Dialog konfirmasi sukses muncul bersama gambar QR Code label unit.
* **Prasyarat**: Aplikasi terbuka pada halaman beranda (*Dashboard*).
* **Langkah-langkah Pengujian**:
  1. Klik tab menu navigasi **"Registrasi"**.
  2. Isi kolom `Nama Lengkap Pelanggan *` dengan `"Budi Santoso"`.
  3. Isi kolom `Nomor WhatsApp *` dengan `"081234567890"`.
  4. Isi kolom `Model / Tipe Laptop *` dengan `"ROG Zephyrus G14"`.
  5. Isi kolom `Keluhan Awal Laptop *` dengan `"Layar blank saat render video"`.
  6. Beri centang pada opsi checklist `"Bawa Charger Original"`.
  7. Tekan tombol **"Simpan & Buat Tiket Servis"**.
* **Hasil yang Diharapkan**: Muncul pop-up dialog `"Registrasi Berhasil!"` berisi nomor tiket baru dan QR Code interaktif, serta tombol navigasi menuju ke Meja Teknisi.
* **Hasil Aktual**: Form berhasil tersimpan, nomor tiket `SRV-20261106-004` terbit, QR Code muncul, dan state aplikasi bertambah 1 tiket aktif.
* **Status**: **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/03_crud_ticket_dialog_success.png`

---

### Skenario 2: UAT-02 (Alur Utama - Meja Kerja Teknisi & Sparepart)
* **ID Skenario**: `UAT-02`
* **Tujuan Pengujian**: Menguji alur kerja teknisi saat mendiagnosa, mencatat log perbaikan, memilih suku cadang dari stok gudang, dan memajukan status servis hingga siap diambil.
* **Persona**: Teknisi Hardware & QC (`P-02`)
* **Kriteria Penerimaan**:
  1. Teknisi dapat melihat antrean tiket servis yang masuk.
  2. Status servis dapat diperbarui secara berjenjang (Diagnosa ➔ Pengerjaan ➔ Testing QC ➔ Siap Diambil).
  3. Penggunaan sparepart tercatat pada rincian biaya tiket dan memotong stok gudang.
* **Prasyarat**: Tiket berstatus antrean (*queue*) telah terdaftar pada sistem.
* **Langkah-langkah Pengujian**:
  1. Klik tab menu **"Teknisi"**.
  2. Pilih kartu tiket pelanggan `"Budi Santoso"`.
  3. Tekan tombol aksi untuk mengubah status menjadi `"Diagnosa"`.
  4. Tambahkan catatan log pengerjaan: `"Thermal paste kering & kipas berdebu"`.
  5. Pilih sparepart dari katalog (misal: `"Thermal Paste Artic MX-4"`).
  6. Tekan tombol `"Tandai Siap Diambil / Selesai QC"`.
* **Hasil yang Diharapkan**: Status servis berubah menjadi `"ready"`, kartu berpindah ke antrean kasir, dan log teknisi tersimpan rapi.
* **Hasil Aktual**: Status berhasil terupdate menjadi siap diambil, biaya jasa dan komponen terakumulasi otomatis ke tagihan kasir.
* **Status**: **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/03_crud_verified_in_technician_queue.png`

---

### Skenario 3: UAT-03 (Alur Utama - Transaksi Kasir POS & Pelunasan)
* **ID Skenario**: `UAT-03`
* **Tujuan Pengujian**: Menguji proses kasir dalam menuntaskan nota tagihan servis, memperhitungkan potongan DP, memilih metode bayar, dan menerbitkan struk pelunasan.
* **Persona**: Front Office / Kasir (`P-01`)
* **Kriteria Penerimaan**:
  1. Tiket yang sudah berstatus `"Siap Diambil"` muncul di daftar antrean kasir.
  2. Total biaya dihitung akurat (Biaya Jasa + Biaya Sparepart - Uang Muka DP).
  3. Setelah pembayaran sukses, status servis berubah menjadi `"delivered"` (unit diserahkan) dan total pendapatan toko bertambah.
* **Prasyarat**: Terdapat minimal satu tiket servis dengan status `"ready"`.
* **Langkah-langkah Pengujian**:
  1. Klik tab menu **"Kasir"**.
  2. Pilih tiket servis atas nama `"Budi Santoso"` pada daftar siap pelunasan.
  3. Verifikasi rincian tagihan yang tertera.
  4. Pilih metode pembayaran: `"QRIS / Transfer Bank"`.
  5. Tekan tombol **"Konfirmasi Pelunasan & Selesaikan Nota"**.
* **Hasil yang Diharapkan**: Notifikasi transaksi berhasil muncul, nota tercatat di riwayat transaksi, dan unit dinyatakan selesai diambil pelanggan.
* **Hasil Aktual**: Nota lunas, metric `Total Pendapatan` di Dashboard bertambah, dan unit masuk ke riwayat pengambilan.
* **Status**: **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/02_nav_pos.png`

---

### Skenario 4: UAT-04 (Validasi Input - Form Registrasi Kosong)
* **ID Skenario**: `UAT-04`
* **Tujuan Pengujian**: Menguji keandalan sistem dalam memvalidasi masukan (*input validation*) ketika pengguna mencoba menyimpan formulir registrasi dalam keadaan kosong.
* **Persona**: Front Office / Kasir (`P-01`)
* **Kriteria Penerimaan**:
  1. Formulir tidak boleh terkirim (*prevent submission*).
  2. Pesan kesalahan validasi wajib muncul di bawah setiap *field* yang tidak boleh kosong (`Nama Lengkap`, `Nomor WhatsApp`, `Keluhan`).
* **Prasyarat**: Aplikasi berada di halaman registrasi tiket baru.
* **Langkah-langkah Pengujian**:
  1. Klik tab menu **"Registrasi"**.
  2. Biarkan semua kolom formulir kosong tanpa teks.
  3. Gulir ke bawah dan langsung tekan tombol **"Simpan & Buat Tiket Servis"**.
* **Hasil yang Diharapkan**: Sistem menolak penyimpanan dan menampilkan peringatan teks merah `"Wajib diisi"` serta `"Tuliskan keluhan laptop"`.
* **Hasil Aktual**: Form diblokir dari penyimpanan dan pesan `"Wajib diisi"` tampil dengan jelas pada elemen formulir.
* **Status**: **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/04_validation_empty_form_error.png`

---

### Skenario 5: UAT-05 (Kondisi Gagal - Pelacakan Tiket Tidak Terdaftar)
* **ID Skenario**: `UAT-05`
* **Tujuan Pengujian**: Menguji penanganan kondisi gagal (*negative testing & error handling*) pada portal pencarian mandiri pelanggan saat memasukkan nomor tiket yang salah atau tidak terdaftar.
* **Persona**: Pelanggan / Customer (`P-03`)
* **Kriteria Penerimaan**:
  1. Sistem tidak mengalami kegagalan sistem (*crash/freeze*).
  2. Sistem menampilkan pesan galat yang informatif dan jelas bahwa tiket tidak ditemukan atau verifikasi nomor WhatsApp tidak cocok.
* **Prasyarat**: Aplikasi berada di tab **"Tracking"**.
* **Langkah-langkah Pengujian**:
  1. Klik tab menu **"Tracking"**.
  2. Bersihkan kolom `Nomor Tiket Servis` dan masukkan data acak: `"SRV-99999999-999"`.
  3. Masukkan 4-digit WA acak: `"9999"`.
  4. Tekan tombol **"Lacak Status Servis"**.
* **Hasil yang Diharapkan**: Aplikasi menampilkan banner peringatan berwarna oranye/merah bertuliskan `"Tiket tidak ditemukan atau 4 digit nomor WhatsApp tidak cocok."`.
* **Hasil Aktual**: Pesan galat tampil sesuai ekspektasi, pencarian berhenti secara aman tanpa adanya *unhandled exception*.
* **Status**: **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/04_validation_ticket_not_found_error.png`

---

### Skenario 6: UAT-06 (Fitur Tambahan - Peringatan Stok Kritis Gudang)
* **ID Skenario**: `UAT-06`
* **Tujuan Pengujian**: Menguji indikator peringatan stok kritis pada modul inventaris gudang jika jumlah stok sparepart berada di bawah batas minimum (*threshold*).
* **Persona**: Teknisi Hardware & QC (`P-02`)
* **Kriteria Penerimaan**:
  1. Item yang memiliki kuantitas kurang dari batas aman ditandai dengan badge/label peringatan merah `"Stok Kritis"`.
  2. Kartu statistik pada Dashboard secara tepat menghitung jumlah item kritis tersebut.
* **Prasyarat**: Terdapat suku cadang dengan kuantitas stok di bawah batas aman.
* **Langkah-langkah Pengujian**:
  1. Klik tab menu **"Gudang"**.
  2. Periksa daftar suku cadang yang bertanda stok menipis.
  3. Kembali ke **"Dashboard"** dan periksa kartu statistik **"Stok Kritis"**.
* **Hasil yang Diharapkan**: Jumlah item stok kritis sinkron antara halaman gudang dan kartu dashboard.
* **Hasil Aktual**: Sinkronisasi data akurat (3 item stok kritis terdeteksi secara real-time).
* **Status**: **LULUS (PASS)**
* **Bukti Pengujian**: `maestro/screenshots/01_dashboard_launched.png`

---

## 5. Ringkasan Hasil Pengujian (Summary of Findings)

| ID UAT | Nama Skenario | Kategori Pengujian | Status Hasil |
|:---:|:---|:---:|:---:|
| **UAT-01** | Registrasi Servis Baru & Terbit QR Label | Alur Utama (Positif) | ✅ **LULUS** |
| **UAT-02** | Meja Kerja Teknisi & Pemotongan Sparepart | Alur Utama (Positif) | ✅ **LULUS** |
| **UAT-03** | Kasir POS, Pelunasan & Perhitungan DP | Alur Utama (Positif) | ✅ **LULUS** |
| **UAT-04** | Validasi Input Formulir Kosong | Validasi Masukan (Negatif) | ✅ **LULUS** |
| **UAT-05** | Pelacakan Tiket Fiktif / Tidak Terdaftar | Penanganan Galat (Negatif) | ✅ **LULUS** |
| **UAT-06** | Deteksi Stok Kritis Suku Cadang | Fitur Tambahan (Positif) | ✅ **LULUS** |

**Tingkat Kelulusan (Pass Rate)**: **100% (6 dari 6 skenario berhasil LULUS)**.

---

## 6. Kesimpulan & Rekomendasi

Berdasarkan keseluruhan hasil pengujian User Acceptance Testing (UAT) di atas:
1. **Fungsionalitas**: Seluruh alur utama yang dirancang untuk toko servis laptop Pandhawa Notbook Salatiga telah terimplementasi dengan baik dan bebas dari *bug* pemblokir (*blocker bugs*).
2. **Validasi & Penanganan Galat**: Sistem mampu menangani masukan tidak valid secara anggun (*gracefully*) dengan memberikan pesan umpan balik yang jelas kepada pengguna.
3. **Penerimaan Pengguna**: Aplikasi dinyatakan **MEMENUHI SYARAT & DITERIMA** (*Accepted*) untuk digunakan dalam operasional bisnis dan siap dipresentasikan pada Ujian Tengah Semester (UTS) Mobile Testing.

---

*Surakarta, November 2026*  
**Disusun dan Diuji Oleh:**

**Dony Ibnu**  
NIM: [Isi NIM Anda]  
Kelas: TI23B - S1 Teknik Informatika  
Fakultas Ilmu Komputer, Universitas Duta Bangsa Surakarta

