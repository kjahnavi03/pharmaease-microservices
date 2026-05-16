@echo off
echo ========================================
echo Fix Orders Table Schema
echo ========================================
echo.
echo This will add the missing prescription_id column to Docker MySQL.
echo.
pause
echo.

echo Step 1: Checking current orders table structure...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "DESCRIBE orders;" 2>nul
echo.

echo Step 2: Adding prescription_id column...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "ALTER TABLE orders ADD COLUMN IF NOT EXISTS prescription_id BIGINT NULL;" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ Column added successfully
) else (
    echo ✗ Failed to add column
)
echo.

echo Step 3: Verifying new structure...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "DESCRIBE orders;" 2>nul
echo.

echo ========================================
echo Schema Fixed!
echo ========================================
echo.
echo Now run: compare-and-import-orders.bat
echo.
pause
