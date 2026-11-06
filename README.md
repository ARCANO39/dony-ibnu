# Pandhawa Notbook Salatiga - Service Management & POS System

Sistem Manajemen Servis Laptop, Inventaris Suku Cadang, Kasir POS, dan Portal Pelacakan Servis Real-Time berbasis Flutter (Multiplatform: Android & Web).

## 📌 Fitur Utama

1. **Dashboard Manajemen Servis**:
   - Ringkasan metrik unit aktif, unit siap diambil, stok kritis, dan total pendapatan.
   - Menu aksi cepat & visual cards untuk akses seluruh fitur operasional.
   - Daftar tiket servis terkini dengan status interaktif.

2. **Registrasi Servis Unit Masuk (`TicketRegistrationView`)**:
   - Pencatatan identitas pelanggan, brand, tipe, serial number, password unit, dan keluhan awal.
   - Checklist fisik penerimaan laptop (kondisi fisik, charger, tas, baut).
   - Pembuatan nomor tiket otomatis dan QR Code label fisik untuk unit.

3. **Meja Kerja Teknisi (`TechnicianView`)**:
   - Filter antrean pengerjaan: Antrean, Diagnosa, Konfirmasi Biaya, Pengerjaan, Testing QC, Siap Diambil.
   - Pencatatan log pengerjaan teknisi dan estimasi biaya perbaikan.
   - Penggunaan sparepart langsung dari stok gudang dengan pemotongan stok otomatis.

4. **Inventaris Sparepart & Gudang (`InventoryView`)**:
   - Katalog komponen laptop (LCD, RAM, SSD, Baterai, Keyboard, Pasta Thermal).
   - Indikator stok kritis (minimum stock warning) dan manajemen harga modal/jual.
   - Filter pencarian berbasis SKU, nama barang, dan kategori komponen.

5. **Kasir POS & Pembayaran (`PosView`)**:
   - Penyelesaian nota servis, pelunasan sisa tagihan (DP deduction), dan biaya jasa.
   - Riwayat transaksi kasir lengkap dengan nomor nota, metode pembayaran, dan waktu transaksi.
   - Cetak struk dan nota bukti pembayaran digital/fisik.

6. **Portal Tracking Pelanggan (`TrackingView`)**:
   - Pelacakan progres status perbaikan unit secara mandiri oleh pelanggan.
   - Keamanan verifikasi 4-digit nomor WhatsApp terdaftar.
   - Tampilan timeline transparan: Masuk -> Diagnosa -> Pengerjaan -> QC -> Siap Diambil.

---

## 🛠️ Arsitektur & Teknologi

- **Framework**: Flutter 3.47 (Dart 3.x)
- **State Management**: Provider (`AppState`)
- **Routing**: Tab Navigation & GoRouter
- **Database/Backend Ready**: Supabase integration ready
- **Hardware Integration**: Barcode/QR Scanner (`mobile_scanner`), Thermal & PDF Printing (`printing`, `pdf`), QR Generator (`qr_flutter`)
- **Platform Support**: Android (APK release), Web (PWA / Chrome Desktop)

---

## 🚀 Panduan Menjalankan Aplikasi

### 1. Web Version (Chrome / Desktop)
```bash
# Jalankan langsung di browser
flutter run -d chrome
```

### 2. Android Version (APK Build)
```bash
# Build file APK Release
flutter build apk --release

# Output APK:
# - C:\laptop_service_app\pandhawa_notbook_salatiga.apk
```

