@echo off
echo.
echo ========================================
echo   Starting PharmaEase with Docker
echo ========================================
echo.
echo This will start all 13 containers:
echo - 9 Backend Services
echo - 1 Frontend (Angular)
echo - MySQL Database
echo - RabbitMQ Message Queue
echo - Zipkin Tracing
echo.
pause
echo.

echo Step 1: Checking Docker is running...
docker --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Docker is not installed or not running!
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)
echo OK: Docker is installed
echo.

echo Step 2: Starting all services...
echo This may take 5-10 minutes on first run (building images)
echo.
docker-compose up -d
echo.

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to start services!
    echo Check the error messages above.
    echo.
    pause
    exit /b 1
)

echo Step 3: Waiting for services to initialize (60 seconds)...
timeout /t 60 /nobreak >nul
echo.

echo Step 4: Checking service status...
docker-compose ps
echo.

echo ========================================
echo   Services Started Successfully!
echo ========================================
echo.
echo Access your application:
echo.
echo   Frontend:  http://localhost:4200
echo   Eureka:    http://localhost:8761
echo   RabbitMQ:  http://localhost:15672 (guest/guest)
echo   Zipkin:    http://localhost:9411
echo.
echo Wait 2-3 minutes for all services to fully start.
echo Then check Eureka dashboard to see all services registered.
echo.
echo To view logs: docker-compose logs -f
echo To stop:      docker-compose stop
echo.
pause
