# 🎤 PharmaEase - Interview Quick Reference Guide

## 🚀 30-Second Project Pitch

> "PharmaEase is a **microservices-based online pharmacy platform** where customers can browse medicines, place orders, upload prescriptions, and make payments. Admins can manage medicines, approve prescriptions, and update order statuses. Built with **Spring Boot 3.2.5**, **Spring Cloud**, **Angular 21**, **MySQL**, **RabbitMQ**, and deployed using **Docker**. The system consists of **9 independent microservices** communicating via REST APIs and asynchronous messaging."

---

## 📊 Quick Stats

| Metric | Value |
|--------|-------|
| **Backend Services** | 9 microservices |
| **Frontend** | Angular 21 SPA |
| **Databases** | 5 (MySQL 8.0) |
| **Containers** | 13 (Docker) |
| **Ports** | 13 different ports |
| **Communication** | REST + RabbitMQ |
| **Authentication** | JWT (Stateless) |

---

## 🏗️ Architecture (One-Liner Each)

| Service | Port | Purpose |
|---------|------|---------|
| **Eureka Server** | 8761 | Service Registry & Discovery |
| **Config Server** | 8085 | Centralized Configuration |
| **Gateway** | 8888 | API Gateway + JWT Auth |
| **Auth Service** | 9091 | User Login/Registration |
| **Catalog Service** | 9092 | Medicines & Prescriptions |
| **Order Service** | 9093 | Order Management |
| **Admin Service** | 9094 | Admin Operations |
| **Payment Service** | 9095 | Payment Processing |
| **Notification Service** | 9096 | Email Notifications |
| **MySQL** | 3307 | Database (5 databases) |
| **RabbitMQ** | 5672 | Message Queue |
| **Zipkin** | 9411 | Distributed Tracing |
| **Frontend** | 4200 | Angular App (Nginx) |

---

## 🔑 Key Technologies (Why We Use Them)

| Technology | Why? |
|------------|------|
| **Spring Boot 3.2.5** | Rapid development, auto-configuration, production-ready |
| **Spring Cloud** | Microservices patterns (Gateway, Eureka, Config) |
| **JWT** | Stateless auth, scalable, works across services |
| **Feign** | Declarative REST client, service discovery integration |
| **RabbitMQ** | Async messaging, decoupled services, event-driven |
| **MySQL** | Relational data, ACID transactions, mature ecosystem |
| **Docker** | Consistent environments, easy deployment, isolation |
| **Angular 21** | Modern SPA, TypeScript, reactive programming |
| **Zipkin** | Distributed tracing, performance monitoring |

---

## 🔄 Complete Flow (30 Seconds)

1. **User logs in** → Auth Service generates JWT
2. **Browse medicines** → Catalog Service returns list
3. **Add to cart** → Stored in frontend (CartService)
4. **Upload prescription** (if needed) → Catalog Service
5. **Place order** → Order Service (calls Catalog for prices)
6. **Admin approves prescription** → Admin Service → Order status updated
7. **Make payment** → Payment Service → Order status = PAID
8. **Admin updates status** → PACKED → SHIPPED → DELIVERED
9. **Notifications sent** → RabbitMQ → Notification Service → Email

---

## 💡 Top 10 Interview Questions (Quick Answers)

### 1. Why Microservices?
**Answer:** Independent deployment, scaling, technology diversity, fault isolation, team autonomy

### 2. How do services communicate?
**Answer:** REST APIs (Feign) for synchronous, RabbitMQ for asynchronous

### 3. How do you handle authentication?
**Answer:** JWT tokens - stateless, scalable, validated at Gateway

### 4. What if a service fails?
**Answer:** Circuit Breaker, Retry, Fallback, Timeout patterns

### 5. How do you ensure data consistency?
**Answer:** Eventual consistency, Saga pattern, idempotency

### 6. Why separate databases?
**Answer:** Loose coupling, independent scaling, fault isolation

### 7. How do you scale?
**Answer:** Horizontal scaling (multiple instances), load balancing, caching

### 8. What is API Gateway?
**Answer:** Single entry point, routing, JWT validation, CORS, rate limiting

### 9. Why Docker?
**Answer:** Consistent environments, easy deployment, isolation, scalability

### 10. How do you monitor?
**Answer:** Zipkin (tracing), Logs (ELK), Metrics (Prometheus), Health checks

---

## 🎯 Key Design Patterns Used

| Pattern | Where | Why |
|---------|-------|-----|
| **API Gateway** | Gateway Service | Single entry point, centralized auth |
| **Service Discovery** | Eureka | Dynamic service registration |
| **Database Per Service** | All services | Loose coupling, independent scaling |
| **Circuit Breaker** | Feign clients | Prevent cascade failures |
| **Event-Driven** | RabbitMQ | Async, decoupled, scalable |
| **Saga** | Order placement | Distributed transactions |
| **CQRS** | Order/Catalog | Separate read/write models |

---

## 🔐 Security Measures

✅ **JWT Authentication** - Stateless, scalable
✅ **BCrypt Password Hashing** - Salted, slow by design
✅ **Role-Based Authorization** - CUSTOMER, ADMIN roles
✅ **API Gateway** - Centralized security
✅ **Parameterized Queries** - Prevent SQL injection
✅ **HTTPS** - Encrypt data in transit
✅ **Input Validation** - Prevent XSS, injection

