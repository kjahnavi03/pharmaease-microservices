# 🎯 OOP Concepts Used in PharmaEase Project

## 📚 Complete Analysis of Object-Oriented Programming Concepts

---

## 1️⃣ ENCAPSULATION 🔒

### What is Encapsulation?
Hiding internal implementation details and exposing only necessary information through public methods.

### Where You Used It:

#### **A. Entity Classes (Data Hiding)**

**Location:** All entity classes (User, Medicine, Order, Payment, etc.)

```java
// auth-service/src/main/java/com/capg/pharma/authservice/model/User.java
@Entity
@Table(name = "users")
public class User {
    // ✅ ENCAPSULATION: Private fields
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(nullable = false)
    private String password;  // Hidden from external access
    
    // ✅ ENCAPSULATION: Public getters/setters (controlled access)
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
```

**Why This is Encapsulation:**
- ✅ Private fields cannot be accessed directly from outside
- ✅ Public getters/setters provide controlled access
- ✅ Can add validation in setters if needed
- ✅ Internal representation can change without affecting external code

#### **B. Service Classes (Business Logic Encapsulation)**

**Location:** All service classes (AuthService, MedicineService, OrderService, etc.)

```java
// auth-service/src/main/java/com/capg/pharma/authservice/service/AuthService.java
@Service
public class AuthService {
    // ✅ ENCAPSULATION: Private dependencies
    private final UserRepository userRepo;
    private final PasswordEncoder encoder;
    private final JwtService jwtService;
    
    @Value("${admin.registration.token:PHARMA-ADMIN-2026}")
    private String adminRegistrationToken;  // Hidden configuration
    
    // ✅ ENCAPSULATION: Public methods expose functionality
    public String signup(SignupRequest req) {
        // Internal logic hidden from caller
        if (userRepo.existsByEmail(req.getEmail())) {
            throw new UserAlreadyExistsException("Email already registered");
        }
        
        User user = new User();
        user.setEmail(req.getEmail());
        user.setPassword(encoder.encode(req.getPassword()));  // Password hashing hidden
        userRepo.save(user);
        return "User registered successfully";
    }
    
    public LoginResponse login(LoginRequest req) {
        // Complex authentication logic encapsulated
        User user = userRepo.findByEmail(req.getEmail())
            .orElseThrow(() -> new UserNotFoundException("User not found"));
        
        if (!encoder.matches(req.getPassword(), user.getPassword())) {
            throw new InvalidCredentialsException("Invalid credentials");
        }
        
        String token = jwtService.generateToken(user.getEmail(), user.getRoles());
        return new LoginResponse(token, user.getName(), user.getId(), roles);
    }
}
```

**Why This is Encapsulation:**
- ✅ Password hashing logic hidden inside service
- ✅ JWT generation logic encapsulated
- ✅ Database operations hidden from controller
- ✅ Caller doesn't need to know HOW authentication works

#### **C. DTOs (Data Transfer Objects)**

**Location:** All DTO classes (LoginRequest, MedicineResponse, OrderRequest, etc.)

```java
// auth-service/src/main/java/com/capg/pharma/authservice/dto/LoginRequest.java
public class LoginRequest {
    private String email;
    private String password;
    
    // Getters and setters
}

// auth-service/src/main/java/com/capg/pharma/authservice/dto/LoginResponse.java
public class LoginResponse {
    private String token;
    private String name;
    private Long userId;
    private Set<String> roles;
    
    // Constructor, getters
}
```

**Why This is Encapsulation:**
- ✅ Separates internal entity structure from API contract
- ✅ Can change database schema without affecting API
- ✅ Hides sensitive fields (e.g., password not in response)

---

## 2️⃣ INHERITANCE 🌳

### What is Inheritance?
Creating new classes based on existing classes, inheriting their properties and methods.

### Where You Used It:

#### **A. Exception Hierarchy**

