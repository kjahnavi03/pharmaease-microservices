# 🚀 How to Run PharmaEase Project with Docker

## ✅ Prerequisites

Before starting, make sure you have:

1. **Docker Desktop** installed
   - Download from: https://www.docker.com/products/docker-desktop
   - Version: Latest stable version
   
2. **Docker Compose** (included with Docker Desktop)
   - Check version: `docker-compose --version`

3. **Minimum System Requirements:**
   - RAM: 8GB (16GB recommended)
   - Disk Space: 10GB free
   - CPU: 4 cores recommended

---

## 🎯 Quick Start (3 Simple Steps)

### Step 1: Open Terminal in Project Directory

```bash
cd C:\Users\kammi\OneDrive\Desktop\CapGemini Training\pp7\pharmacy-microservices
```

### Step 2: Start All Services

```bash
docker-compose up -d
```

**What this does:**
- Builds all Docker images (first time only - takes 5-10 minutes)
- Starts all 13 containers
- Runs in background (`-d` = detached mode)

### Step 3: Wait for Services to Start

```bash
# Wait 2-3 minutes for all services to initialize
# Then check if all containers are running:
docker-compose ps
```

**Expected Output:**
```
NAME                   STATUS
admin-service          Up
auth-service           Up
catalog-service        Up
config-server          Up
eureka-server          Up
gateway-service        Up
notification-service   Up
order-service          Up
payment-service        Up
pharma-frontend        Up
pharmacy-mysql         Up
pharmacy-rabbitmq      Up
pharmacy-zipkin        Up
```

### Step 4: Access Your Application

Open your browser and go to:
- **Frontend:** http://localhost:4200
- **Eureka Dashboard:** http://localhost:8761
- **RabbitMQ Management:** http://localhost:15672 (guest/guest)
- **Zipkin Tracing:** http://localhost:9411

---

## 📋 Detailed Step-by-Step Guide

### 1️⃣ First Time Setup

#### A. Check Docker Installation

```bash
# Check Docker is installed
docker --version
# Output: Docker version 24.x.x

# Check Docker Compose is installed
docker-compose --version
# Output: Docker Compose version v2.x.x

# Check Docker is running
docker ps
# Should show empty list or running containers
```

#### B. Navigate to Project Directory

```bash
cd "C:\Users\kammi\OneDrive\Desktop\CapGemini Training\pp7\pharmacy-microservices"
```

#### C. Verify docker-compose.yml Exists

```bash
ls docker-compose.yml
# Should show the file
```

---

### 2️⃣ Build and Start Services

#### Option A: Build and Start (Recommended for first time)

```bash
# Build all images and start containers
docker-compose up -d --build
```

**What happens:**
1. Builds Docker images for all 9 backend services
2. Builds Docker image for frontend
3. Pulls MySQL, RabbitMQ, Zipkin images
4. Creates network (pharmacy-net)
5. Creates volume (mysql-data)
6. Starts all 13 containers

**Time:** 5-10 minutes (first time only)

#### Option B: Start Only (if already built)

```bash
# Just start containers (faster)
docker-compose up -d
```

**Time:** 30-60 seconds

---

### 3️⃣ Monitor Startup Progress

#### Check Container Status

```bash
# List all containers
docker-compose ps

# Or use Docker Desktop GUI
# Open Docker Desktop → Containers → pharmacy-microservices
```

#### Watch Logs (Real-time)

```bash
# Watch all logs
docker-compose logs -f

# Watch specific service
docker-compose logs -f eureka-server
docker-compose logs -f gateway-service
docker-compose logs -f auth-service
docker-compose logs -f pharma-frontend

# Press Ctrl+C to stop watching
```

#### Check Service Health

```bash
# Check Eureka (Service Registry)
curl http://localhost:8761

# Check Gateway
curl http://localhost:8888/actuator/health

# Check Frontend
curl http://localhost:4200
```

---

### 4️⃣ Verify Everything is Running

#### A. Check All Containers are Up

```bash
docker-compose ps
```

All containers should show **"Up"** status.

#### B. Check Eureka Dashboard

