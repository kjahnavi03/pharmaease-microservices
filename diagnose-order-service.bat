@echo off
echo ========================================
echo Diagnose Order Service
echo ========================================
echo.

echo Checking if order-service is running...
docker ps --filter "name=order-service" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo Checking order-service logs (last 30 lines)...
docker logs order-service --tail 30 2>nul
echo.

echo Checking if order-service is registered in Eureka...
curl -s http://localhost:8761/eureka/apps/ORDER-SERVICE 2>nul | findstr "status"
echo.

echo ========================================
echo Restarting order-service...
echo ========================================
docker-compose restart order-service
echo.
echo Waiting 60 seconds for service to start...
timeout /t 60 /nobreak
echo.

echo Checking logs after restart...
docker logs order-service --tail 20 2>nul
echo.

echo ========================================
echo Done!
echo ========================================
echo.
echo Try placing your order again.
echo.
pause
