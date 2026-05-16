@echo off
echo.
echo ========================================
echo   PharmaEase Docker Logs Viewer
echo ========================================
echo.
echo Select which logs to view:
echo.
echo 1. All services (combined)
echo 2. Eureka Server
echo 3. Gateway Service
echo 4. Auth Service
echo 5. Catalog Service
echo 6. Order Service
echo 7. Payment Service
echo 8. Admin Service
echo 9. Notification Service
echo 10. Frontend (Nginx)
echo 11. MySQL
echo 12. RabbitMQ
echo 13. Zipkin
echo.
set /p choice="Enter your choice (1-13): "
echo.

if "%choice%"=="1" (
    echo Viewing all logs... Press Ctrl+C to stop
    docker-compose logs -f
) else if "%choice%"=="2" (
    echo Viewing Eureka Server logs... Press Ctrl+C to stop
    docker-compose logs -f eureka-server
) else if "%choice%"=="3" (
    echo Viewing Gateway Service logs... Press Ctrl+C to stop
    docker-compose logs -f gateway-service
) else if "%choice%"=="4" (
    echo Viewing Auth Service logs... Press Ctrl+C to stop
    docker-compose logs -f auth-service
) else if "%choice%"=="5" (
    echo Viewing Catalog Service logs... Press Ctrl+C to stop
    docker-compose logs -f catalog-service
) else if "%choice%"=="6" (
    echo Viewing Order Service logs... Press Ctrl+C to stop
    docker-compose logs -f order-service
) else if "%choice%"=="7" (
    echo Viewing Payment Service logs... Press Ctrl+C to stop
    docker-compose logs -f payment-service
) else if "%choice%"=="8" (
    echo Viewing Admin Service logs... Press Ctrl+C to stop
    docker-compose logs -f admin-service
) else if "%choice%"=="9" (
    echo Viewing Notification Service logs... Press Ctrl+C to stop
    docker-compose logs -f notification-service
) else if "%choice%"=="10" (
    echo Viewing Frontend logs... Press Ctrl+C to stop
    docker-compose logs -f frontend
) else if "%choice%"=="11" (
    echo Viewing MySQL logs... Press Ctrl+C to stop
    docker-compose logs -f mysql
) else if "%choice%"=="12" (
    echo Viewing RabbitMQ logs... Press Ctrl+C to stop
    docker-compose logs -f rabbitmq
) else if "%choice%"=="13" (
    echo Viewing Zipkin logs... Press Ctrl+C to stop
    docker-compose logs -f zipkin
) else (
    echo Invalid choice!
    pause
    exit /b 1
)
