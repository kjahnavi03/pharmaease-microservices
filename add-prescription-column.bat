@echo off
echo ========================================
echo Add prescription_id Column to Orders Table
echo ========================================
echo.

echo Current orders table structure:
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "DESCRIBE orders;" 2>nul
echo.

echo Adding prescription_id column...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "ALTER TABLE orders ADD COLUMN prescription_id BIGINT NULL AFTER delivery_address;" 2>nul

if %ERRORLEVEL% EQU 0 (
    echo ✓ Column added successfully
) else (
    echo Note: Column might already exist or there was an error
)
echo.

echo New orders table structure:
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "DESCRIBE orders;" 2>nul
echo.

echo ========================================
echo Restarting order-service...
echo ========================================
docker-compose restart order-service
echo.

echo ========================================
echo Done!
echo ========================================
echo.
echo Now try placing your order again!
echo.
pause
