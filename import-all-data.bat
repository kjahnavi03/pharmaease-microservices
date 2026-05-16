@echo off
echo ========================================
echo Import ALL Project Data to Docker MySQL
echo ========================================
echo.
echo This will import all data to Docker MySQL:
echo - auth_db (users, roles)
echo - catalog_db (medicines, categories, prescriptions)
echo - order_db (orders, order_items)
echo - admin_db (admin data)
echo - payment_db (payments)
echo.
echo WARNING: This will REPLACE existing data in Docker MySQL!
echo.
pause
echo.

echo ========================================
echo Importing auth_db...
echo ========================================
if exist "local-auth-export.sql" (
    echo Clearing existing data...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE users; SET FOREIGN_KEY_CHECKS=1;" 2>nul
    echo Importing data...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db < local-auth-export.sql 2>nul
    echo Verifying...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "SELECT COUNT(*) as 'Users' FROM users;" 2>nul
    echo ✓ auth_db imported
) else (
    echo ✗ local-auth-export.sql not found, skipping
)
echo.

echo ========================================
echo Importing catalog_db...
echo ========================================
if exist "local-catalog-export.sql" (
    echo Clearing existing data...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE medicines; TRUNCATE TABLE categories; TRUNCATE TABLE prescriptions; SET FOREIGN_KEY_CHECKS=1;" 2>nul
    echo Importing data...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db < local-catalog-export.sql 2>nul
    echo Verifying...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SELECT COUNT(*) as 'Medicines' FROM medicines; SELECT COUNT(*) as 'Categories' FROM categories; SELECT COUNT(*) as 'Prescriptions' FROM prescriptions;" 2>nul
    echo ✓ catalog_db imported
) else (
    echo ✗ local-catalog-export.sql not found, skipping
)
echo.

echo ========================================
echo Importing order_db...
echo ========================================
if exist "local-order-export.sql" (
    echo Clearing existing data...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE orders; TRUNCATE TABLE order_items; SET FOREIGN_KEY_CHECKS=1;" 2>nul
    echo Importing data...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db < local-order-export.sql 2>nul
    echo Verifying...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SELECT COUNT(*) as 'Orders' FROM orders; SELECT COUNT(*) as 'Order Items' FROM order_items;" 2>nul
    echo ✓ order_db imported
) else (
    echo ✗ local-order-export.sql not found, skipping
)
echo.

echo ========================================
echo Importing admin_db...
echo ========================================
if exist "local-admin-export.sql" (
    echo Importing data...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" admin_db < local-admin-export.sql 2>nul
    echo ✓ admin_db imported
) else (
    echo ✗ local-admin-export.sql not found, skipping
)
echo.

echo ========================================
echo Importing payment_db...
echo ========================================
if exist "local-payment-export.sql" (
    echo Clearing existing data...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" payment_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE payments; SET FOREIGN_KEY_CHECKS=1;" 2>nul
    echo Importing data...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" payment_db < local-payment-export.sql 2>nul
    echo Verifying...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" payment_db -e "SELECT COUNT(*) as 'Payments' FROM payments;" 2>nul
    echo ✓ payment_db imported
) else (
    echo ✗ local-payment-export.sql not found, skipping
)
echo.

echo ========================================
echo Import Complete!
echo ========================================
echo.
echo All data has been imported to Docker MySQL!
echo.
echo NEXT STEPS:
echo 1. Restart services: docker-compose restart
echo 2. Open http://localhost:4200
echo 3. Login with your existing credentials
echo.
pause
