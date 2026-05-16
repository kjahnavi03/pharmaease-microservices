# 🐳 Complete Docker Guide - PharmaEase (Backend + Frontend)

## 📦 What's Fully Dockerized Now

### **✅ Everything is Dockerized:**
- ✅ All 9 backend microservices
- ✅ **Frontend (Angular)** - NEW!
- ✅ MySQL database
- ✅ RabbitMQ message broker
- ✅ Zipkin tracing

**You can now run the ENTIRE application with ONE command!**

---

## 🚀 Quick Start (2 Commands)

```bash
# 1. Build everything (backend + frontend)
build-all-with-frontend.bat

# 2. Start everything
docker-compose up -d
```

**Access:** http://localhost:4200

---

## 📁 New Files Created for Frontend

### **1. `pharma-frontend/Dockerfile`**
**Purpose:** Instructions to build frontend Docker image

**What it does:**
- Stage 1: Builds Angular app with Node.js
- Stage 2: Serves built app with Nginx web server

**Multi-stage build benefits:**
- Smaller final image (only ~50MB)
- Production-optimized
- Fast and secure

### **2. `pharma-frontend/nginx.conf`**
**Purpose:** Nginx web server configuration

**What it does:**
- Serves Angular app on port 80
- Handles Angular routing (SPA)
- Proxies API calls to gateway-service
- Enables gzip compression
- Sets security headers
- Caches static assets

### **3. `pharma-frontend/.dockerignore`**
**Purpose:** Tells Docker what files to ignore

**What it ignores:**
- node_modules/ (will be installed fresh)
- dist/ (will be built fresh)
- IDE files
- Git files

### **4. `build-all-with-frontend.bat`**
**Purpose:** Build script for backend + frontend

**What it does:**
- Builds all 9 backend services
- Installs frontend dependencies
- Builds frontend for production
- Creates optimized bundles

---

## 🔧 How Frontend Docker Works

### **Build Process:**

```
1. Docker reads pharma-frontend/Dockerfile
   ↓
2. Stage 1: Build Angular App
   - Uses Node.js 18 image
   - Runs npm install
   - Runs ng build --configuration production
   - Creates optimized bundles in dist/
   ↓
3. Stage 2: Serve with Nginx
   - Uses lightweight Nginx image
   - Copies built files from Stage 1
   - Copies nginx.conf
   - Exposes port 80
   ↓
4. Final image is created (~50MB)
```

### **Runtime:**

```
1. Container starts
   ↓
2. Nginx web server starts
   ↓
3. Serves Angular app on port 80
   ↓
4. Docker maps port 80 → 4200 on your computer
   ↓
5. You access: http://localhost:4200
```

---

## 🌐 How API Calls Work in Docker

### **Without Docker (Development):**
```
Frontend (localhost:4200)
    ↓
Angular proxy.conf.json
    ↓
Gateway (localhost:8888)
```

### **With Docker (Production):**
```
Browser (localhost:4200)
    ↓
Nginx (inside frontend container)
    ↓
Gateway (gateway-service:8888 - Docker network)
```

**Nginx configuration handles this automatically!**

---

## 📝 Complete Build & Start Process

### **Step 1: Build All Services**

```bash
build-all-with-frontend.bat
```

**What happens:**
```
✅ Builds eureka-server JAR
✅ Builds config-server JAR
✅ Builds gateway-service JAR
✅ Builds auth-service JAR
✅ Builds catalog-service JAR
✅ Builds order-service JAR
✅ Builds admin-service JAR
✅ Builds payment-service JAR
✅ Builds notification-service JAR
✅ Installs frontend dependencies
✅ Builds frontend production bundle
```

**Time:** 5-10 minutes (first time)

### **Step 2: Build Docker Images**

```bash
docker-compose build
```

**What happens:**
```
✅ Creates eureka-server image
✅ Creates config-server image
✅ Creates gateway-service image
✅ Creates auth-service image
✅ Creates catalog-service image
✅ Creates order-service image
✅ Creates admin-service image
✅ Creates payment-service image
✅ Creates notification-service image
✅ Creates pharma-frontend image (NEW!)
```

**Time:** 5-10 minutes (first time)

### **Step 3: Start All Containers**

```bash
docker-compose up -d
```

**What happens:**
```
✅ Starts MySQL container
✅ Starts RabbitMQ container
✅ Starts Zipkin container
✅ Starts Eureka Server
✅ Starts Config Server
✅ Starts Gateway Service
✅ Starts all 6 business services
✅ Starts Frontend container (NEW!)
```

**Time:** 30-60 seconds

---

## 🔍 Verify Everything is Running

### **1. Check All Containers**

```bash
docker-compose ps
```

