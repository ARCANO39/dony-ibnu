@echo off
echo ========================================================
echo   PANDHAWA NOTBOOK SALATIGA - MAESTRO AUTOMATE TESTING
echo   Mata Kuliah: Mobile Testing (TI23B)
echo   Dosen: Triyono M.Kom
echo ========================================================
echo.
cd /d "%~dp0"

echo [*] Memeriksa daftar perangkat Android / Emulator yang aktif:
adb devices
echo.

echo --------------------------------------------------------
echo Menu Pilihan Pengujian Maestro:
echo [1] Jalankan SEMUA Flow Sekaligus (Flow 01 s/d 04)
echo [2] Flow 01: Pembukaan Aplikasi & Verifikasi Dashboard
echo [3] Flow 02: Navigasi Antar Halaman (5 Modul)
echo [4] Flow 03: Alur Transaksi CRUD Tiket Servis Baru
echo [5] Flow 04: Validasi Kesalahan & Negative Testing
echo [6] Keluar
echo --------------------------------------------------------
set /p pilihan="Pilih nomor menu (1-6): "

if "%pilihan%"=="1" (
    echo.
    echo [*] Menjalankan seluruh skenario Maestro...
    maestro test maestro/
)
if "%pilihan%"=="2" (
    echo.
    echo [*] Menjalankan Flow 01...
    maestro test maestro/01_app_launch.yaml
)
if "%pilihan%"=="3" (
    echo.
    echo [*] Menjalankan Flow 02...
    maestro test maestro/02_navigation.yaml
)
if "%pilihan%"=="4" (
    echo.
    echo [*] Menjalankan Flow 03...
    maestro test maestro/03_crud_transaction.yaml
)
if "%pilihan%"=="5" (
    echo.
    echo [*] Menjalankan Flow 04...
    maestro test maestro/04_validation_error.yaml
)

echo.
echo ========================================================
echo Selesai! Tangkapan layar tersimpan di folder maestro/screenshots/
echo ========================================================
pause

