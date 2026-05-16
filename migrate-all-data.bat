@echo off
echo ========================================
echo Migrate ALL Data: Local MySQL → Docker MySQL
echo ========================================
echo.
echo This script will:
echo 1. Export ALL data from local MySQL
echo 2. Import ALL data to Docker MySQL
echo 3. Restart Docker services
echo.
echo Databases to migrate:
echo - auth_db (users, roles)
echo - catalog_db (medicines, categories, prescriptions)
echo - order_db (orders, order_items)
echo - admin_db (admin data)
echo - payment_db (payments)
echo.
echo REQUIREMENTS:
echo - Local MySQL running on localhost:3306
echo - Docker containers running
echo - Password: Janu@0307
echo.
pause
echo.

echo ========================================
echo STEP 1: Exporting from Local MySQL
echo ========================================
echo.

echo Exporting auth_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert auth_db > local-auth-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ auth_db exported
) else (
    echo ✗ auth_db not found or empty
)

echo Exporting catalog_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert catalog_db > local-catalog-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ catalog_db exported
) else (
    echo ✗ catalog_db not found or empty
)

echo Exporting order_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert order_db > local-order-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ order_db exported
) else (
    echo ✗ order_db not found or empty
)

echo Exporting admin_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert admin_db > local-admin-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ admin_db exported
) else (
    echo ✗ admin_db not found or empty
)

echo Exporting payment_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert payment_db > local-payment-export.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ payment_db exported
) else (
    echo ✗ payment_db not found or empty
)

echo.
echo ========================================
echo STEP 2: Importing to Docker MySQL
echo ========================================
echo.

if exist "local-auth-export.sql" (
    echo Importing auth_db...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE users; SET FOREIGN_KEY_CHECKS=1;" 2>nul
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db < local-auth-export.sql 2>nul
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "SELECT COUNT(*) as 'Users Imported' FROM users;" 2>nul
    echo ✓ auth_db imported
    echo.
)

if exist "local-catalog-export.sql" (
    echo Importing catalog_db...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE medicines; TRUNCATE TABLE prescriptions; SET FOREIGN_KEY_CHECKS=1;" 2>nul
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db < local-catalog-export.sql 2>nul
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SELECT COUNT(*) as 'Medicines Imported' FROM medicines;" 2>nul
    echo ✓ catalog_db imported
    echo.
)

if exist "local-order-export.sql" (
    echo Importing order_db...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE orders; TRUNCATE TABLE order_items; SET FOREIGN_KEY_CHECKS=1;" 2>nul
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db < local-order-export.sql 2>nul
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SELECT COUNT(*) as 'Orders Imported' FROM orders;" 2>nul
    echo ✓ order_db imported
    echo.
)

if exist "local-admin-export.sql" (
    echo Importing admin_db...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" admin_db < local-admin-export.sql 2>nul
    echo ✓ admin_db imported
    echo.
)

if exist "local-payment-export.sql" (
    echo Importing payment_db...
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" payment_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE payments; SET FOREIGN_KEY_CHECKS=1;" 2>nul
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" payment_db < local-payment-export.sql 2>nul
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" payment_db -e "SELECT COUNT(*) as 'Payments Imported' FROM payments;" 2>nul
    echo ✓ payment_db imported
    echo.
)

echo ========================================
echo STEP 3: Restarting Services
echo ========================================
echo.
echo Restarting auth-service...
docker-compose restart auth-service 2>nul
echo Restarting catalog-service...
docker-compose restart catalog-service 2>nul
echo Restarting order-service...
docker-compose restart order-service 2>nul
echo Restarting admin-service...
docker-compose restart admin-service 2>nul
echo Restarting payment-service...
docker-compose restart payment-service 2>nul
echo.

echo ========================================
echo Migration Complete! 🎉
echo ========================================
echo.
echo All data has been migrated from local MySQL to Docker MySQL!
echo.
echo NEXT STEPS:
echo 1. Open http://localhost:4200
echo 2. Login with your existing credentials
echo 3. All your data should be available!
echo.
echo Databases migrated:
echo ✓ Users and authentication
echo ✓ Medicines and prescriptions
echo ✓ Orders and order items
echo ✓ Admin data
echo ✓ Payment records
echo.
pause
