@echo off
echo ===================================================
echo   Mengupload Pandhawa Notbook Salatiga ke GitHub
echo   Target: https://github.com/ARCANO39/dony-ibnu.git
echo ===================================================
echo.
cd /d "%~dp0"

echo [1/2] Mengupload seluruh branch (main, develop, dan feature branches)...
git push -u origin --all --force

echo.
echo [2/2] Mengupload release tag (v1.0.0)...
git push -u origin --tags

echo.
echo ===================================================
echo   SELESAI! Berhasil diupload ke GitHub.
echo   Buka link: https://github.com/ARCANO39/dony-ibnu
echo ===================================================
pause

