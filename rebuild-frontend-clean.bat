@echo off
echo ========================================
echo Clean Rebuild Frontend
echo ========================================
echo.
echo This will completely rebuild the frontend container
echo to fix any caching issues.
echo.
pause
echo.

echo Step 1: Stopping frontend...
docker-compose stop frontend
echo.

echo Step 2: Removing frontend container...
docker-compose rm -f frontend
echo.

echo Step 3: Removing frontend image...
docker rmi pharmacy-microservices-frontend
echo.

echo Step 4: Rebuilding frontend...
docker-compose build --no-cache frontend
echo.

echo Step 5: Starting frontend...
docker-compose up -d frontend
echo.

echo ========================================
echo Frontend Rebuilt!
echo ========================================
echo.
echo Wait 30 seconds, then:
echo 1. Open http://localhost:4200
echo 2. Hard refresh: Ctrl+Shift+R
echo 3. Check Medicines page
echo.
pause
