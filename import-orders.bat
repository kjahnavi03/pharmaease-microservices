@echo off
echo ========================================
echo Import Orders from Local MySQL
echo ========================================
echo.
echo This will import your order history from local MySQL to Docker.
echo.
pause
echo.

echo Step 1: Exporting orders from local MySQL...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert order_db orders order_items > local-orders-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ Orders exported successfully
) else (
    echo ✗ No orders found in local MySQL or export failed
    pause
    exit /b 1
)
echo.

echo Step 2: Importing orders to Docker MySQL...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE order_items; TRUNCATE TABLE orders; SET FOREIGN_KEY_CHECKS=1;" 2>nul
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db < local-orders-export.sql 2>nul
echo.

echo Step 3: Verifying import...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SELECT COUNT(*) as 'Total Orders' FROM orders; SELECT COUNT(*) as 'Total Order Items' FROM order_items;" 2>nul
echo.

echo Step 4: Showing your orders...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SELECT id, customer_id, total_amount, status, order_date FROM orders LIMIT 5;" 2>nul
echo.

echo ========================================
echo Import Complete!
echo ========================================
echo.
echo Now refresh the My Orders page to see your orders!
echo.
pause