**Location:** All exception classes

```java
// auth-service/src/main/java/com/capg/pharma/authservice/exception/UserNotFoundException.java
public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException(String message) { 
        super(message);  // ✅ INHERITANCE: Calling parent constructor
    }
}

// auth-service/src/main/java/com/capg/pharma/authservice/exception/InvalidCredentialsException.java
public class InvalidCredentialsException extends RuntimeException {
    public InvalidCredentialsException(String message) { 
        super(message); 
    }
}

// auth-service/src/main/java/com/capg/pharma/authservice/exception/UserAlreadyExistsException.java
public class UserAlreadyExistsException extends RuntimeException {
    public UserAlreadyExistsException(String message) { 
        super(message); 
    }
}
```

**Inheritance Hierarchy:**
```
Object (Java root class)
  └── Throwable
      └── Exception
          └── RuntimeException (Parent)
              ├── UserNotFoundException (Child)
              ├── InvalidCredentialsException (Child)
              ├── UserAlreadyExistsException (Child)
              ├── MedicineNotFoundException (Child)
              ├── OrderNotFoundException (Child)
              ├── PaymentNotFoundException (Child)
              └── ... (all custom exceptions)
```

**Why This is Inheritance:**
- ✅ All custom exceptions inherit from RuntimeException
- ✅ Inherit exception handling mechanisms
- ✅ Can be caught using parent class (RuntimeException)
- ✅ Reuse exception infrastructure

#### **B. Spring Framework Inheritance**

**Location:** Filter classes

```java
// auth-service/src/main/java/com/capg/pharma/authservice/security/JwtAuthFilter.java
@Component
public class JwtAuthFilter extends OncePerRequestFilter {
    // ✅ INHERITANCE: Extends Spring's OncePerRequestFilter
    
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) {
        // Custom JWT validation logic
        String token = extractToken(request);
        if (token != null && jwtService.validateToken(token)) {
            // Set authentication
        }
        filterChain.doFilter(request, response);
    }
}
```

**Inheritance Hierarchy:**
```
GenericFilterBean (Spring)
  └── OncePerRequestFilter (Spring - Parent)
      └── JwtAuthFilter (Your class - Child)
```

**Why This is Inheritance:**
- ✅ Inherits Spring's filter lifecycle management
- ✅ Overrides doFilterInternal() method
- ✅ Reuses Spring's request/response handling
- ✅ Gets automatic integration with Spring Security

#### **C. Gateway Filter Inheritance**

**Location:** gateway-service

```java
// gateway-service/src/main/java/com/capg/pharma/gatewayservice/filter/JwtAuthFilter.java
@Component
public class JwtAuthFilter extends AbstractGatewayFilterFactory<JwtAuthFilter.Config> {
    // ✅ INHERITANCE: Extends Spring Cloud Gateway's AbstractGatewayFilterFactory
    
    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            // Custom gateway filter logic
            String token = extractToken(exchange.getRequest());
            if (token == null || !jwtService.validateToken(token)) {
                exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
                return exchange.getResponse().setComplete();
            }
            return chain.filter(exchange);
        };
    }
}
```

**Why This is Inheritance:**
- ✅ Inherits gateway filter infrastructure
- ✅ Overrides apply() method
- ✅ Reuses Spring Cloud Gateway's routing logic

---

## 3️⃣ POLYMORPHISM 🎭

### What is Polymorphism?
Same interface, different implementations. "Many forms" - ability to process objects differently based on their type.

### Where You Used It:

#### **A. Method Overriding (Runtime Polymorphism)**

**Location:** Filter classes, Repository methods

```java
// JwtAuthFilter overrides parent method
@Component
public class JwtAuthFilter extends OncePerRequestFilter {
    
    @Override  // ✅ POLYMORPHISM: Method Overriding
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) {
        // Custom implementation replaces parent's implementation
        String token = extractToken(request);
        // ... validation logic
    }
}
```

