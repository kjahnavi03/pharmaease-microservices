# 🐳 Complete Docker Usage Guide - PharmaEase

## 📋 Table of Contents
1. [First Time Setup (Already Done!)](#first-time-setup)
2. [Daily Usage - After Laptop Restart](#daily-usage)
3. [Common Commands](#common-commands)
4. [Troubleshooting](#troubleshooting)
5. [Making Code Changes](#making-changes)
6. [Stopping the Application](#stopping)

---

## ✅ First Time Setup (Already Done!) {#first-time-setup}

You've already completed these steps:

### Step 1: Build All Services ✅
```bash
build-all-with-frontend.bat
```

### Step 2: Build Docker Images ✅
```bash
docker-compose build
```

### Step 3: Start Containers ✅
```bash
docker-compose up -d
```

**You don't need to repeat these steps unless you make code changes!**

---

## 🔄 Daily Usage - After Laptop Restart {#daily-usage}

### When You Restart Your Laptop

**Option 1: Containers Auto-Start (If Docker Desktop is set to auto-start)**
1. Open Docker Desktop
2. Wait 30 seconds for Docker to start
3. Your containers will automatically start
4. Open browser: http://localhost:4200

**Option 2: Manually Start Containers**
1. Open Docker Desktop
2. Open PowerShell or Command Prompt
3. Navigate to project folder:
   ```powershell
   cd "C:\Users\kammi\OneDrive\Desktop\CapGemini Training\pp7\pharmacy-microservices"
   ```
4. Start containers:
   ```bash
   docker-compose up -d
   ```
5. Open browser: http://localhost:4200

---

## 📝 Common Commands {#common-commands}

### Check if Containers are Running
```bash
docker-compose ps
```

**Expected Output:**
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
pharma-frontend         Up
```

---

### Start All Containers
```bash
docker-compose up -d
```
- `-d` means "detached mode" (runs in background)
- Takes 30-60 seconds to start all services

---

### Stop All Containers
```bash
docker-compose down
```
- Stops all containers
- **Does NOT delete your data** (database is preserved)

---

### Stop and Delete Everything (Fresh Start)
```bash
docker-compose down -v
```
- Stops all containers
- **Deletes database data** (use only if you want to start fresh)
- ⚠️ **Warning:** You'll lose all users, orders, medicines data!

---

### View Logs

**All services:**
```bash
docker-compose logs
```

**Specific service:**
```bash
docker-compose logs frontend
docker-compose logs gateway-service
docker-compose logs auth-service
```

**Follow logs in real-time:**
```bash
docker-compose logs -f frontend
```
Press `Ctrl+C` to stop following

---

### Restart a Specific Service
```bash
docker-compose restart frontend
docker-compose restart gateway-service
```

---

### Check Docker Images
```bash
docker images
```

Shows all Docker images on your computer

---

### Check Running Containers
```bash
docker ps
```

Shows all currently running containers

---

### Check All Containers (Running + Stopped)
```bash
docker ps -a
```

---

## 🔧 Making Code Changes {#making-changes}

### If You Change Frontend Code (HTML, CSS, TypeScript)

1. **Make your changes** in `pharma-frontend/src/`

2. **Rebuild frontend:**
   ```bash
   cd pharma-frontend
   npm run build -- --configuration production
   cd ..
   ```

3. **Rebuild Docker image:**
   ```bash
   docker-compose build frontend
   ```

4. **Restart container:**
   ```bash
   docker-compose up -d frontend
   ```

5. **Refresh browser** (Ctrl+F5)

---

### If You Change Backend Code (Java)

**Example: Changing auth-service**

1. **Make your changes** in `auth-service/src/`

2. **Rebuild service:**
   ```bash
   cd auth-service
   mvn clean package -DskipTests
   cd ..
   ```

3. **Rebuild Docker image:**
   ```bash
   docker-compose build auth-service
   ```

4. **Restart container:**
   ```bash
   docker-compose up -d auth-service
   ```

---

### If You Change Configuration

**Example: Changing email settings**

1. **Edit** `notification-service/src/main/resources/application.yml`

2. **Rebuild and restart:**
   ```bash
   cd notification-service
   mvn clean package -DskipTests
   cd ..
   docker-compose build notification-service
   docker-compose up -d notification-service
   ```

---

## 🛑 Stopping the Application {#stopping}

### Before Shutting Down Laptop

**Option 1: Leave Containers Running (Recommended)**
- Just close your laptop
- Docker will pause containers
- They'll resume when you restart

**Option 2: Stop Containers (Saves Resources)**
```bash
docker-compose down
```
- Stops all containers
- Frees up memory and CPU
- Data is preserved

**Option 3: Stop Docker Desktop**
- Close Docker Desktop application
- All containers stop automatically

---

## 🐛 Troubleshooting {#troubleshooting}

### Problem: "Cannot connect to Docker daemon"

**Solution:**
1. Open Docker Desktop
2. Wait for it to fully start (green icon in system tray)
3. Try your command again

---

### Problem: Port Already in Use

**Error:** `port is already allocated`

**Solution:**
```bash
# Stop all containers
docker-compose down

# Check what's using the port
netstat -ano | findstr :4200

# Kill the process or restart your computer
```

---

### Problem: Container Won't Start

**Check logs:**
```bash
docker-compose logs <service-name>
```

**Example:**
```bash
docker-compose logs frontend
docker-compose logs gateway-service
```

**Restart the service:**
```bash
docker-compose restart <service-name>
```

---

### Problem: Frontend Shows "Cannot connect to backend"

**Check if gateway is running:**
```bash
docker-compose ps gateway-service
```

**Check gateway logs:**
```bash
docker-compose logs gateway-service
```

**Restart gateway:**
```bash
docker-compose restart gateway-service
```

---

### Problem: Database Connection Error

**Check if MySQL is running:**
```bash
docker-compose ps mysql
```

**Restart MySQL:**
```bash
docker-compose restart mysql
```

**Fresh start (deletes data!):**
```bash
docker-compose down -v
docker-compose up -d
```

---

### Problem: Application is Slow

**Check resource usage:**
```bash
docker stats
```

**Restart all containers:**
```bash
docker-compose restart
```

---

### Problem: "Out of disk space"

**Clean up unused Docker resources:**
```bash
# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Remove everything unused
docker system prune -a
```

⚠️ **Warning:** This will delete unused Docker images and volumes!

---

## 📊 Useful URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| **PharmaEase App** | http://localhost:4200 | Your user accounts |
| **Admin Panel** | http://localhost:4200/admin | Admin credentials |
| **Eureka Dashboard** | http://localhost:8761 | - |
| **RabbitMQ Management** | http://localhost:15672 | guest / guest |
| **Zipkin Tracing** | http://localhost:9411 | - |

---

## 🎯 Quick Reference Card

### Every Day Workflow

```bash
# 1. Open Docker Desktop (wait for it to start)

# 2. Open PowerShell/Command Prompt

# 3. Navigate to project
cd "C:\Users\kammi\OneDrive\Desktop\CapGemini Training\pp7\pharmacy-microservices"

# 4. Start containers (if not auto-started)
docker-compose up -d

# 5. Check status
docker-compose ps

# 6. Open browser
# Go to http://localhost:4200

# 7. When done, stop containers (optional)
docker-compose down
```

---

## 🔄 Complete Restart Procedure

If something goes wrong and you want to start fresh:

```bash
# 1. Stop everything
docker-compose down -v

# 2. Rebuild everything
docker-compose build

# 3. Start everything
docker-compose up -d

# 4. Check status
docker-compose ps

# 5. Open browser
# Go to http://localhost:4200
```

⚠️ **Warning:** This deletes all database data!

---

## 📱 Docker Desktop GUI

### How to Use Docker Desktop

1. **Open Docker Desktop** from Start Menu

2. **Containers Tab:**
   - See all running containers
   - Start/Stop containers with buttons
   - View logs by clicking on container

3. **Images Tab:**
   - See all Docker images
   - Delete unused images

4. **Volumes Tab:**
   - See data volumes
   - `mysql-data` contains your database

5. **Settings:**
   - Resources: Adjust CPU/Memory for Docker
   - General: Enable "Start Docker Desktop when you log in"

---

## 🎓 Understanding Docker Concepts

### What is a Container?
- A running instance of your application
- Like a lightweight virtual machine
- Isolated from other containers
- Can be started/stopped/restarted

### What is an Image?
- A template for creating containers
- Contains your code + dependencies
- Built once, run many times
- Like a snapshot of your application

### What is a Volume?
- Persistent storage for data
- Survives container restarts
- `mysql-data` stores your database

### What is docker-compose?
- Tool to manage multiple containers
- Defined in `docker-compose.yml`
- Start/stop all services together

---

## 💡 Pro Tips

### Tip 1: Enable Auto-Start
In Docker Desktop Settings:
- ✅ Enable "Start Docker Desktop when you log in"
- Your containers will auto-start when you restart laptop

### Tip 2: Use Docker Desktop GUI
- Easier than command line for beginners
- Visual feedback on container status
- One-click start/stop

### Tip 3: Check Logs First
When something doesn't work:
```bash
docker-compose logs <service-name>
```
Logs usually tell you what's wrong

### Tip 4: Restart Fixes Most Issues
```bash
docker-compose restart
```
Restarts all containers, often fixes issues

### Tip 5: Keep Docker Desktop Running
- Leave Docker Desktop running in background
- Containers will be ready when you need them

---

## 🆘 Emergency Commands

### Everything is Broken - Nuclear Option
```bash
# Stop everything
docker-compose down -v

# Remove all images
docker system prune -a

# Rebuild from scratch
build-all-with-frontend.bat
docker-compose build
docker-compose up -d
```

⚠️ **Warning:** This deletes EVERYTHING and rebuilds from scratch!

---

## 📞 Quick Help

### Container won't start?
```bash
docker-compose logs <service-name>
docker-compose restart <service-name>
```

### Can't access application?
```bash
docker-compose ps
# Check all containers show "Up"
```

### Made code changes?
```bash
# Rebuild the changed service
docker-compose build <service-name>
docker-compose up -d <service-name>
```

### Want to start fresh?
```bash
docker-compose down -v
docker-compose up -d
```

---

## 🎉 Summary

### First Time (Done!)
1. ✅ `build-all-with-frontend.bat`
2. ✅ `docker-compose build`
3. ✅ `docker-compose up -d`

### Every Day After Laptop Restart
1. Open Docker Desktop
2. `docker-compose up -d` (if not auto-started)
3. Open http://localhost:4200

### When Done for the Day
1. `docker-compose down` (optional)
2. Or just close laptop (containers pause automatically)

### Making Changes
1. Edit code
2. Rebuild: `docker-compose build <service>`
3. Restart: `docker-compose up -d <service>`

---

**That's it! You're now a Docker pro! 🚀**

---

*Keep this guide handy - you'll refer to it often!*
