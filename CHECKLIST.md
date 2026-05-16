# ✅ Docker Setup Checklist

## 📋 Pre-Setup Checklist

Before you start, make sure you have:

- [ ] Docker Desktop installed and running
- [ ] At least 8GB RAM allocated to Docker
- [ ] At least 20GB free disk space
- [ ] Java 17+ installed
- [ ] Maven 3.8+ installed
- [ ] Node.js 18+ installed (for building frontend)

---

## 🚀 Setup Steps

### **Step 1: Build All Services**

```bash
build-all-with-frontend.bat
```

**Checklist:**
- [ ] Script started successfully
- [ ] All 9 backend services built (no errors)
- [ ] Frontend dependencies installed
- [ ] Frontend production build completed
- [ ] No error messages in output

**Expected time:** 5-10 minutes

---

### **Step 2: Build Docker Images**

```bash
docker-compose build
```

**Checklist:**
- [ ] Command started successfully
- [ ] All 10 images building (9 backend + 1 frontend)
- [ ] No error messages
- [ ] All images built successfully

**Expected time:** 5-10 minutes

---

### **Step 3: Start All Containers**

```bash
docker-compose up -d
```

**Checklist:**
- [ ] Command completed successfully
- [ ] All containers started
- [ ] No error messages

**Expected time:** 30-60 seconds

---

## 🔍 Verification Checklist

### **1. Check Containers**

```bash
docker-compose ps
```

**Verify all 13 containers are "Up":**
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

### **2. Check Eureka Dashboard**

Open: http://localhost:8761

**Verify:**
- [ ] Eureka dashboard loads
- [ ] 9 services registered
- [ ] All services show "UP" status

---

### **3. Check RabbitMQ**

Open: http://localhost:15672
Login: guest / guest

**Verify:**
- [ ] RabbitMQ management UI loads
- [ ] Can login successfully
- [ ] notification.queue exists

---

### **4. Check Frontend**

Open: http://localhost:4200

**Verify:**
- [ ] Frontend loads successfully
- [ ] Home page displays correctly
- [ ] Navigation works
- [ ] No console errors (F12)

---

### **5. Test User Registration**

**Steps:**
1. Click "Register"
2. Fill in details
3. Submit

**Verify:**
- [ ] Registration form works
- [ ] Can create account
- [ ] Redirected to login

---

### **6. Test Login**

**Steps:**
1. Enter credentials
2. Click login

**Verify:**
- [ ] Login successful
- [ ] Redirected to home
- [ ] User menu shows

---

### **7. Test Medicine Browsing**

**Steps:**
1. Click "Medicines"
2. Browse catalog

**Verify:**
- [ ] Medicines list loads
- [ ] All 25 medicines visible
- [ ] Images load
- [ ] Filters work

---

### **8. Test Cart & Order**

**Steps:**
1. Add medicine to cart
2. View cart
3. Place order

**Verify:**
- [ ] Can add to cart
- [ ] Cart shows items
- [ ] Can place order
- [ ] Order confirmation shown

---

### **9. Test Email Notification**

**Steps:**
1. Place an order
2. Check email inbox

**Verify:**
- [ ] Email received
- [ ] Email content correct
- [ ] From: kammilijahnavi@gmail.com

---

### **10. Test Admin Panel**

**Steps:**
1. Logout
2. Login as admin (admin@pharma.com / admin123)
3. Go to admin dashboard

**Verify:**
- [ ] Admin login works
- [ ] Dashboard loads
- [ ] Stats display correctly
- [ ] Can view orders
- [ ] Can manage medicines

---

## 🐛 Troubleshooting Checklist

### **If containers won't start:**

- [ ] Check Docker Desktop is running
- [ ] Check ports are not in use
- [ ] Check Docker has enough memory (8GB+)
- [ ] Check logs: `docker-compose logs`

### **If frontend won't load:**

- [ ] Check pharma-frontend container is running
- [ ] Check logs: `docker logs pharma-frontend`
- [ ] Check port 4200 is not in use
- [ ] Try: `docker-compose restart frontend`

### **If API calls fail:**

- [ ] Check gateway-service is running
- [ ] Check Eureka shows all services
- [ ] Check logs: `docker logs gateway-service`
- [ ] Check nginx config: `docker exec pharma-frontend cat /etc/nginx/conf.d/default.conf`

### **If emails don't send:**

- [ ] Check notification-service logs
- [ ] Verify email config in docker-compose.yml
- [ ] Check Gmail app password is correct
- [ ] Check RabbitMQ queue has messages

---

## ✅ Success Criteria

Your setup is successful if:

- [x] All 13 containers running
- [x] Frontend accessible at http://localhost:4200
- [x] Can register and login
- [x] Can browse medicines
- [x] Can place orders
- [x] Emails are received
- [x] Admin panel works

---

## 🎉 Congratulations!

If all checkboxes are checked, your application is:

✅ Fully dockerized
✅ Running successfully
✅ Production-ready

---

## 📝 Next Steps

- [ ] Test all features thoroughly
- [ ] Add more medicines
- [ ] Test prescription upload
- [ ] Test payment flow
- [ ] Test admin operations
- [ ] Monitor logs for errors
- [ ] Check performance

---

## 🆘 Need Help?

If any checkbox is unchecked:

1. Check logs: `docker-compose logs -f`
2. Read: `COMPLETE-DOCKER-GUIDE.md`
3. Try clean restart: `docker-compose down -v && docker-compose up -d`

---

**Good luck! 🚀**