**Why This is Polymorphism:**
- ✅ Same method name (doFilterInternal) as parent
- ✅ Different implementation in child class
- ✅ Spring calls child's version at runtime
- ✅ Can treat JwtAuthFilter as OncePerRequestFilter

#### **B. Interface Implementation (Compile-time Polymorphism)**

**Location:** All repository interfaces

```java
// catalog-service/src/main/java/com/capg/pharma/catalogservice/repository/MedicineRepository.java
public interface MedicineRepository extends JpaRepository<Medicine, Long> {
    // ✅ POLYMORPHISM: Implementing JpaRepository interface
    
    List<Medicine> findByNameContainingIgnoreCase(String name);
    List<Medicine> findLowStockMedicines();
}

// Spring Data JPA provides implementation at runtime
```

**Polymorphism in Action:**
```java
@Service
public class MedicineService {
    private final MedicineRepository medicineRepo;  // Interface reference
    
    public List<Medicine> getAll() {
        return medicineRepo.findAll();  // ✅ POLYMORPHISM: Calling interface method
        // Spring provides actual implementation at runtime
    }
}
```

**Why This is Polymorphism:**
- ✅ MedicineRepository is an interface
- ✅ Spring Data JPA provides implementation at runtime
- ✅ Can swap implementations without changing service code
- ✅ Same interface, different implementations (MySQL, PostgreSQL, MongoDB)

#### **C. Exception Handling Polymorphism**

**Location:** Global exception handlers

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    // ✅ POLYMORPHISM: Handles all RuntimeException subclasses
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ErrorResponse> handleRuntimeException(RuntimeException ex) {
        // Can handle UserNotFoundException, OrderNotFoundException, etc.
        return ResponseEntity.status(500).body(new ErrorResponse(ex.getMessage()));
    }
    
    // More specific handler
    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleUserNotFound(UserNotFoundException ex) {
        return ResponseEntity.status(404).body(new ErrorResponse(ex.getMessage()));
    }
}
```

**Why This is Polymorphism:**
- ✅ Parent class reference (RuntimeException) can hold child objects
- ✅ Different exception types handled by same method
- ✅ Runtime decides which handler to call

#### **D. Service Layer Polymorphism**

**Location:** Feign Clients

```java
// order-service/src/main/java/com/capg/pharma/orderservice/client/CatalogClient.java
@FeignClient(name = "catalog-service")
public interface CatalogClient {
    // ✅ POLYMORPHISM: Interface defines contract
    
    @GetMapping("/api/catalog/medicines/{id}")
    MedicineDto getMedicineById(@PathVariable Long id);
    
    @PutMapping("/api/catalog/medicines/{id}/stock/decrement")
    void decrementStock(@PathVariable Long id, @RequestParam int quantity);
}

// Feign provides HTTP implementation at runtime
```

**Why This is Polymorphism:**
- ✅ Interface defines what to do
- ✅ Feign provides how to do it (HTTP calls)
- ✅ Can mock for testing (different implementation)

---

## 4️⃣ ABSTRACTION 🎨

### What is Abstraction?
Hiding complex implementation details and showing only essential features.

### Where You Used It:

#### **A. Repository Abstraction**

**Location:** All repository interfaces

```java
// ✅ ABSTRACTION: JpaRepository hides database complexity
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
}

// Usage in service
@Service
public class AuthService {
    private final UserRepository userRepo;
    
    public LoginResponse login(LoginRequest req) {
        // ✅ ABSTRACTION: Don't need to know SQL, JDBC, connection pooling
        User user = userRepo.findByEmail(req.getEmail())
            .orElseThrow(() -> new UserNotFoundException("User not found"));
        
        // Complex database operations abstracted away
    }
}
```

**What's Abstracted:**
- ✅ SQL query generation
- ✅ Database connection management
- ✅ Transaction management
- ✅ Result set mapping
- ✅ Connection pooling

#### **B. Service Layer Abstraction**

**Location:** All service classes

```java
// ✅ ABSTRACTION: Controller doesn't know business logic details
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;
    
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest req) {
        // ✅ ABSTRACTION: Just call service, don't know HOW it works
        LoginResponse response = authService.login(req);
        return ResponseEntity.ok(response);
    }
}

