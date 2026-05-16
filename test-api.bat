@echo off
echo Testing Medicines API...
echo.

echo Test 1: Check medicines in database
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SELECT id, name, price, category_id FROM medicines LIMIT 5;"
echo.

echo Test 2: Check categories in database
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SELECT * FROM categories LIMIT 5;"
echo.

echo Test 3: Test API endpoint (via gateway)
curl -X GET http://localhost:8888/api/catalog/medicines -H "Accept: application/json" 2>nul
echo.

echo Test 4: Test API endpoint (direct to catalog service)
curl -X GET http://localhost:9092/api/catalog/medicines -H "Accept: application/json" 2>nul
echo.

pause
