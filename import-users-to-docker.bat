@echo off
echo ========================================
echo Import Users to Docker MySQL
echo ========================================
echo.
echo This will import users from local-users-export.sql
echo into Docker MySQL auth_db database.
echo.
pause
echo.

if not exist "local-users-export.sql" (
    echo ERROR: local-users-export.sql not found!
    echo.
    echo Please run export-users.bat first.
    echo.
    pause
    exit /b 1
)

echo Step 1: Clearing existing users...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE users; SET FOREIGN_KEY_CHECKS=1;"
echo.

echo Step 2: Importing users...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db < local-users-export.sql
echo.

echo Step 3: Verifying import...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "SELECT COUNT(*) as 'Total Users' FROM users;"
echo.

echo Step 4: Showing users...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "SELECT id, email, role FROM users;"
echo.

echo ========================================
echo Import Complete!
echo ========================================
echo.
echo Now try logging in at http://localhost:4200/login
echo.
pause
