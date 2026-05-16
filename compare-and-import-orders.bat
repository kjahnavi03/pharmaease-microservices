@echo off
echo ========================================
echo Compare Local vs Docker Orders
echo ========================================
echo.

echo Checking LOCAL MySQL order_db...
echo.
echo Total orders in LOCAL MySQL:
mysql -u root -p"Janu@0307" order_db -e "SELECT COUNT(*) as Total FROM orders;" 2>nul
echo.

echo Orders for user ID 17 in LOCAL MySQL:
mysql -u root -p"Janu@0307" order_db -e "SELECT id, customer_id, total_amount, status, order_date FROM orders WHERE customer_id=17 LIMIT 5;" 2>nul
echo.

echo ========================================
echo.
echo Checking DOCKER MySQL order_db...
echo.
echo Total orders in DOCKER MySQL:
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SELECT COUNT(*) as Total FROM orders;" 2>nul
echo.

echo ========================================
echo Exporting from LOCAL MySQL...
echo ========================================
echo.

echo Exporting orders table...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert --skip-add-locks order_db orders > local-orders-only.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ Orders table exported
) else (
    echo ✗ Orders export failed
)

echo Exporting order_items table...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert --skip-add-locks order_db order_items > local-order-items-only.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ Order items table exported
) else (
    echo ✗ Order items export failed
)
echo.

echo ========================================
echo Importing to DOCKER MySQL...
echo ========================================
echo.

echo Clearing existing data...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SET FOREIGN_KEY_CHECKS=0; DELETE FROM order_items; DELETE FROM orders; SET FOREIGN_KEY_CHECKS=1;" 2>nul

echo Importing orders...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db < local-orders-only.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ Orders imported
) else (
    echo ✗ Orders import failed
)

echo Importing order items...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db < local-order-items-only.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ Order items imported
) else (
    echo ✗ Order items import failed
)
echo.

echo ========================================
echo Verifying Import...
echo ========================================
echo.

echo Total orders in DOCKER MySQL (after import):
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SELECT COUNT(*) as Total FROM orders;" 2>nul
echo.

echo Your orders in DOCKER MySQL:
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SELECT id, customer_id, total_amount, status, order_date FROM orders WHERE customer_id=17;" 2>nul
echo.

echo ========================================
echo Import Complete!
echo ========================================
echo.
echo Now:
echo 1. Refresh the My Orders page in your browser
echo 2. You should see all your previous orders!
echo.
pause
