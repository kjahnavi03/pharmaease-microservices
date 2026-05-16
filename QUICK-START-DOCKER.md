# 🚀 Quick Start - Dockerize PharmaEase

## ⚡ 3 Simple Steps to Run Your Complete Application

### Step 1: Build Everything (5-10 minutes)
```bash
build-all-with-frontend.bat
```
**What it does:** Builds all backend services + frontend production bundle

---

### Step 2: Create Docker Images (10-15 minutes first time)
```bash
docker-compose build
```
**What it does:** Creates Docker containers for all services

---

### Step 3: Start Everything (1 minute)
```bash
docker-compose up -d
```
**What it does:** Starts all services in background

---

## ✅ Verify It's Working

### Check Status
```bash
docker-compose ps
```
All services should show "Up"

### Access Your Application
- **PharmaEase App**: http://localhost:4200
- **Eureka Dashboard**: http://localhost:8761
- **RabbitMQ**: http://localhost:15672 (guest/guest)

---

## 🔧 Common Commands

```bash
# View logs
docker-compose logs -f

# Stop everything
docker-compose down

# Restart a service
docker-compose restart frontend

# Fresh start (deletes database!)
docker-compose down -v
docker-compose up -d
```

---

## 🆘 Troubleshooting

### Build Failed?
```bash
# Check Java version
java -version  # Should be 17+

# Check Maven
mvn -version

# Check Node
node -version  # Should be 18+
```

### Container Won't Start?
```bash
# Check logs
docker-compose logs <service-name>

# Example
docker-compose logs frontend
docker-compose logs gateway-service
```

### Port Already in Use?
```bash
# Check what's using the port
netstat -ano | findstr :4200
netstat -ano | findstr :8888

# Stop the process or change port in docker-compose.yml
```

---

## 📝 What Changed in Your Project?

### Files Modified
1. ✅ `pharma-frontend/angular.json` - Increased CSS budget limit
2. ✅ `docker-compose.yml` - Added frontend service
3. ✅ `notification-service/application.yml` - Email configuration

### Files Created
1. ✅ `pharma-frontend/Dockerfile` - Frontend Docker build
2. ✅ `pharma-frontend/nginx.conf` - Web server config
3. ✅ `pharma-frontend/.dockerignore` - Docker ignore rules
4. ✅ `build-all-with-frontend.bat` - Build script

### Your Source Code
- ❌ **NOT MODIFIED** - All your code is safe!
- ✅ Docker only uses **copies** of built files
- ✅ You can still edit and develop normally

---

## 🎯 After Dockerization

### Making Frontend Changes
1. Edit your code in `pharma-frontend/src/`
2. Rebuild:
   ```bash
   cd pharma-frontend
   npm run build -- --configuration production
   cd ..
   docker-compose build frontend
   docker-compose up -d frontend
   ```

### Making Backend Changes
1. Edit your code (e.g., `auth-service/src/`)
2. Rebuild:
   ```bash
   cd auth-service
   mvn clean package -DskipTests
   cd ..
   docker-compose build auth-service
   docker-compose up -d auth-service
   ```

---

## 🛡️ Safety Notes

- ✅ Everything runs **locally** on your computer
- ✅ Nothing is uploaded to the internet
- ✅ Your source code is **never modified**
- ✅ You can stop Docker anytime: `docker-compose down`
- ✅ You can go back to `npm start` if needed

---

## 📚 Need More Details?

Read **DOCKER-EXPLAINED.md** for:
- Complete explanation of how Docker works
- Detailed troubleshooting
- Understanding the architecture
- Safety and security information
- Managing old Docker images

---

**Ready? Let's go!** 🚀

```bash
build-all-with-frontend.bat
docker-compose build
docker-compose up -d
```

Then open: http://localhost:4200
