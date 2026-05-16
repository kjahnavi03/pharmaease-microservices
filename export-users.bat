@echo off
echo ========================================
echo Export Users from Local MySQL
echo ========================================
echo.
echo This script will export all users from your local MySQL database.
echo.
pause
echo.

echo Exporting users from auth_db...
mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert auth_db users > local-users-export.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Export Successful!
    echo ========================================
    echo.
    echo File saved: local-users-export.sql
    echo.
    echo NEXT STEPS:
    echo 1. Run: import-users-to-docker.bat
    echo 2. This will import your users into Docker MySQL
    echo.
) else (
    echo.
    echo ========================================
    echo Export Failed!
    echo ========================================
    echo.
    echo Possible reasons:
    echo - MySQL is not running on localhost:3306
    echo - Wrong password
    echo - auth_db database doesn't exist
    echo - No users table in auth_db
    echo.
)

pause