1. Open browser: http://localhost:8761
2. You should see all services registered:
   - AUTH-SERVICE
   - CATALOG-SERVICE
   - ORDER-SERVICE
   - ADMIN-SERVICE
   - PAYMENT-SERVICE
   - NOTIFICATION-SERVICE
   - GATEWAY-SERVICE

**Wait 1-2 minutes** if services are not showing yet.

#### C. Check Frontend

1. Open browser: http://localhost:4200
2. You should see the PharmaEase home page
3. Try logging in:
   - Email: balajiparise500@gmail.com
   - Password: (your password)

---

### 5️⃣ Import Your Data (If Fresh Database)

If you're starting with a fresh database, import your data:

```bash
# Import all data from local MySQL to Docker MySQL
./migrate-all-data.bat

# Or import individually:
./import-users-to-docker.bat
./import-all-medicines.bat
./compare-and-import-orders.bat
```

---

## 🛠️ Common Commands

### Starting & Stopping

```bash
# Start all services
docker-compose up -d

# Stop all services (keeps data)
docker-compose stop

# Stop and remove containers (keeps data in volumes)
docker-compose down

# Stop and remove everything including volumes (⚠️ DELETES DATA)
docker-compose down -v
```

### Viewing Logs

```bash
# View all logs
docker-compose logs

# View logs for specific service
docker-compose logs auth-service
docker-compose logs order-service
docker-compose logs pharma-frontend

# Follow logs in real-time
docker-compose logs -f gateway-service

# View last 50 lines
docker-compose logs --tail=50 auth-service
```

### Restarting Services

```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart auth-service
docker-compose restart pharma-frontend

# Restart after code changes
docker-compose up -d --build auth-service
```

### Checking Status

```bash
# List running containers
docker-compose ps

# Check resource usage
docker stats

# Check networks
docker network ls

# Check volumes
docker volume ls
```

---

## 🔧 Troubleshooting

### Problem 1: Port Already in Use

**Error:** `Bind for 0.0.0.0:8888 failed: port is already allocated`

**Solution:**
```bash
# Find what's using the port
netstat -ano | findstr :8888

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F

# Or change port in docker-compose.yml
```

### Problem 2: Container Keeps Restarting

**Check logs:**
```bash
docker-compose logs service-name
```

**Common causes:**
- Database not ready yet (wait 1-2 minutes)
- Configuration error
- Port conflict

**Solution:**
```bash
# Restart the service
docker-compose restart service-name

# Or rebuild
docker-compose up -d --build service-name
```

### Problem 3: Cannot Connect to MySQL

**Error:** `Connection refused` or `Unknown database`

**Solution:**
```bash
# Check MySQL is running
docker-compose ps mysql

# Check MySQL logs
docker-compose logs mysql

# Access MySQL shell
docker exec -it pharmacy-mysql mysql -uroot -p"Janu@0307"

# Create databases if missing
docker exec -it pharmacy-mysql mysql -uroot -p"Janu@0307" -e "CREATE DATABASE IF NOT EXISTS auth_db;"
docker exec -it pharmacy-mysql mysql -uroot -p"Janu@0307" -e "CREATE DATABASE IF NOT EXISTS catalog_db;"
docker exec -it pharmacy-mysql mysql -uroot -p"Janu@0307" -e "CREATE DATABASE IF NOT EXISTS order_db;"
docker exec -it pharmacy-mysql mysql -uroot -p"Janu@0307" -e "CREATE DATABASE IF NOT EXISTS admin_db;"
docker exec -it pharmacy-mysql mysql -uroot -p"Janu@0307" -e "CREATE DATABASE IF NOT EXISTS payment_db;"
```

### Problem 4: Frontend Shows 404 or Cannot Connect

**Solution:**
```bash
# Check frontend logs
docker-compose logs pharma-frontend

# Check gateway is running
docker-compose ps gateway-service

# Rebuild frontend
docker-compose up -d --build pharma-frontend

# Clear browser cache and refresh
```

### Problem 5: Services Not Registering with Eureka

**Solution:**
```bash
# Wait 1-2 minutes for registration
# Check Eureka logs
docker-compose logs eureka-server

# Restart the service
docker-compose restart auth-service

# Check service logs
docker-compose logs auth-service | grep "Eureka"
```

