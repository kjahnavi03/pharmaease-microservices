@echo off
echo ========================================
echo Import All 26 Medicines to Docker MySQL
echo ========================================
echo.
echo This will:
echo 1. Clear existing medicines from Docker MySQL
echo 2. Import all 26 medicines from local-medicines-export.sql
echo.
pause
echo.

echo Step 1: Clearing existing medicines...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE medicines; SET FOREIGN_KEY_CHECKS=1;"
echo.

echo Step 2: Importing all 26 medicines...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db < local-medicines-export.sql
echo.

echo Step 3: Verifying import...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SELECT COUNT(*) as 'Total Medicines' FROM medicines;"
echo.

echo Step 4: Showing first 10 medicines...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SELECT id, name, price, stock_quantity FROM medicines LIMIT 10;"
echo.

echo ========================================
echo Import Complete!
echo ========================================
echo.
echo Now open http://localhost:4200 and check the Medicines page!
echo.
pause
