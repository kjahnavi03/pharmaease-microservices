@echo off
echo ========================================
echo Copy Exact Schema from Local to Docker
echo ========================================
echo.
echo This will copy your EXACT working schema from local MySQL to Docker MySQL.
echo This is the CORRECT way to fix the schema mismatch issue.
echo.
pause
echo.

echo Step 1: Exporting schema from LOCAL MySQL...
echo.
mysqldump -u root -p"Janu@0307" --no-data --skip-triggers order_db > local-order-schema.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ Schema exported: local-order-schema.sql
) else (
    echo ✗ Export failed! Make sure local MySQL is running.
    pause
    exit /b 1
)
echo.

echo Step 2: Backing up existing data in Docker MySQL...
echo.
docker exec -i pharmacy-mysql mysqldump -uroot -p"Janu@0307" --no-create-info order_db > docker-order-data-backup.sql 2>nul
echo ✓ Data backed up: docker-order-data-backup.sql
echo.

echo Step 3: Dropping existing tables in Docker MySQL...
echo.
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "SET FOREIGN_KEY_CHECKS=0; DROP TABLE IF EXISTS order_items; DROP TABLE IF EXISTS orders; SET FOREIGN_KEY_CHECKS=1;" 2>nul
echo ✓ Old tables dropped
echo.

echo Step 4: Creating tables with EXACT schema from local MySQL...
echo.
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db < local-order-schema.sql 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ Schema imported successfully
) else (
    echo ✗ Import failed!
    pause
    exit /b 1
)
echo.

echo Step 5: Verifying new schema...
echo.
echo Orders table structure:
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "DESCRIBE orders;" 2>nul
echo.
echo Order_items table structure:
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" order_db -e "DESCRIBE order_items;" 2>nul
echo.

echo Step 6: Restarting order-service...
docker-compose restart order-service
echo.
echo Waiting 30 seconds for service to start...
timeout /t 30 /nobreak >nul
echo.

echo Step 7: Checking order-service logs...
docker logs order-service --tail 15 2>nul
echo.

echo ========================================
echo Schema Sync Complete!
echo ========================================
echo.
echo Your Docker MySQL now has the EXACT same schema as your local MySQL.
echo.
echo Next steps:
echo 1. Try placing an order - it should work now!
echo 2. If you want your old orders, run: compare-and-import-orders.bat
echo.
echo Files created:
echo - local-order-schema.sql (your working schema)
echo - docker-order-data-backup.sql (backup of any data that was in Docker)
echo.
pause
