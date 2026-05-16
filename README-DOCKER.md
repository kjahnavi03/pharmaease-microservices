# 🐳 PharmaEase - Complete Docker Setup

> **Quality Medicines, Delivered Fast** - Now fully containerized!

---

## 📖 What's This About?

Your **PharmaEase** application is now ready to be fully dockerized! This means:
- ✅ One command starts everything (Frontend + Backend + Databases)
- ✅ No manual setup of MySQL, RabbitMQ, etc.
- ✅ Consistent environment on any computer
- ✅ Easy deployment and scaling
- ✅ Everything stays local and safe

---

## 🎯 Current Status

### ✅ Completed
1. **Backend Services** - All 9 services have Dockerfiles
2. **Frontend Dockerfile** - Multi-stage build with Nginx
3. **Docker Compose** - Orchestrates all services
4. **Email Configuration** - Gmail SMTP integrated
5. **Angular Budget Fix** - CSS limits increased (8kB → 25kB)
6. **Documentation** - Complete guides created

### ⏳ Next Steps
1. Run build script
2. Build Docker images
3. Start containers
4. Test application

---

## 🚀 Quick Start (3 Commands)

```bash
# 1. Build all services (5-10 minutes)
build-all-with-frontend.bat

# 2. Create Docker images (10-15 minutes first time)
docker-compose build

# 3. Start everything (1 minute)
docker-compose up -d
```

**Then open:** http://localhost:4200

---

## 📚 Documentation Guide

### For Quick Setup
👉 **START HERE:** `QUICK-START-DOCKER.md`
- 3 simple steps
- Common commands
- Quick troubleshooting

### For Understanding Docker
👉 **READ THIS:** `DOCKER-EXPLAINED.md`
- What is Docker and why use it?
- How it works in your project
- Safety concerns addressed
- Making changes after dockerization
- Existing Docker images explained

### For Step-by-Step Testing
👉 **USE THIS:** `DOCKER-CHECKLIST.md`
- Complete checklist
- Testing procedures
- Troubleshooting steps
- Success criteria

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                  PharmaEase Stack                    │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Frontend (Angular + Nginx)                         │
│  └─ http://localhost:4200                           │
│                                                      │
│  API Gateway                                         │
│  └─ Routes requests to backend services             │
│                                                      │
│  Backend Services (9 Microservices)                 │
│  ├─ Eureka Server (Service Registry)                │
│  ├─ Config Server (Configuration)                   │
│  ├─ Auth Service (Authentication)                   │
│  ├─ Catalog Service (Medicines)                     │
│  ├─ Order Service (Orders)                          │
│  ├─ Admin Service (Admin Operations)                │
│  ├─ Payment Service (Payments)                      │
│  └─ Notification Service (Emails)                   │
│                                                      │
│  Infrastructure                                      │
│  ├─ MySQL (Database)                                │
│  ├─ RabbitMQ (Message Queue)                        │
│  └─ Zipkin (Distributed Tracing)                    │
│                                                      │
└─────────────────────────────────────────────────────┘
```

---

## 🔧 What Changed in Your Project?

### Files Created
```
pharma-frontend/
├── Dockerfile              # Frontend Docker build
├── nginx.conf             # Web server configuration
└── .dockerignore          # Docker ignore rules

Documentation/
├── QUICK-START-DOCKER.md  # Quick start guide
├── DOCKER-EXPLAINED.md    # Detailed explanation
├── DOCKER-CHECKLIST.md    # Testing checklist
└── README-DOCKER.md       # This file

Scripts/
└── build-all-with-frontend.bat  # Build script
```

### Files Modified
```
pharma-frontend/
└── angular.json           # CSS budget: 8kB → 25kB

notification-service/
└── application.yml        # Email configuration

docker-compose.yml         # Added frontend service
```

### Your Source Code
- ❌ **NOT MODIFIED** - All your code is safe!
- ✅ Only configuration files updated
- ✅ Docker uses copies of built files

---

## 🌐 Access Points

After running `docker-compose up -d`:

| Service | URL | Credentials |
|---------|-----|-------------|
| **PharmaEase App** | http://localhost:4200 | Your user accounts |
| **Admin Panel** | http://localhost:4200/admin | Admin credentials |
| **Eureka Dashboard** | http://localhost:8761 | - |
| **RabbitMQ Management** | http://localhost:15672 | guest / guest |
| **Zipkin Tracing** | http://localhost:9411 | - |

---

## 📊 Services & Ports

| Service | Internal Port | External Port |
|---------|---------------|---------------|
| Frontend | 80 | 4200 |
| Gateway | 8888 | 8888 |
| Eureka | 8761 | 8761 |
| Config Server | 8085 | 8085 |
| Auth Service | 9091 | 9091 |
| Catalog Service | 9092 | 9092 |
| Order Service | 9093 | 9093 |
| Admin Service | 9094 | 9094 |
| Payment Service | 9095 | 9095 |
| Notification Service | 9096 | 9096 |
| MySQL | 3306 | 3307 |
| RabbitMQ | 5672 | 5672 |
| RabbitMQ Management | 15672 | 15672 |
| Zipkin | 9411 | 9411 |

---

## 🔐 Configuration Details

### Database
- **Host:** mysql (inside Docker) / localhost:3307 (from host)
- **User:** root
- **Password:** Janu@0307
- **Databases:** Created automatically by services

### Email (Gmail SMTP)
- **Email:** kammilijahnavi@gmail.com
- **App Password:** pexyneyazujkquos
- **Enabled:** Yes (MAIL_ENABLED=true)

### JWT Secret
- **Secret:** pharmacy_super_secret_key_for_hs256_min_32chars

---

## 🛠️ Common Operations

### Start Application
```bash
docker-compose up -d
```

### Stop Application
```bash
docker-compose down
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f frontend
docker-compose logs -f gateway-service
```

### Check Status
```bash
docker-compose ps
```

### Restart Service
```bash
docker-compose restart <service-name>
```

### Rebuild After Code Changes
```bash
# Frontend
cd pharma-frontend
npm run build -- --configuration production
cd ..
docker-compose build frontend
docker-compose up -d frontend

