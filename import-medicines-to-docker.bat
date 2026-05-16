@echo off
echo ========================================
echo Import Medicines to Docker MySQL
echo ========================================
echo.
echo This script will import medicines from local-medicines-export.sql
echo into the Docker MySQL database.
echo.
echo REQUIREMENTS:
echo - Docker containers must be running (docker-compose up -d)
echo - local-medicines-export.sql file must exist
echo.
pause
echo.

if not exist "local-medicines-export.sql" (
    echo ERROR: local-medicines-export.sql not found!
    echo.
    echo Please run export-local-medicines.bat first.
    echo.
    pause
    exit /b 1
)

echo Importing medicines into Docker MySQL...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db < local-medicines-export.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Import Successful!
    echo ========================================
    echo.
    echo Your medicines have been imported to Docker MySQL.
    echo.
    echo NEXT STEPS:
    echo 1. Open http://localhost:4200 in your browser
    echo 2. Go to Medicines page
    echo 3. You should see all your medicines now!
    echo.
) else (
    echo.
    echo ========================================
    echo Import Failed!
    echo ========================================
    echo.
    echo Possible reasons:
    echo - Docker containers are not running
    echo - pharmacy-mysql container doesn't exist
    echo - SQL file has errors
    echo.
    echo Try running: docker-compose up -d
    echo Then run this script again.
    echo.
)

pause
