@echo off
echo.
echo ========================================
echo   PharmaEase Docker Status Check
echo ========================================
echo.

echo Checking Docker containers...
echo.
docker-compose ps
echo.

echo ========================================
echo Container Details:
echo ========================================
echo.

echo Checking Eureka (Service Registry)...
curl -s http://localhost:8761 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Eureka Server is running - http://localhost:8761
) else (
    echo [FAIL] Eureka Server is not responding
)

echo Checking Gateway...
curl -s http://localhost:8888 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Gateway Service is running - http://localhost:8888
) else (
    echo [FAIL] Gateway Service is not responding
)

echo Checking Frontend...
curl -s http://localhost:4200 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Frontend is running - http://localhost:4200
) else (
    echo [FAIL] Frontend is not responding
)

echo Checking RabbitMQ Management...
curl -s http://localhost:15672 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] RabbitMQ Management is running - http://localhost:15672
) else (
    echo [FAIL] RabbitMQ Management is not responding
)

echo Checking Zipkin...
curl -s http://localhost:9411 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Zipkin is running - http://localhost:9411
) else (
    echo [FAIL] Zipkin is not responding
)

echo.
echo ========================================
echo Resource Usage:
echo ========================================
echo.
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
echo.

echo ========================================
echo Quick Access URLs:
echo ========================================
echo.
echo Frontend:  http://localhost:4200
echo Eureka:    http://localhost:8761
echo Gateway:   http://localhost:8888
echo RabbitMQ:  http://localhost:15672 (guest/guest)
echo Zipkin:    http://localhost:9411
echo.
pause
