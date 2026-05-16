# ✅ Docker Setup Checklist - PharmaEase

## 📋 Pre-Setup Verification

- [x] Java 17+ installed
- [x] Maven installed
- [x] Node.js 18+ installed
- [x] Docker Desktop installed and running
- [x] Project code ready
- [x] Angular budget limit fixed (8kB → 25kB)

---

## 🔧 Setup Steps

### Phase 1: Build Services
- [ ] Open terminal in project root
- [ ] Run `build-all-with-frontend.bat`
- [ ] Wait for all services to build (5-10 minutes)
- [ ] Verify: See "✅ All services built successfully!"

**If build fails:**
- Check error message
- Verify Java/Maven/Node versions
- Check internet connection (for dependencies)

---

### Phase 2: Create Docker Images
- [ ] Run `docker-compose build`
- [ ] Wait for images to build (10-15 minutes first time)
- [ ] Verify: No error messages

**If build fails:**
- Check Docker Desktop is running
- Check disk space (need ~5GB free)
- Run `docker system prune` to free space

---

### Phase 3: Start Containers
- [ ] Run `docker-compose up -d`
- [ ] Wait for containers to start (1-2 minutes)
- [ ] Run `docker-compose ps` to check status
- [ ] Verify: All services show "Up"

**If containers fail to start:**
- Check logs: `docker-compose logs -f`
- Check ports not in use: `netstat -ano | findstr :4200`
- Restart Docker Desktop

---

## 🧪 Testing Phase

### Test 1: Frontend Access
- [ ] Open browser
- [ ] Go to http://localhost:4200
- [ ] Verify: PharmaEase home page loads
- [ ] Check: Light blue theme visible
- [ ] Test: Navigation works

---

### Test 2: User Registration
- [ ] Click "Register" or "Sign Up"
- [ ] Fill in user details
- [ ] Submit registration
- [ ] Verify: Success message appears
- [ ] Check: Can login with new account

---

### Test 3: User Login
- [ ] Go to login page
- [ ] Enter credentials
- [ ] Click login
- [ ] Verify: Redirected to home/dashboard
- [ ] Check: User name visible in header

---

### Test 4: Browse Medicines
- [ ] Go to medicines page
- [ ] Verify: Medicine list loads
- [ ] Test: Search functionality
- [ ] Test: Filter by category
- [ ] Check: Medicine details visible

---

### Test 5: Add to Cart
- [ ] Select a medicine
- [ ] Click "Add to Cart"
- [ ] Verify: Cart count increases
- [ ] Go to cart page
- [ ] Check: Medicine appears in cart

---

### Test 6: Place Order
- [ ] In cart, click "Proceed to Checkout"
- [ ] Fill in delivery details
- [ ] Select payment method
- [ ] Place order
- [ ] Verify: Order confirmation appears
- [ ] Check: Order appears in "My Orders"

---

### Test 7: Admin Login
- [ ] Logout from user account
- [ ] Login with admin credentials
- [ ] Verify: Redirected to admin dashboard
- [ ] Check: Admin sidebar visible
- [ ] Check: Light theme applied

---

### Test 8: Admin - Manage Medicines
- [ ] Go to "Medicines" in admin panel
- [ ] Verify: Medicine list loads
- [ ] Test: Add new medicine
- [ ] Test: Edit medicine
- [ ] Test: Delete medicine (optional)

---

### Test 9: Admin - View Orders
- [ ] Go to "Orders" in admin panel
- [ ] Verify: Order list loads
- [ ] Check: Recent order visible
- [ ] Test: Update order status
- [ ] Verify: Status changes

---

### Test 10: Email Notification (Optional)
- [ ] Place an order as user
- [ ] Check email: kammilijahnavi@gmail.com
- [ ] Verify: Order confirmation email received
- [ ] Check: Email content correct

**If email not received:**
- Check spam folder
- Verify Gmail App Password in docker-compose.yml
- Check notification-service logs: `docker-compose logs notification-service`

---

## 🔍 Service Health Checks

### Eureka Dashboard
- [ ] Open http://localhost:8761
- [ ] Verify: All services registered
- [ ] Check: Services show "UP" status

**Expected Services:**
- GATEWAY-SERVICE
- AUTH-SERVICE
- CATALOG-SERVICE
- ORDER-SERVICE
- ADMIN-SERVICE
- PAYMENT-SERVICE
- NOTIFICATION-SERVICE

---

