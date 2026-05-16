@echo off
echo ========================================
echo Fix ALL Missing Columns in Orders Table
echo ========================================
echo.

echo Step 1: Current orders table structure...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "DESCRIBE orders;" 2>nul
echo.

echo Step 2: Adding ALL missing columns...
echo.

echo Adding prescription_id...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "ALTER TABLE orders ADD COLUMN IF NOT EXISTS prescription_id BIGINT NULL;" 2>nul

echo Adding status_changed_at...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "ALTER TABLE orders ADD COLUMN IF NOT EXISTS status_changed_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP;" 2>nul

echo Adding created_at (if missing)...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "ALTER TABLE orders ADD COLUMN IF NOT EXISTS created_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP;" 2>nul

echo Adding customer_email (if missing)...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "ALTER TABLE orders ADD COLUMN IF NOT EXISTS customer_email VARCHAR(255) NULL;" 2>nul

echo.
echo ✓ All columns added
echo.

echo Step 3: Verifying new structure...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "DESCRIBE orders;" 2>nul
echo.

echo Step 4: Comparing with Order entity requirements...
echo.
echo Required columns (from Order.java):
echo - id (BIGINT, PRIMARY KEY, AUTO_INCREMENT)
echo - customer_id (BIGINT, NOT NULL)
echo - customer_email (VARCHAR)
echo - status (VARCHAR/ENUM)
echo - total_amount (DECIMAL)
echo - delivery_address (VARCHAR)
echo - prescription_id (BIGINT, NULL)
echo - created_at (DATETIME)
echo - status_changed_at (DATETIME)
echo.

echo Step 5: Restarting order-service...
docker-compose restart order-service
echo.
echo Waiting 30 seconds for service to start...
timeout /t 30 /nobreak >nul
echo.

echo Step 6: Checking order-service logs...
docker logs order-service --tail 15 2>nul
echo.

echo ========================================
echo Fix Complete!
echo ========================================
echo.
echo Now try placing your order again!
echo.
echo If it still fails, the error message will tell us
echo which column is missing next.
echo.
pause
