@echo off
echo ========================================
echo Check and Fix User Roles
echo ========================================
echo.

echo Checking user roles in database...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "SELECT id, email, roles FROM users WHERE email='balajiparise500@gmail.com';"
echo.

echo If the roles column is empty or doesn't contain 'CUSTOMER', run:
echo fix-user-roles.bat
echo.
pause