// Service handles complex logic
@Service
public class AuthService {
    public LoginResponse login(LoginRequest req) {
        // Complex logic abstracted:
        // 1. Find user in database
        // 2. Verify password (BCrypt)
        // 3. Generate JWT token
        // 4. Build response
        // Controller doesn't need to know any of this!
    }
}
```

**What's Abstracted:**
- ✅ Password hashing algorithm
- ✅ JWT token generation
- ✅ Database queries
- ✅ Error handling

#### **C. Feign Client Abstraction**

**Location:** All Feign client interfaces

```java
// ✅ ABSTRACTION: HTTP communication abstracted
@FeignClient(name = "catalog-service")
public interface CatalogClient {
    @GetMapping("/api/catalog/medicines/{id}")
    MedicineDto getMedicineById(@PathVariable Long id);
}

// Usage in OrderService
@Service
public class OrderService {
    private final CatalogClient catalogClient;
    
    public OrderResponse placeOrder(OrderRequest req) {
        // ✅ ABSTRACTION: Just call method, don't worry about HTTP
        MedicineDto medicine = catalogClient.getMedicineById(medicineId);
        
        // No need to know:
        // - HTTP protocol
        // - URL construction
        // - Request/response serialization
        // - Error handling
        // - Service discovery
    }
}
```

**What's Abstracted:**
- ✅ HTTP request/response handling
- ✅ JSON serialization/deserialization
- ✅ Service discovery (Eureka)
- ✅ Load balancing
- ✅ Error handling

#### **D. Spring Framework Abstraction**

**Location:** Throughout the project

```java
// ✅ ABSTRACTION: @Service annotation abstracts bean management
@Service
public class AuthService {
    // Spring manages:
    // - Object creation
    // - Dependency injection
    // - Lifecycle management
    // - Transaction management
}

// ✅ ABSTRACTION: @Transactional abstracts transaction management
@Transactional
public void decrementStock(Long id, int quantity) {
    // Spring handles:
    // - Begin transaction
    // - Commit on success
    // - Rollback on exception
    // - Connection management
}
```

---

## 5️⃣ COMPOSITION 🧩

### What is Composition?
"Has-a" relationship - building complex objects from simpler ones.

### Where You Used It:

#### **A. Entity Relationships**

**Location:** Order and OrderItem entities

```java
// ✅ COMPOSITION: Order HAS-A list of OrderItems
@Entity
@Table(name = "orders")
public class Order {
    @Id
    private Long id;
    
    // ✅ COMPOSITION: Order is composed of OrderItems
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderItem> items = new ArrayList<>();
    
    // If Order is deleted, OrderItems are also deleted (strong relationship)
}

@Entity
@Table(name = "order_items")
public class OrderItem {
    @Id
    private Long id;
    
    // ✅ COMPOSITION: OrderItem belongs to Order
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;
}
```

**Why This is Composition:**
- ✅ Order "has-a" list of OrderItems
- ✅ OrderItems cannot exist without Order
- ✅ Deleting Order deletes OrderItems (cascade)
- ✅ Strong ownership relationship

#### **B. Service Dependencies**

**Location:** All service classes

```java
// ✅ COMPOSITION: AuthService is composed of dependencies
@Service
public class AuthService {
    // ✅ COMPOSITION: AuthService HAS-A UserRepository
    private final UserRepository userRepo;
    
    // ✅ COMPOSITION: AuthService HAS-A PasswordEncoder
    private final PasswordEncoder encoder;
    
