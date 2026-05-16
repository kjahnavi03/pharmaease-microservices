#!/bin/bash

# Build All Microservices Script
# This script builds all backend services before Docker containerization

echo "🚀 Building all microservices..."
echo ""

services=(
  "eureka-server"
  "config-server"
  "gateway-service"
  "auth-service"
  "catalog-service"
  "order-service"
  "admin-service"
  "payment-service"
  "notification-service"
)

for service in "${services[@]}"; do
  echo "📦 Building $service..."
  cd "$service" || exit
  mvn clean package -DskipTests
  if [ $? -eq 0 ]; then
    echo "✅ $service built successfully"
  else
    echo "❌ $service build failed"
    exit 1
  fi
  cd ..
  echo ""
done

echo "🎉 All services built successfully!"
echo ""
echo "Next steps:"
echo "1. docker-compose build    # Build Docker images"
echo "2. docker-compose up -d    # Start all containers"
