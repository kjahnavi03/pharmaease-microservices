@echo off
echo ========================================
echo Rebuilding Frontend Docker Image
echo ========================================
echo.

echo Step 1: Stopping frontend container...
docker-compose stop frontend
echo.

echo Step 2: Removing old frontend container...
docker-compose rm -f frontend
echo.

echo Step 3: Rebuilding frontend image...
docker-compose build frontend
echo.

echo Step 4: Starting frontend container...
docker-compose up -d frontend
echo.

echo ========================================
echo Frontend Rebuild Complete!
echo ========================================
echo.
echo Frontend is now running at: http://localhost:4200
echo.
pause
