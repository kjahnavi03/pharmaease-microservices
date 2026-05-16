@echo off
echo.
echo ========================================
echo   Stopping PharmaEase Docker Services
echo ========================================
echo.
echo This will stop all running containers.
echo Your data will be preserved.
echo.
pause
echo.

echo Stopping all services...
docker-compose stop
echo.

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to stop services!
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   All Services Stopped Successfully!
echo ========================================
echo.
echo Your data is safe in Docker volumes.
echo.
echo To start again: START-DOCKER.bat
echo To remove everything: docker-compose down -v
echo.
pause
