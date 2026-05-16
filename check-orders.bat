@echo off
echo ========================================
echo Check Orders in Database
echo ========================================
echo.

echo Checking Docker MySQL order_db...
echo.
echo Total orders:
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SELECT COUNT(*) as Total FROM orders;" 2>nul
echo.

echo Orders for your user (customer_id):
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SELECT o.id, o.customer_id, o.total_amount, o.status, o.order_date FROM orders o WHERE o.customer_id = (SELECT id FROM auth_db.users WHERE email='balajiparise500@gmail.com');" 2>nul
echo.

echo Your user ID:
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "SELECT id, email FROM users WHERE email='balajiparise500@gmail.com';" 2>nul
echo.

echo All orders in database:
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SELECT id, customer_id, total_amount, status, order_date FROM orders LIMIT 10;" 2>nul
echo.

pause