    // ✅ COMPOSITION: AuthService HAS-A JwtService
    private final JwtService jwtService;
    
    // Constructor injection
    public AuthService(UserRepository userRepo, 
                      PasswordEncoder encoder, 
                      JwtService jwtService) {
        this.userRepo = userRepo;
        this.encoder = encoder;
        this.jwtService = jwtService;
    }
}
```

**Why This is Composition:**
- ✅ AuthService is composed of other objects
- ✅ Dependencies are injected (Dependency Injection)
- ✅ AuthService uses these objects to provide functionality

---

## 6️⃣ ASSOCIATION 🔗

### What is Association?
Relationship between classes where objects can exist independently.

### Where You Used It:

#### **A. Many-to-One Association**

**Location:** Medicine and Category

```java
// ✅ ASSOCIATION: Medicine is associated with Category
@Entity
public class Medicine {
    @Id
    private Long id;
    
    // ✅ ASSOCIATION: Medicine HAS-A Category (weak relationship)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id")
    private Category category;
    
    // Medicine can exist without Category
    // Category can exist without Medicine
}
```

**Why This is Association:**
- ✅ Medicine and Category are related
- ✅ Both can exist independently
- ✅ Deleting Category doesn't delete Medicine
- ✅ Weak relationship (not composition)

---

## 7️⃣ DEPENDENCY INJECTION 💉

### What is Dependency Injection?
Providing dependencies from outside rather than creating them inside.

### Where You Used It:

#### **A. Constructor Injection**

**Location:** All service classes

```java
// ✅ DEPENDENCY INJECTION: Dependencies injected via constructor
@Service
public class OrderService {
    private final OrderRepository orderRepo;
    private final CatalogClient catalogClient;
    private final PaymentClient paymentClient;
    private final NotificationPublisher notificationPublisher;
    
    // ✅ DEPENDENCY INJECTION: Spring injects dependencies
    public OrderService(OrderRepository orderRepo,
                       CatalogClient catalogClient,
                       PaymentClient paymentClient,
                       NotificationPublisher notificationPublisher) {
        this.orderRepo = orderRepo;
        this.catalogClient = catalogClient;
        this.paymentClient = paymentClient;
        this.notificationPublisher = notificationPublisher;
    }
}
```

**Why This is Dependency Injection:**
- ✅ Dependencies provided from outside (Spring)
- ✅ Class doesn't create its own dependencies
- ✅ Easy to test (can inject mocks)
- ✅ Loose coupling

---

## 8️⃣ ENUM (Special OOP Concept) 🎯

### What is Enum?
Special class representing a fixed set of constants.

### Where You Used It:

#### **A. Role Enum**

**Location:** auth-service

```java
// ✅ ENUM: Fixed set of user roles
public enum Role {
    CUSTOMER,
    ADMIN
}

