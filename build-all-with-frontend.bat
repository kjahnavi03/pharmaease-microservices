@echo off
REM Complete Build Script - Backend + Frontend
REM This script builds all services including the frontend

echo ========================================
echo 🚀 Building PharmaEase - Complete Stack
echo ========================================
echo.

REM ─── Backend Services ───────────────────
echo 📦 Building Backend Services...
echo.

set services=eureka-server config-server gateway-service auth-service catalog-service order-service admin-service payment-service notification-service

for %%s in (%services%) do (
  echo [Backend] Building %%s...
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

REM ─── Frontend ────────────────────────────
echo 🎨 Building Frontend...
echo.

cd pharma-frontend

echo [Frontend] Installing dependencies...
call npm install
if errorlevel 1 (
  echo ❌ Frontend npm install failed
  exit /b 1
)

echo [Frontend] Building production bundle...
call npm run build -- --configuration production
if errorlevel 1 (
  echo ❌ Frontend build failed
  exit /b 1
)

echo ✅ Frontend built successfully
cd ..
echo.

REM ─── Summary ─────────────────────────────
echo ========================================
echo 🎉 All services built successfully!
echo ========================================
echo.
echo Next steps:
echo 1. docker-compose build    # Build Docker images
echo 2. docker-compose up -d    # Start all containers
echo 3. Open http://localhost:4200
echo.
