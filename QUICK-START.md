# ⚡ Quick Start Guide - PharmaEase Docker

## 🎯 Complete Setup in 2 Commands

```bash
# 1. Build all services (backend + frontend)
build-all-with-frontend.bat

# 2. Start everything with Docker
docker-compose up -d
```

**That's it! Your ENTIRE application is now running in Docker.**

---

## 🌐 Access Your Application

- **Frontend:** http://localhost:4200
- **Admin Panel:** http://localhost:4200/admin/dashboard
- **API Gateway:** http://localhost:8888
- **Eureka Dashboard:** http://localhost:8761
- **RabbitMQ Management:** http://localhost:15672 (guest/guest)

---

## 👤 Test Accounts

### **Customer Account:**
- Email: `customer@test.com`
- Password: `password123`

### **Admin Account:**
- Email: `admin@pharma.com`
- Password: `admin123`

---

## ✅ Verify Everything is Working

### **1. Check Docker Containers**
```bash
docker-compose ps
```
All services should show "Up" status (including pharma-frontend).

### **2. Check Eureka Dashboard**
Visit http://localhost:8761

You should see all 9 backend services registered.

### **3. Test the Application**

1. **Open Frontend:** http://localhost:4200
2. **Register/Login** as customer
3. **Browse Medicines**
4. **Add to Cart**
5. **Place Order**
6. **Check Email** (you should receive notification!)

---

## 🛑 Stop Everything

```bash
# Stop all containers (including frontend)
docker-compose down
```

---

## 🔄 Restart After Code Changes

### **Backend Service Changed:**
```bash
# Example: order-service changed
cd order-service
mvn clean package -DskipTests
cd ..
docker-compose up -d --build order-service
```

### **Frontend Changed:**
```bash
# Rebuild frontend
cd pharma-frontend
npm run build -- --configuration production
cd ..
docker-compose up -d --build frontend
```

---

## 📊 View Logs

```bash
# All services (including frontend)
docker-compose logs -f

# Specific service
docker logs pharma-frontend
docker logs notification-service
docker logs gateway-service
docker logs order-service
```

---

## 🐛 Troubleshooting

### **Services not starting?**
```bash
# Check logs
docker-compose logs

# Wait for MySQL (takes 30-60 seconds)
docker logs pharmacy-mysql
```

### **Frontend not loading?**
```bash
# Check frontend logs
docker logs pharma-frontend

# Check if port 4200 is free
netstat -ano | findstr :4200
```

### **Port already in use?**
```bash
# Check what's using the port
netstat -ano | findstr :8888
netstat -ano | findstr :3307
netstat -ano | findstr :4200

# Kill the process or change port in docker-compose.yml
```

### **Email not working?**
```bash
# Check notification-service logs
docker logs notification-service

# Verify email config
docker exec notification-service env | grep MAIL
```

---

## 📝 Common Commands

```bash
# Start everything
docker-compose up -d

# Stop everything
docker-compose down

# Restart specific service
docker-compose restart order-service

# Rebuild and restart
docker-compose up -d --build notification-service

# View logs
docker-compose logs -f notification-service

# Clean everything (including database)
docker-compose down -v

# Rebuild everything from scratch
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

---

## 🎉 You're All Set!

Your **COMPLETE** microservices application (backend + frontend) is now running in Docker!

**What's Dockerized:**
- ✅ All 9 backend microservices
- ✅ Frontend (Angular)
- ✅ MySQL database
- ✅ RabbitMQ message broker
- ✅ Zipkin tracing

**Everything runs with ONE command!**

**Next Steps:**
1. Test all features
2. Check email notifications
3. Explore admin panel
4. Monitor services in Eureka

**Need detailed info?** Check `DOCKER-SETUP-GUIDE.md`
