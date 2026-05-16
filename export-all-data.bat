@echo off
echo ========================================
echo Export ALL Project Data from Local MySQL
echo ========================================
echo.
echo This will export all data from:
echo - auth_db (users, roles)
echo - catalog_db (medicines, categories, prescriptions)
echo - order_db (orders, order_items)
echo - admin_db (admin data)
echo - payment_db (payments)
echo.
pause
echo.

echo Exporting auth_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert auth_db > local-auth-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ auth_db exported successfully
) else (
    echo ✗ auth_db export failed or database doesn't exist
)
echo.

echo Exporting catalog_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert catalog_db > local-catalog-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ catalog_db exported successfully
) else (
    echo ✗ catalog_db export failed or database doesn't exist
)
echo.

echo Exporting order_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert order_db > local-order-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ order_db exported successfully
) else (
    echo ✗ order_db export failed or database doesn't exist
)
echo.

echo Exporting admin_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert admin_db > local-admin-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ admin_db exported successfully
) else (
    echo ✗ admin_db export failed or database doesn't exist
)
echo.

echo Exporting payment_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert payment_db > local-payment-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ payment_db exported successfully
) else (
    echo ✗ payment_db export failed or database doesn't exist
)
echo.

echo ========================================
echo Export Complete!
echo ========================================
echo.
echo Exported files:
echo - local-auth-export.sql
echo - local-catalog-export.sql
echo - local-order-export.sql
echo - local-admin-export.sql
echo - local-payment-export.sql
echo.
echo NEXT STEP: Run import-all-data.bat
echo.
pause