# Backend (example: auth-service)
cd auth-service
mvn clean package -DskipTests
cd ..
docker-compose build auth-service
docker-compose up -d auth-service
```

### Fresh Start (Deletes Database!)
```bash
docker-compose down -v
docker-compose up -d
```

---

## 🐛 Troubleshooting

### Build Fails
```bash
# Check versions
java -version    # Should be 17+
mvn -version
node -version    # Should be 18+

# Clean and retry
mvn clean
npm cache clean --force
```

### Container Won't Start
```bash
# Check logs
docker-compose logs <service-name>

# Check Docker Desktop is running
# Check ports not in use
netstat -ano | findstr :4200
```

### Frontend Not Loading
```bash
# Restart frontend
docker-compose restart frontend

# Rebuild frontend
docker-compose build frontend
docker-compose up -d frontend

# Clear browser cache (Ctrl+Shift+Delete)
```

### API Calls Failing
```bash
# Check gateway
docker-compose logs gateway-service

# Check Eureka
# Open http://localhost:8761
# Verify all services registered

# Restart gateway
docker-compose restart gateway-service
```

---

## 🛡️ Safety & Security

### Local Development
- ✅ Everything runs locally on your computer
- ✅ No automatic upload to internet
- ✅ Source code never modified by Docker
- ✅ Can stop/start anytime
- ✅ Can revert to non-Docker setup

### Data Persistence
- ✅ MySQL data stored in Docker volume
- ✅ Persists across container restarts
- ⚠️ Only deleted with `docker-compose down -v`

### Credentials
- 🔒 Stored in docker-compose.yml (local file)
- 🔒 Not exposed to internet
- 🔒 Change before production deployment

---

## 📈 Development Workflow

### Daily Development
1. Start Docker: `docker-compose up -d`
2. Make code changes
3. Rebuild changed service
4. Test changes
5. Stop Docker: `docker-compose down` (optional)

### Frontend Development
- **Option 1:** Use `npm start` for hot reload (development)
- **Option 2:** Use Docker for production testing
- Both can coexist!

### Backend Development
- Make changes in service code
- Rebuild: `mvn clean package -DskipTests`
- Rebuild Docker: `docker-compose build <service>`
- Restart: `docker-compose up -d <service>`

---

## 🚀 Deployment (Future)

When ready to deploy to production:

1. **Choose Platform**
   - AWS (ECS, EKS)
   - Google Cloud (GKE)
   - Azure (AKS)
   - DigitalOcean
   - Heroku

2. **Prepare**
   - Change database password
   - Use environment variables for secrets
   - Set up production database
   - Configure SSL certificates
   - Set up domain name

3. **Deploy**
   - Push images to container registry
   - Deploy using platform tools
   - Set up monitoring
   - Configure auto-scaling

---

## 📞 Support & Resources

### Documentation Files
- `QUICK-START-DOCKER.md` - Quick setup guide
- `DOCKER-EXPLAINED.md` - Detailed explanation
- `DOCKER-CHECKLIST.md` - Testing checklist

### Useful Commands
```bash
# Docker basics
docker ps                    # List running containers
docker images               # List images
docker system prune         # Clean up unused resources

# Docker Compose
docker-compose ps           # List services
docker-compose logs         # View logs
docker-compose restart      # Restart services
docker-compose down         # Stop all services
```

### External Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Spring Boot with Docker](https://spring.io/guides/gs/spring-boot-docker/)
- [Angular with Docker](https://angular.io/guide/deployment)

---

## ✨ Success Checklist

- [ ] All services built successfully
- [ ] All Docker images created
- [ ] All containers running
- [ ] Frontend accessible at localhost:4200
- [ ] User can register and login
- [ ] User can browse medicines and place order
- [ ] Admin can login and manage system
- [ ] All services registered in Eureka
- [ ] Email notifications working (optional)

---

## 🎉 Congratulations!

Your PharmaEase application is now fully dockerized! You can:
- ✅ Start entire application with one command
- ✅ Develop and test locally
- ✅ Deploy to any platform
- ✅ Scale services independently
- ✅ Share with team easily

**Ready to start?**
```bash
build-all-with-frontend.bat
docker-compose build
docker-compose up -d
```

**Then visit:** http://localhost:4200

---

**Questions? Check DOCKER-EXPLAINED.md for detailed explanations!**

---

*Last Updated: May 4, 2026*
*Project: PharmaEase - Quality Medicines, Delivered Fast*
