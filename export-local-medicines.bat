@echo off
echo ========================================
echo Export Medicines from Local MySQL
echo ========================================
echo.
echo This script will export all medicines from your local MySQL database.
echo.
echo REQUIREMENTS:
echo - MySQL must be running on localhost:3306
echo - You need the root password: Janu@0307
echo.
echo The exported file will be saved as: local-medicines-export.sql
echo.
pause
echo.

echo Exporting medicines from catalog_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert catalog_db medicines > local-medicines-export.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Export Successful!
    echo ========================================
    echo.
    echo File saved: local-medicines-export.sql
    echo.
    echo NEXT STEPS:
    echo 1. Run: import-medicines-to-docker.bat
    echo 2. This will import your medicines into Docker MySQL
    echo.
) else (
    echo.
    echo ========================================
    echo Export Failed!
    echo ========================================
    echo.
    echo Possible reasons:
    echo - MySQL is not running on localhost:3306
    echo - Wrong password
    echo - catalog_db database doesn't exist
    echo - mysqldump command not found in PATH
    echo.
    echo Please check and try again.
    echo.
)

pause
