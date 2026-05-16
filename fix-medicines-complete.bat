@echo off
echo ========================================
echo Complete Medicines Fix Script
echo ========================================
echo.
echo This script will:
echo 1. Rebuild frontend with fixed nginx configuration
echo 2. Export medicines from your local MySQL
echo 3. Import medicines to Docker MySQL
echo.
echo REQUIREMENTS:
echo - Docker containers running (docker-compose up -d)
echo - Local MySQL running on localhost:3306
echo - Password: Janu@0307
echo.
pause
echo.

echo ========================================
echo STEP 1: Rebuilding Frontend
echo ========================================
echo.
docker-compose stop frontend
docker-compose rm -f frontend
docker-compose build frontend
docker-compose up -d frontend
echo.
echo Frontend rebuilt successfully!
echo.

echo ========================================
echo STEP 2: Exporting from Local MySQL
echo ========================================
echo.
echo Checking if local MySQL is accessible...
mysql -u root -p"Janu@0307" -e "SELECT 1;" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo WARNING: Cannot connect to local MySQL!
    echo.
    echo Please make sure:
    echo - Local MySQL is running on localhost:3306
    echo - Password is correct: Janu@0307
    echo.
    echo Skipping export step...
    echo You can run export-local-medicines.bat manually later.
    echo.
    goto :skip_export
)

echo Exporting medicines from local MySQL...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert catalog_db medicines > local-medicines-export.sql 2>nul

if %ERRORLEVEL% EQU 0 (
    echo Export successful! File: local-medicines-export.sql
    echo.
    
    echo ========================================
    echo STEP 3: Importing to Docker MySQL
    echo ========================================
    echo.
    docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db < local-medicines-export.sql
    
    if %ERRORLEVEL% EQU 0 (
        echo Import successful!
        echo.
        
        echo Verifying import...
        docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SELECT COUNT(*) as 'Total Medicines' FROM medicines;"
        echo.
    ) else (
        echo Import failed! Check if Docker containers are running.
        echo.
    )
) else (
    echo Export failed! Check if catalog_db database exists in local MySQL.
    echo.
)

:skip_export

echo ========================================
echo COMPLETE!
echo ========================================
echo.
echo Next steps:
echo 1. Open http://localhost:4200 in your browser
echo 2. Go to Medicines page
echo 3. Your medicines should now be visible!
echo.
echo If medicines are still not showing:
echo - Check FIX-MEDICINES-ISSUE.md for troubleshooting
echo - Run: docker logs catalog-service
echo - Run: docker logs pharma-frontend
echo.
pause
