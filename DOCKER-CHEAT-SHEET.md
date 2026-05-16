# 🚀 Docker Cheat Sheet - PharmaEase

## 📍 Project Location
```
C:\Users\kammi\OneDrive\Desktop\CapGemini Training\pp7\pharmacy-microservices
```

---

## 🔄 After Laptop Restart (Every Day)

### Quick Start (3 Steps)
```bash
# 1. Open Docker Desktop (wait for green icon)

# 2. Open PowerShell and navigate to project
cd "C:\Users\kammi\OneDrive\Desktop\CapGemini Training\pp7\pharmacy-microservices"

# 3. Start containers
docker-compose up -d
```

### Then Open Browser
```
http://localhost:4200
```

---

## 🎯 Essential Commands

### Start Application
```bash
docker-compose up -d
```

### Stop Application
```bash
docker-compose down
```

### Check Status
```bash
docker-compose ps
```

### View Logs
```bash
docker-compose logs -f
```

### Restart Everything
```bash
docker-compose restart
```

---

## 🔧 After Making Code Changes

### Frontend Changes
```bash
cd pharma-frontend
npm run build -- --configuration production
cd ..
docker-compose build frontend
docker-compose up -d frontend
```

### Backend Changes (Example: auth-service)
```bash
cd auth-service
mvn clean package -DskipTests
cd ..
docker-compose build auth-service
docker-compose up -d auth-service
```

---

## 🐛 Quick Fixes

### Container Won't Start
```bash
docker-compose logs <service-name>
docker-compose restart <service-name>
```

### Fresh Start (Deletes Data!)
```bash
docker-compose down -v
docker-compose up -d
```

### Clean Up Disk Space
```bash
docker system prune -a
```

---

## 📊 Access Points

| What | URL |
|------|-----|
| **App** | http://localhost:4200 |
| **Admin** | http://localhost:4200/admin |
| **Eureka** | http://localhost:8761 |
| **RabbitMQ** | http://localhost:15672 |

---

## 💾 Database Info

- **Host:** localhost:3307
- **User:** root
- **Password:** Janu@0307
- **Data Location:** Docker volume `mysql-data`

---

## ⚠️ Important Notes

✅ **First time setup is DONE** - you don't need to rebuild unless you change code

✅ **Data persists** - stopping containers doesn't delete data

✅ **Auto-start** - enable in Docker Desktop settings for convenience

❌ **Don't use** `docker-compose down -v` unless you want to delete all data

---

## 🆘 Emergency Reset

```bash
docker-compose down -v
docker-compose build
docker-compose up -d
```

⚠️ **Deletes all data!**

---

**Print this and keep it handy!** 📄