**Expected output:**
```
NAME                    STATUS
pharmacy-mysql          Up
pharmacy-rabbitmq       Up
pharmacy-zipkin         Up
eureka-server           Up
config-server           Up
gateway-service         Up
auth-service            Up
catalog-service         Up
order-service           Up
admin-service           Up
payment-service         Up
notification-service    Up
pharma-frontend         Up  ← NEW!
```

### **2. Check Frontend Logs**

```bash
docker logs pharma-frontend
```

**Expected output:**
```
/docker-entrypoint.sh: Configuration complete; ready for start up
```

### **3. Access Frontend**

Open browser: http://localhost:4200

**You should see:** PharmaEase home page

---

## 🔄 Development Workflow

### **Backend Code Changed:**

```bash
# Example: Changed order-service code
cd order-service
mvn clean package -DskipTests
cd ..
docker-compose up -d --build order-service
```

### **Frontend Code Changed:**

```bash
# Rebuild frontend
cd pharma-frontend
npm run build -- --configuration production
cd ..
docker-compose up -d --build frontend
```

**Or rebuild everything:**

```bash
build-all-with-frontend.bat
docker-compose up -d --build
```

---

## 📊 Port Mapping

| Service | Container Port | Host Port | Access URL |
|---------|---------------|-----------|------------|
| **Frontend** | 80 | 4200 | http://localhost:4200 |
| **Gateway** | 8888 | 8888 | http://localhost:8888 |
| **Eureka** | 8761 | 8761 | http://localhost:8761 |
| **MySQL** | 3306 | 3307 | localhost:3307 |
| **RabbitMQ** | 5672 | 5672 | localhost:5672 |
| **RabbitMQ Mgmt** | 15672 | 15672 | http://localhost:15672 |
| **Zipkin** | 9411 | 9411 | http://localhost:9411 |

---

## 🐛 Troubleshooting

### **Frontend not loading?**

```bash
# Check frontend logs
docker logs pharma-frontend

# Check if container is running
docker ps | grep pharma-frontend

# Restart frontend
docker-compose restart frontend
```

### **API calls failing?**

```bash
# Check gateway logs
docker logs gateway-service

# Check nginx configuration
docker exec pharma-frontend cat /etc/nginx/conf.d/default.conf

# Check if gateway is accessible from frontend container
docker exec pharma-frontend ping gateway-service
```

### **Build failed?**

```bash
# Clean everything
docker-compose down -v
docker system prune -a

# Rebuild from scratch
build-all-with-frontend.bat
docker-compose build --no-cache
docker-compose up -d
```

---

## 🎯 Production Deployment

### **Environment Variables:**

Create `.env` file:

```env
# Frontend
FRONTEND_PORT=80

# Gateway
GATEWAY_URL=http://your-domain.com:8888

# Database
DB_HOST=your-db-host
DB_USER=your-db-user
DB_PASS=your-db-password

# Email
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
```

### **HTTPS/SSL:**

Update `nginx.conf`:

```nginx
server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    # ... rest of config
}
```

---

## 📝 Common Commands

```bash
# Start everything
docker-compose up -d

# Stop everything
docker-compose down

# View all logs
docker-compose logs -f

# View frontend logs only
docker logs pharma-frontend -f

# Restart frontend
docker-compose restart frontend

# Rebuild frontend
docker-compose up -d --build frontend

# Clean everything
docker-compose down -v
docker system prune -a

# Check frontend inside container
docker exec -it pharma-frontend sh
ls /usr/share/nginx/html
cat /etc/nginx/conf.d/default.conf
```

---

## ✅ Benefits of Dockerized Frontend

### **Before (Manual):**
- ❌ Need Node.js installed
- ❌ Need to run `ng serve`
- ❌ Development server (slow)
- ❌ Not production-ready
- ❌ Separate terminal needed

### **After (Docker):**
- ✅ No Node.js needed on host
- ✅ Starts automatically
- ✅ Production build (fast)
- ✅ Production-ready with Nginx
- ✅ Everything in one command

---

## 🎉 Summary

**Your ENTIRE application is now fully Dockerized!**

### **What You Have:**
- ✅ 9 backend microservices in Docker
- ✅ Frontend in Docker with Nginx
- ✅ MySQL database in Docker
- ✅ RabbitMQ in Docker
- ✅ Zipkin in Docker

### **How to Run:**
```bash
build-all-with-frontend.bat
docker-compose up -d
```

### **How to Access:**
http://localhost:4200

**That's it! Everything runs with ONE command! 🚀**

---

## 📚 Additional Resources

- **Quick Start:** `QUICK-START.md`
- **Docker Setup:** `DOCKER-SETUP-GUIDE.md`
- **Project Overview:** `README-DOCKER.md`

---

**Your application is production-ready and fully containerized! 🎉**
