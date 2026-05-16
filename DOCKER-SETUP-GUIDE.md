# 🐳 Complete Docker Setup Guide for PharmaEase

## 📋 Prerequisites

- Docker Desktop installed and running
- At least 8GB RAM allocated to Docker
- At least 20GB free disk space

---

## 🚀 Quick Start (One Command)

```bash
# Build and start everything
docker-compose up --build -d
```

---

## 📝 Step-by-Step Guide

### **Step 1: Build All Backend Services**

```bash
# Build each service JAR file
cd auth-service && mvn clean package -DskipTests && cd ..
cd admin-service && mvn clean package -DskipTests && cd ..
cd catalog-service && mvn clean package -DskipTests && cd ..
cd order-service && mvn clean package -DskipTests && cd ..
cd payment-service && mvn clean package -DskipTests && cd ..
cd notification-service && mvn clean package -DskipTests && cd ..
cd gateway-service && mvn clean package -DskipTests && cd ..
cd eureka-server && mvn clean package -DskipTests && cd ..
cd config-server && mvn clean package -DskipTests && cd ..
```

**Or use this single command:**

```bash
for service in auth-service admin-service catalog-service order-service payment-service notification-service gateway-service eureka-server config-server; do
  cd $service && mvn clean package -DskipTests && cd ..
done
```

---

### **Step 2: Build Docker Images**

```bash
# Build all images using docker-compose
docker-compose build
```

**This will create images for:**
- ✅ eureka-server
- ✅ config-server
- ✅ gateway-service
- ✅ auth-service
- ✅ catalog-service
- ✅ order-service
- ✅ admin-service
- ✅ payment-service
- ✅ notification-service
- ✅ frontend (Angular + Nginx)

---

### **Step 3: Start All Services**

```bash
# Start all containers in detached mode
docker-compose up -d
```

---

### **Step 4: Check Status**

```bash
# View running containers
docker-compose ps

# View logs of all services
docker-compose logs -f

# View logs of specific service
docker logs notification-service
docker logs gateway-service
docker logs mysql
```

---

## 🔍 Service URLs

Once everything is running:

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:4200 | Angular app (run separately) |
| **Gateway** | http://localhost:8888 | API Gateway |
| **Eureka** | http://localhost:8761 | Service Registry |
| **RabbitMQ** | http://localhost:15672 | Message Queue (guest/guest) |
| **Zipkin** | http://localhost:9411 | Distributed Tracing |
| **MySQL** | localhost:3307 | Database |

---

## 🗄️ Database Setup

### **Create Databases**

```bash
# Connect to MySQL container
docker exec -it pharmacy-mysql mysql -uroot -p"Janu@0307"

# Create databases
CREATE DATABASE IF NOT EXISTS auth_db;
CREATE DATABASE IF NOT EXISTS catalog_db;
CREATE DATABASE IF NOT EXISTS order_db;
CREATE DATABASE IF NOT EXISTS admin_db;
CREATE DATABASE IF NOT EXISTS payment_db;

# Exit MySQL
exit;
```

---

## 🎨 Frontend Setup

The frontend **IS NOW DOCKERIZED** and runs automatically with docker-compose!

```bash
# Frontend runs automatically when you start Docker
docker-compose up -d

# Access at http://localhost:4200
```

**Note:** The frontend container uses Nginx to serve the Angular app and proxy API requests to the gateway service.

---

## 🔄 Common Commands

### **Restart Specific Service**

```bash
# Rebuild and restart one service
docker-compose up -d --build notification-service
```

### **Stop All Services**

```bash
docker-compose down
```

### **Stop and Remove Volumes (Clean Start)**

```bash
docker-compose down -v
```

### **View Logs**

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f notification-service

# Last 100 lines
docker-compose logs --tail=100 order-service
```

### **Rebuild After Code Changes**

```bash
# Example: After changing order-service code
cd order-service
mvn clean package -DskipTests
cd ..
docker-compose up -d --build order-service
```

---

## 🐛 Troubleshooting

### **Problem: No medicines showing in frontend**

**Cause:** Docker created a fresh MySQL database. Your local MySQL medicines were not automatically copied.

**Solution:**
```bash
# Run the complete fix script
fix-medicines-complete.bat

