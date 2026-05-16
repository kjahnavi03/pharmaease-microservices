@echo off
REM Build All Microservices Script for Windows
REM This script builds all backend services before Docker containerization

echo 🚀 Building all microservices...
echo.

set services=eureka-server config-server gateway-service auth-service catalog-service order-service admin-service payment-service notification-service

for %%s in (%services%) do (
  echo 📦 Building %%s...
  cd %%s
  call mvn clean package -DskipTests
  if errorlevel 1 (
    echo ❌ %%s build failed
    exit /b 1
  )
  echo ✅ %%s built successfully
  cd ..
  echo.
)

echo 🎉 All services built successfully!
echo.
echo Next steps:
echo 1. docker-compose build    # Build Docker images
echo 2. docker-compose up -d    # Start all containers