// Usage
@Entity
public class User {
    @ElementCollection(fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    private Set<Role> roles;
}
```

#### **B. OrderStatus Enum**

**Location:** order-service

```java
// ✅ ENUM: Fixed set of order statuses
public enum OrderStatus {
    AWAITING_PRESCRIPTION,
    PENDING,
    PAID,
    PACKED,
    SHIPPED,
    DELIVERED,
    CANCELLED
}

// Usage
@Entity
public class Order {
    @Enumerated(EnumType.STRING)
    private OrderStatus status = OrderStatus.PENDING;
}
```

**Why This is OOP:**
- ✅ Type-safe constants
- ✅ Cannot create invalid values
- ✅ Can add methods to enum
- ✅ Better than string constants

---

## 📊 Summary Table

| OOP Concept | Where Used | Example Files |
|-------------|------------|---------------|
| **Encapsulation** | All entities, services, DTOs | User.java, AuthService.java, LoginRequest.java |
| **Inheritance** | Exception classes, Filters | UserNotFoundException.java, JwtAuthFilter.java |
| **Polymorphism** | Repository interfaces, Exception handling | MedicineRepository.java, GlobalExceptionHandler.java |
| **Abstraction** | Repository layer, Service layer, Feign clients | JpaRepository, CatalogClient.java |
| **Composition** | Order-OrderItem, Service dependencies | Order.java, AuthService.java |
| **Association** | Medicine-Category | Medicine.java |
| **Dependency Injection** | All services, controllers | OrderService.java, AuthController.java |
| **Enum** | Role, OrderStatus, PaymentStatus | Role.java, Order.OrderStatus |

---

## 🎤 Interview Questions & Answers

### Q1: Explain encapsulation with an example from your project.

**Answer:** "In my project, I used encapsulation extensively in entity classes like User. All fields are private (id, email, password), and I provide public getters and setters for controlled access. For example, the password field is private and can only be accessed through getPassword() and setPassword() methods. This allows me to add validation or encryption logic in the setter without affecting external code. In the AuthService, I encapsulate the password hashing logic - the controller just calls signup(), it doesn't need to know that I'm using BCrypt for hashing."

### Q2: Where did you use inheritance?

**Answer:** "I used inheritance in two main places:
1. **Exception Hierarchy:** All my custom exceptions like UserNotFoundException, OrderNotFoundException extend RuntimeException. This allows me to catch all custom exceptions using the parent class and inherit exception handling mechanisms.
2. **Spring Filters:** My JwtAuthFilter extends OncePerRequestFilter from Spring. This gives me the filter lifecycle management and I just override the doFilterInternal() method to add JWT validation logic."

### Q3: Explain polymorphism in your project.

**Answer:** "I used polymorphism in several ways:
1. **Method Overriding:** My JwtAuthFilter overrides doFilterInternal() from OncePerRequestFilter. Spring calls my implementation at runtime.
2. **Interface Implementation:** All my repositories extend JpaRepository interface. Spring Data JPA provides the actual implementation at runtime. I can call findAll(), save(), etc. without knowing the implementation details.
3. **Exception Handling:** My GlobalExceptionHandler has a method that handles RuntimeException, which can catch all subclasses like UserNotFoundException, OrderNotFoundException polymorphically."

### Q4: How did you use abstraction?

**Answer:** "Abstraction is everywhere in my project:
1. **Repository Layer:** JpaRepository abstracts all database operations. I don't write SQL, manage connections, or handle transactions manually.
2. **Service Layer:** Controllers don't know business logic details. They just call authService.login() without knowing about password verification, JWT generation, etc.
3. **Feign Clients:** CatalogClient abstracts HTTP communication. OrderService just calls catalogClient.getMedicineById() without worrying about HTTP requests, JSON serialization, or service discovery."

### Q5: Explain composition vs association.

**Answer:** "In my project:
- **Composition (strong):** Order and OrderItem have composition. Order 'has-a' list of OrderItems. If I delete an Order, all its OrderItems are automatically deleted (cascade). OrderItems cannot exist without an Order.
- **Association (weak):** Medicine and Category have association. Medicine 'has-a' Category, but both can exist independently. Deleting a Category doesn't delete Medicines."

---

## 💡 Key Takeaways

1. ✅ **Encapsulation:** Used in all entities and services to hide implementation
2. ✅ **Inheritance:** Used for exception hierarchy and Spring framework extensions
3. ✅ **Polymorphism:** Used in repositories, exception handling, and method overriding
4. ✅ **Abstraction:** Used in repository layer, service layer, and Feign clients
5. ✅ **Composition:** Used in Order-OrderItem relationship and service dependencies
6. ✅ **Association:** Used in Medicine-Category relationship
7. ✅ **Dependency Injection:** Used throughout for loose coupling
8. ✅ **Enum:** Used for type-safe constants (Role, OrderStatus)

---

**Remember:** OOP concepts are not just theoretical - you've used them practically to build a production-grade application! 🚀