# Or follow manual steps:
# 1. Export from local MySQL
export-local-medicines.bat

# 2. Import to Docker MySQL
import-medicines-to-docker.bat

# 3. Rebuild frontend
rebuild-frontend.bat
```

**See:** `MEDICINES-ISSUE-EXPLAINED.md` for detailed explanation.

---

### **Problem: Services not starting**

```bash
# Check logs
docker-compose logs

# Check if ports are already in use
netstat -ano | findstr :8888
netstat -ano | findstr :3307
```

### **Problem: MySQL connection refused**

```bash
# Wait for MySQL to be ready (takes 30-60 seconds)
docker logs pharmacy-mysql

# Restart dependent services
docker-compose restart auth-service catalog-service order-service
```

### **Problem: Out of memory**

```bash
# Increase Docker memory in Docker Desktop settings
# Recommended: 8GB RAM minimum
```

### **Problem: Email not sending**

```bash
# Check notification-service logs
docker logs notification-service

# Verify environment variables
docker exec notification-service env | grep MAIL
```

---

## 📊 Service Startup Order

Docker Compose handles this automatically, but here's the order:

1. **Infrastructure** (MySQL, RabbitMQ, Zipkin)
2. **Eureka Server** (Service Registry)
3. **Config Server** (Configuration)
4. **Gateway Service** (API Gateway)
5. **Business Services** (Auth, Catalog, Order, Admin, Payment, Notification)

---

## 🔐 Environment Variables

All configured in `docker-compose.yml`:

- **Database:** `DB_HOST`, `DB_USER`, `DB_PASS`
- **Eureka:** `EUREKA_HOST`
- **RabbitMQ:** `RABBITMQ_HOST`
- **Zipkin:** `ZIPKIN_HOST`
- **Email:** `MAIL_ENABLED`, `MAIL_USERNAME`, `MAIL_PASSWORD`

---

## 📦 What's Included

### **Dockerized:**
- ✅ All 9 backend microservices
- ✅ Frontend (Angular + Nginx)
- ✅ MySQL database
- ✅ RabbitMQ message broker
- ✅ Zipkin tracing
- ✅ Eureka service registry

**Everything runs with one command: `docker-compose up -d`**

---

## 🎯 Production Deployment

For production, you would:

1. **Build optimized images:**
   ```bash
   docker-compose -f docker-compose.prod.yml build
   ```

2. **Use environment-specific configs:**
   - Separate `.env` files
   - External database (not in Docker)
   - Load balancer for gateway

3. **Use Docker Swarm or Kubernetes** for orchestration

---

## 📝 Quick Reference

```bash
# Start everything
docker-compose up -d

# Stop everything
docker-compose down

# Rebuild specific service
docker-compose up -d --build <service-name>

# View logs
docker-compose logs -f <service-name>

# Restart service
docker-compose restart <service-name>

# Remove everything including volumes
docker-compose down -v

# Check status
docker-compose ps
```

---

## ✅ Verification Checklist

After starting:

- [ ] All containers running: `docker-compose ps`
- [ ] Eureka shows all services: http://localhost:8761
- [ ] Gateway accessible: http://localhost:8888
- [ ] RabbitMQ accessible: http://localhost:15672
- [ ] MySQL accessible: `docker exec -it pharmacy-mysql mysql -uroot -p`
- [ ] Frontend running: http://localhost:4200
- [ ] Can login and place order
- [ ] Email notifications working

---

## 🆘 Need Help?

Check logs first:
```bash
docker-compose logs -f
```

Common issues are usually:
1. MySQL not ready yet (wait 60 seconds)
2. Port conflicts (check if ports are free)
3. Memory issues (increase Docker RAM)
4. Email config wrong (check notification-service logs)

---

**Your project is now fully Dockerized! 🎉**
