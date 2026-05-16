@echo off
echo ========================================
echo Complete Fix for Order Placement
echo ========================================
echo.

echo Step 1: Checking orders table structure...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SHOW COLUMNS FROM orders;" 2>nul
echo.

echo Step 2: Adding missing prescription_id column...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "ALTER TABLE orders ADD COLUMN IF NOT EXISTS prescription_id BIGINT NULL;" 2>nul
echo.

echo Step 3: Verifying column was added...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SHOW COLUMNS FROM orders WHERE Field='prescription_id';" 2>nul
echo.

echo Step 4: Checking order_items table...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SHOW COLUMNS FROM order_items;" 2>nul
echo.

echo Step 5: Restarting order-service...
docker-compose restart order-service
echo Waiting for service to start...
timeout /t 30 /nobreak >nul
echo.

echo Step 6: Checking order-service logs...
docker logs order-service --tail 20
echo.

echo ========================================
echo Fix Complete!
echo ========================================
echo.
echo Now try placing your order again.
echo If it still fails, check the browser console (F12) for errors.
echo.
pause
