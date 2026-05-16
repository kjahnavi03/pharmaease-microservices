@echo off
echo ========================================
echo Fix User Roles
echo ========================================
echo.
echo This will update your user to have CUSTOMER role.
echo.
pause
echo.

echo Updating user roles...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "UPDATE users SET roles='CUSTOMER' WHERE email='balajiparise500@gmail.com';"
echo.

echo Verifying update...
docker exec -i pharmacy-mysql mysql -uroot -p"Janu@0307" auth_db -e "SELECT id, email, roles FROM users WHERE email='balajiparise500@gmail.com';"
echo.

echo ========================================
echo Roles Updated!
echo ========================================
echo.
echo Now:
echo 1. Logout from the application
echo 2. Login again
echo 3. You should see Prescriptions, My Orders, and Notifications in the menu
echo.
pause