---

## 🐳 Docker Benefits

| Benefit | Explanation |
|---------|-------------|
| **Consistency** | Same environment dev/test/prod |
| **Isolation** | Each service in own container |
| **Portability** | Run anywhere Docker runs |
| **Scalability** | Easy to scale services |
| **Efficiency** | Lightweight vs VMs |
| **Speed** | Fast startup (seconds) |

---

## 📊 Database Schema (Quick Reference)

### auth_db
- `users` (id, email, password, first_name, last_name, contact_number)
- `user_roles` (user_id, role)

### catalog_db
- `medicines` (id, name, price, stock_quantity, requires_prescription, category_id)
- `categories` (id, name, description)
- `prescriptions` (id, customer_id, image_url, status, uploaded_at)

### order_db
- `orders` (id, customer_id, total_amount, status, prescription_id, created_at)
- `order_items` (id, order_id, medicine_id, quantity, unit_price)

### payment_db
- `payments` (id, order_id, amount, payment_method, status, transaction_id)

### admin_db
- `audit_logs` (id, admin_id, action, entity_type, entity_id, timestamp)

---

## 🚨 Common Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| **Service failure** | Circuit Breaker + Fallback |
| **Data consistency** | Eventual consistency + Saga |
| **Distributed transactions** | Saga pattern, compensating transactions |
| **Network latency** | Caching, async messaging |
| **Debugging** | Distributed tracing (Zipkin) |
| **Configuration** | Centralized config server |
| **Service discovery** | Eureka server |
| **High traffic** | Auto-scaling, caching, rate limiting |

---

## 🎓 What You Learned

### Backend
- Spring Boot microservices
- Spring Cloud (Gateway, Eureka, Config)
- JWT authentication
- Feign clients
- RabbitMQ messaging
- JPA/Hibernate
- RESTful APIs

### Frontend
- Angular 21 (standalone components)
- TypeScript
- RxJS (reactive programming)
- HTTP interceptors
- Route guards

### DevOps
- Docker & docker-compose
- Multi-stage builds
- Container orchestration
- Nginx reverse proxy

### Architecture
- Microservices patterns
- Event-driven architecture
- Database per service
- API Gateway pattern
- Service Discovery

---

## 💬 How to Explain Your Project

### Opening (30 seconds)
"I built PharmaEase, an online pharmacy platform using microservices architecture. It has 9 backend services built with Spring Boot and Spring Cloud, an Angular frontend, and is deployed using Docker. Customers can browse medicines, place orders, and upload prescriptions. Admins can manage inventory and approve prescriptions."

### Technical Deep Dive (2 minutes)
"The architecture uses an API Gateway for routing and JWT authentication. Services communicate via REST APIs using Feign clients and asynchronously via RabbitMQ. Each service has its own MySQL database following the database-per-service pattern. We use Eureka for service discovery, so services can find each other dynamically. For monitoring, we use Zipkin for distributed tracing."

### Challenges (1 minute)
"One challenge was handling distributed transactions. For example, when placing an order, we need to check stock, create the order, and send notifications. We solved this using the Saga pattern with compensating transactions. Another challenge was ensuring data consistency across services, which we handled with eventual consistency and idempotent operations."

### Results
"The system successfully handles the complete e-commerce flow from browsing to delivery. It's containerized with Docker, making deployment consistent across environments. The microservices architecture allows us to scale individual services based on demand."

---

## 🎯 Bonus Points to Mention

✨ **Multi-stage Docker builds** - Reduced image size by 75%
✨ **Distributed tracing** - Can track requests across all services
✨ **Event-driven architecture** - Decoupled, scalable notifications
✨ **Audit logging** - Track all admin actions
✨ **Prescription approval workflow** - Real-world business logic
✨ **Stock management** - Concurrent update handling
✨ **Email notifications** - Configurable SMTP integration

---

## 📝 Questions to Ask Interviewer

1. "What microservices patterns does your team use?"
2. "How do you handle distributed transactions?"
3. "What's your deployment strategy for microservices?"
4. "Do you use Kubernetes or Docker Swarm?"
5. "How do you monitor microservices in production?"
6. "What's your approach to service-to-service authentication?"

---

## ⚡ Last-Minute Checklist

Before the interview, make sure you can explain:

- [ ] Why microservices over monolithic
- [ ] How services communicate (REST + RabbitMQ)
- [ ] JWT authentication flow
- [ ] Order placement flow (end-to-end)
- [ ] How you handle service failures
- [ ] Database per service pattern
- [ ] Docker benefits and architecture
- [ ] API Gateway role
- [ ] Service Discovery (Eureka)
- [ ] One challenge you faced and solved

---

## 🎤 Practice Pitch (Memorize This)

> "PharmaEase is a microservices-based online pharmacy I built using Spring Boot, Spring Cloud, and Angular. It consists of 9 independent services including authentication, catalog management, order processing, and payment handling. Services communicate via REST APIs and RabbitMQ for asynchronous messaging. I implemented JWT authentication, used Eureka for service discovery, and deployed everything using Docker. The system handles the complete e-commerce flow from browsing medicines to order delivery, with features like prescription approval and email notifications."

---

**Good Luck! 🚀**

*Remember: Confidence comes from understanding, not memorization. Understand the concepts, and you'll ace the interview!*