### RabbitMQ Management
- [ ] Open http://localhost:15672
- [ ] Login: guest / guest
- [ ] Verify: Queues created
- [ ] Check: Messages flowing (when order placed)

---

### Zipkin Tracing
- [ ] Open http://localhost:9411
- [ ] Verify: Zipkin UI loads
- [ ] Perform some actions in app
- [ ] Check: Traces appear in Zipkin

---

## 📊 Container Status Check

Run: `docker-compose ps`

Expected containers (all should be "Up"):
- [ ] pharmacy-mysql
- [ ] pharmacy-rabbitmq
- [ ] pharmacy-zipkin
- [ ] eureka-server
- [ ] config-server
- [ ] gateway-service
- [ ] auth-service
- [ ] catalog-service
- [ ] order-service
- [ ] admin-service
- [ ] payment-service
- [ ] notification-service
- [ ] pharma-frontend

---

## 🐛 Troubleshooting Checklist

### If Frontend Not Loading
- [ ] Check container status: `docker-compose ps frontend`
- [ ] Check logs: `docker-compose logs frontend`
- [ ] Verify port 4200 not in use
- [ ] Try restart: `docker-compose restart frontend`
- [ ] Clear browser cache (Ctrl+Shift+Delete)

---

### If API Calls Failing
- [ ] Check gateway-service: `docker-compose logs gateway-service`
- [ ] Check specific service logs
- [ ] Verify Eureka shows all services
- [ ] Check network: `docker network ls`
- [ ] Restart gateway: `docker-compose restart gateway-service`

---

### If Database Errors
- [ ] Check MySQL container: `docker-compose ps mysql`
- [ ] Check MySQL logs: `docker-compose logs mysql`
- [ ] Verify password in docker-compose.yml: Janu@0307
- [ ] Check port 3307 not in use
- [ ] Restart MySQL: `docker-compose restart mysql`

---

### If Email Not Sending
- [ ] Check notification-service logs
- [ ] Verify Gmail credentials in docker-compose.yml
- [ ] Check RabbitMQ connection
- [ ] Verify email enabled: MAIL_ENABLED=true
- [ ] Test Gmail App Password still valid

---

## 🎯 Success Criteria

### ✅ Setup Complete When:
- [ ] All containers running (docker-compose ps)
- [ ] Frontend accessible at localhost:4200
- [ ] User can register and login
- [ ] User can browse medicines
- [ ] User can place order
- [ ] Admin can login
- [ ] Admin can manage medicines
- [ ] Admin can view orders
- [ ] All services registered in Eureka
- [ ] No error logs in containers

---

## 📝 Post-Setup Tasks

### Documentation
- [ ] Read DOCKER-EXPLAINED.md
- [ ] Bookmark QUICK-START-DOCKER.md
- [ ] Save common commands

### Backup
- [ ] Note database password: Janu@0307
- [ ] Note email credentials
- [ ] Save docker-compose.yml
- [ ] Document any custom changes

### Development Workflow
- [ ] Understand how to make changes
- [ ] Know how to rebuild services
- [ ] Know how to view logs
- [ ] Know how to restart services

---

## 🚀 Next Steps

### For Development
- [ ] Set up code editor
- [ ] Configure debugging
- [ ] Set up Git (if not already)
- [ ] Plan feature development

### For Production (Future)
- [ ] Choose hosting platform
- [ ] Set up CI/CD pipeline
- [ ] Configure production database
- [ ] Set up monitoring
- [ ] Configure SSL certificates
- [ ] Set up domain name

---

## 📞 Quick Commands Reference

```bash
# Start everything
docker-compose up -d

# Stop everything
docker-compose down

# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f frontend
docker-compose logs -f gateway-service

# Check status
docker-compose ps

# Restart service
docker-compose restart <service-name>

# Rebuild service
docker-compose build <service-name>
docker-compose up -d <service-name>

# Fresh start (WARNING: Deletes database!)
docker-compose down -v
docker-compose up -d
```

---

## ✨ Congratulations!

When all checkboxes are checked, your PharmaEase application is fully dockerized and running! 🎉

**Access your application:**
- Frontend: http://localhost:4200
- Admin Panel: http://localhost:4200/admin
- Eureka: http://localhost:8761

**Remember:**
- Everything is local and safe
- You can stop anytime: `docker-compose down`
- You can make changes and rebuild
- Your source code is never modified

---

**Need help? Check DOCKER-EXPLAINED.md for detailed explanations!**