### Problem 6: Out of Memory

**Error:** `Cannot allocate memory`

**Solution:**
```bash
# Increase Docker memory in Docker Desktop
# Settings → Resources → Memory → Increase to 8GB

# Or stop some containers
docker-compose stop notification-service
docker-compose stop zipkin
```

---

## 🧹 Cleanup Commands

### Remove Stopped Containers

```bash
docker-compose down
```

### Remove Everything (⚠️ Including Data)

```bash
# Remove containers, networks, volumes
docker-compose down -v

# Remove all unused images
docker image prune -a

# Remove all unused volumes
docker volume prune
```

### Fresh Start

```bash
# Complete cleanup and restart
docker-compose down -v
docker-compose up -d --build
```

---

## 📊 Service Startup Order

Services start in this order (automatically handled by Docker Compose):

1. **Infrastructure** (30 seconds)
   - MySQL
   - RabbitMQ
   - Zipkin

2. **Core Services** (1 minute)
   - Eureka Server
   - Config Server

3. **Gateway** (30 seconds)
   - Gateway Service

4. **Business Services** (1-2 minutes)
   - Auth Service
   - Catalog Service
   - Order Service
   - Admin Service
   - Payment Service
   - Notification Service

5. **Frontend** (30 seconds)
   - Pharma Frontend

**Total Time:** 3-4 minutes for all services to be fully operational

---

## 🎯 Quick Reference

### Essential Commands

| Task | Command |
|------|---------|
| **Start all** | `docker-compose up -d` |
| **Stop all** | `docker-compose stop` |
| **Restart all** | `docker-compose restart` |
| **View logs** | `docker-compose logs -f` |
| **Check status** | `docker-compose ps` |
| **Rebuild** | `docker-compose up -d --build` |
| **Clean up** | `docker-compose down` |

### Important URLs

| Service | URL |
|---------|-----|
| **Frontend** | http://localhost:4200 |
| **Gateway** | http://localhost:8888 |
| **Eureka** | http://localhost:8761 |
| **RabbitMQ** | http://localhost:15672 |
| **Zipkin** | http://localhost:9411 |

### Default Credentials

| Service | Username | Password |
|---------|----------|----------|
| **RabbitMQ** | guest | guest |
| **MySQL** | root | Janu@0307 |
| **App User** | balajiparise500@gmail.com | (your password) |

---

## 🎓 Best Practices

1. **Always use `-d` flag** to run in background
2. **Check logs** if something doesn't work
3. **Wait 3-4 minutes** for all services to start
4. **Don't use `docker-compose down -v`** unless you want to delete data
5. **Rebuild after code changes** using `--build` flag
6. **Monitor resource usage** with `docker stats`
7. **Keep Docker Desktop running** while using containers

---

## 🆘 Need Help?

### Check Logs First

```bash
# View all logs
docker-compose logs

# View specific service
docker-compose logs auth-service

# Follow logs in real-time
docker-compose logs -f gateway-service
```

### Common Issues

1. **Services not starting:** Wait 3-4 minutes
2. **Port conflicts:** Change ports in docker-compose.yml
3. **Memory issues:** Increase Docker memory in settings
4. **Database issues:** Check MySQL logs and create databases
5. **Frontend 404:** Rebuild frontend container

---

## ✅ Success Checklist

After running `docker-compose up -d`, verify:

- [ ] All 13 containers are running (`docker-compose ps`)
- [ ] Eureka shows all services (http://localhost:8761)
- [ ] Frontend loads (http://localhost:4200)
- [ ] Can login successfully
- [ ] Can browse medicines
- [ ] Can place orders

---

## 🎉 You're Done!

Your PharmaEase application is now running in Docker! 🚀

**Next Steps:**
1. Test all features (login, browse, order, payment)
2. Import your data if needed
3. Monitor logs for any errors
4. Enjoy your containerized application!

---

**Created:** May 5, 2026
**Project:** PharmaEase - Quality Medicines, Delivered Fast
**Docker Compose Version:** 3.8
