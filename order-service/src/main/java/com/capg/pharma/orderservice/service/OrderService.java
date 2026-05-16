package com.capg.pharma.orderservice.service;

import com.capg.pharma.orderservice.client.CatalogClient;
import com.capg.pharma.orderservice.client.PaymentClient;
import com.capg.pharma.orderservice.messaging.NotificationPublisher;
import com.capg.pharma.orderservice.dto.*;
import com.capg.pharma.orderservice.entity.Order;
import com.capg.pharma.orderservice.entity.OrderItem;
import com.capg.pharma.orderservice.exception.InvalidOrderStatusException;
import com.capg.pharma.orderservice.exception.OrderNotFoundException;
import com.capg.pharma.orderservice.repository.OrderRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Business logic service for order management.
 *
 * <p>Handles order placement (with medicine price lookup via Feign),
 * status updates, and revenue reporting. Publishes ORDER_PLACED events
 * to RabbitMQ after successful order creation.</p>
 */
@Service
public class OrderService {

    private static final Logger log = LoggerFactory.getLogger(OrderService.class);

    private final OrderRepository orderRepo;
    private final CatalogClient catalogClient;
    private final PaymentClient paymentClient;
    private final NotificationPublisher notificationPublisher;

    /**
     * Constructs OrderService with required dependencies.
     *
     * @param orderRepo            repository for order persistence
     * @param catalogClient        Feign client for medicine price lookup
     * @param paymentClient        Feign client for payment processing
     * @param notificationPublisher RabbitMQ publisher for order events
     */
    public OrderService(OrderRepository orderRepo, CatalogClient catalogClient,
                        PaymentClient paymentClient, NotificationPublisher notificationPublisher) {
        this.orderRepo = orderRepo;
        this.catalogClient = catalogClient;
        this.paymentClient = paymentClient;
        this.notificationPublisher = notificationPublisher;
    }

    /**
     * Places a new order for a customer.
     *
     * <p>If any item requires a prescription, the order is saved with
     * {@code AWAITING_PRESCRIPTION} status and linked to the provided
     * prescriptionId. The order transitions to {@code PENDING} only after
     * the admin approves the prescription via
     * {@link #approvePrescriptionForOrder(Long)}.</p>
     *
     * Stock decrement is done AFTER the transaction commits to avoid
     * holding the transaction open during cross-service Feign calls.
     */
    @Transactional
    public OrderResponse placeOrder(OrderRequest req, String customerEmail) {
        Order order = new Order();
        order.setCustomerId(req.getCustomerId());
        order.setCustomerEmail(customerEmail);
        order.setDeliveryAddress(req.getDeliveryAddress());

        boolean hasPrescriptionItem = false;
        BigDecimal total = BigDecimal.ZERO;
        for (OrderRequest.OrderItemRequest itemReq : req.getItems()) {
            MedicineDto medicine = catalogClient.getMedicineById(itemReq.getMedicineId());

            // Validate stock before building the item
            if (medicine.getStockQuantity() != null &&
                    medicine.getStockQuantity() < itemReq.getQuantity()) {
                throw new IllegalArgumentException(
                        "Insufficient stock for '" + medicine.getName() +
                        "'. Available: " + medicine.getStockQuantity() +
                        ", requested: " + itemReq.getQuantity());
            }

            if (medicine.isRequiresPrescription()) {
                hasPrescriptionItem = true;
            }

            OrderItem item = new OrderItem();
            item.setOrder(order);
            item.setMedicineId(medicine.getId());
            item.setMedicineName(medicine.getName());
            item.setQuantity(itemReq.getQuantity());
            item.setUnitPrice(medicine.getPrice());
            order.getItems().add(item);
            total = total.add(medicine.getPrice().multiply(BigDecimal.valueOf(itemReq.getQuantity())));
        }
        order.setTotalAmount(total);

        // If any item requires a prescription, hold the order until admin approves
        if (hasPrescriptionItem) {
            if (req.getPrescriptionId() == null) {
                throw new IllegalArgumentException(
                        "A prescription is required for one or more items in this order. " +
                        "Please upload a prescription first.");
            }
            order.setPrescriptionId(req.getPrescriptionId());
            order.setStatus(Order.OrderStatus.AWAITING_PRESCRIPTION);
        }

        Order saved = orderRepo.save(order);

        // Publish notification event — failure is non-critical
        try {
            String statusMsg = hasPrescriptionItem
                    ? "Your order #" + saved.getId() + " is awaiting prescription approval. Total: Rs." + saved.getTotalAmount()
                    : "Your order #" + saved.getId() + " has been placed. Total: Rs." + saved.getTotalAmount();
            notificationPublisher.publish(new NotificationRequest(
                    customerEmail,
                    "Order Placed - #" + saved.getId(),
                    statusMsg,
                    "ORDER_PLACED"
            ));
        } catch (Exception ignored) { /* non-critical */ }

        return toResponse(saved);
    }

    /**
     * Transitions an order from AWAITING_PRESCRIPTION to PENDING after
     * the linked prescription has been approved by an admin.
     *
     * <p>Called by the admin-service after approving a prescription so that
     * all orders linked to that prescription become payable.</p>
     *
     * @param prescriptionId the approved prescription's ID
     * @return list of updated orders
     */
    @Transactional
    public List<OrderResponse> approvePrescriptionForOrder(Long prescriptionId) {
        List<Order> orders = orderRepo.findByPrescriptionIdAndStatus(
                prescriptionId, Order.OrderStatus.AWAITING_PRESCRIPTION);
        for (Order order : orders) {
            order.setStatus(Order.OrderStatus.PENDING);
            orderRepo.save(order);
            try {
                notificationPublisher.publish(new NotificationRequest(
                        order.getCustomerEmail(),
                        "Prescription Approved - Order #" + order.getId(),
                        "Your prescription has been approved! You can now proceed to payment for order #" + order.getId() + ".",
                        "PRESCRIPTION_APPROVED"
                ));
            } catch (Exception ignored) { /* non-critical */ }
        }
        return orders.stream().map(this::toResponse).collect(Collectors.toList());
    }

    /**
     * Decrements stock for all items in an order.
     * Called AFTER placeOrder transaction commits — runs outside any transaction
     * so the Feign HTTP call to catalog-service is not wrapped in a JPA transaction.
     */
    public void decrementStockForOrder(List<OrderRequest.OrderItemRequest> items) {
        for (OrderRequest.OrderItemRequest itemReq : items) {
            try {
                catalogClient.decrementStock(itemReq.getMedicineId(), itemReq.getQuantity());
                log.info("[STOCK] Decremented {} units for medicine id={}",
                        itemReq.getQuantity(), itemReq.getMedicineId());
            } catch (Exception e) {
                log.error("[STOCK] Failed to decrement stock for medicine id={} qty={}: {}",
                        itemReq.getMedicineId(), itemReq.getQuantity(), e.getMessage());
            }
        }
    }

    /**
     * Decrements stock for all items in an order by order ID.
     * Called after successful payment to reduce inventory.
     */
    public void decrementStockForOrderById(Long orderId) {
        log.info("[STOCK] Starting stock decrement for order #{}", orderId);
        Order order = findOrThrow(orderId);
        log.info("[STOCK] Found order #{} with {} items", orderId, order.getItems().size());
        
        for (OrderItem item : order.getItems()) {
            try {
                log.info("[STOCK] Attempting to decrement {} units for medicine id={}", 
                        item.getQuantity(), item.getMedicineId());
                catalogClient.decrementStock(item.getMedicineId(), item.getQuantity());
                log.info("[STOCK] Successfully decremented {} units for medicine id={} (order #{})",
                        item.getQuantity(), item.getMedicineId(), orderId);
            } catch (Exception e) {
                log.error("[STOCK] Failed to decrement stock for medicine id={} qty={} (order #{}): {}",
                        item.getMedicineId(), item.getQuantity(), orderId, e.getMessage(), e);
            }
        }
        log.info("[STOCK] Completed stock decrement for order #{}", orderId);
    }

    /**
     * Retrieves a single order by its ID.
     *
     * @param id the order's primary key
     * @return the order as a response DTO
     * @throws OrderNotFoundException if no order exists with the given ID
     */
    public OrderResponse getById(Long id) {
        return toResponse(findOrThrow(id));
    }

    /**
     * Retrieves all orders placed by a specific customer.
     *
     * @param customerId the customer's ID
     * @return list of orders for that customer
     */
    public List<OrderResponse> getByCustomer(Long customerId) {
        return orderRepo.findByCustomerId(customerId).stream()
                .map(this::toResponse).collect(Collectors.toList());
    }

    /**
     * Retrieves all orders in the system. Admin use only.
     *
     * @return list of all orders
     */
    public List<OrderResponse> getAll() {
        return orderRepo.findAll().stream().map(this::toResponse).collect(Collectors.toList());
    }

    /**
     * Updates the status of an order and sends a notification to the customer.
     * Also updates the statusChangedAt timestamp to track when the change happened.
     *
     * @param id     the order's primary key
     * @param status the new status string (must match an {@link Order.OrderStatus} enum value)
     * @return the updated order as a response DTO
     * @throws OrderNotFoundException      if no order exists with the given ID
     * @throws InvalidOrderStatusException if the status string is not a valid enum value
     */
    public OrderResponse updateStatus(Long id, String status) {
        Order order = findOrThrow(id);
        Order.OrderStatus oldStatus = order.getStatus();
        
        try {
            order.setStatus(Order.OrderStatus.valueOf(status.toUpperCase()));
        } catch (IllegalArgumentException e) {
            throw new InvalidOrderStatusException("Invalid order status: " + status +
                    ". Valid values: AWAITING_PRESCRIPTION, PENDING, PAID, PACKED, SHIPPED, DELIVERED, CANCELLED");
        }
        
        // Update the timestamp to track when this status change happened
        order.setStatusChangedAt(LocalDateTime.now());
        
        Order saved = orderRepo.save(order);
        
        // Send notification to customer about status change
        if (!oldStatus.equals(saved.getStatus())) {
            try {
                String message = buildStatusChangeMessage(saved);
                notificationPublisher.publish(new NotificationRequest(
                        saved.getCustomerEmail(),
                        "Order #" + saved.getId() + " - " + saved.getStatus(),
                        message,
                        "ORDER_STATUS_CHANGED"
                ));
                log.info("[NOTIFICATION] Sent order status notification for order #{} to {}",
                        saved.getId(), saved.getCustomerEmail());
            } catch (Exception e) {
                log.error("[NOTIFICATION] Failed to send status notification for order #{}: {}",
                        saved.getId(), e.getMessage());
            }
        }
        
        return toResponse(saved);
    }

    /**
     * Builds a user-friendly notification message based on the order status.
     *
     * @param order the order with the new status
     * @return notification message string
     */
    private String buildStatusChangeMessage(Order order) {
        return switch (order.getStatus()) {
            case AWAITING_PRESCRIPTION -> 
                "Your order #" + order.getId() + " is awaiting prescription approval. " +
                "We'll notify you once it's approved and ready for payment.";
            case PENDING -> 
                "Your order #" + order.getId() + " is confirmed and awaiting payment. " +
                "Please complete the payment to proceed.";
            case PAID -> 
                "Payment received for order #" + order.getId() + "! " +
                "Your order is being prepared for dispatch.";
            case PACKED -> 
                "Great news! Your order #" + order.getId() + " has been packed and is ready for dispatch. " +
                "It will be shipped soon.";
            case SHIPPED -> 
                "Your order #" + order.getId() + " has been shipped! " +
                "Track your delivery and expect it soon.";
            case DELIVERED -> 
                "Your order #" + order.getId() + " has been delivered! " +
                "Thank you for shopping with PharmaOnline. We hope you enjoy your purchase!";
            case CANCELLED -> 
                "Your order #" + order.getId() + " has been cancelled. " +
                "If you have any questions, please contact our support team.";
        };
    }

    /**
     * Returns the total count of all orders.
     *
     * @return total order count
     */
    public long getCount() {
        return orderRepo.count();
    }

    /**
     * Calculates total revenue from DELIVERED orders within a date range.
     *
     * @param from start date string (ISO format: yyyy-MM-dd)
     * @param to   end date string (ISO format: yyyy-MM-dd)
     * @return total revenue as BigDecimal
     */
    public BigDecimal getRevenueBetween(String from, String to) {
        LocalDateTime fromDt = LocalDate.parse(from).atStartOfDay();
        LocalDateTime toDt = LocalDate.parse(to).atTime(23, 59, 59);
        return orderRepo.sumRevenueBetween(fromDt, toDt);
    }

    /**
     * Finds an order by ID or throws if not found.
     *
     * @param id the order's primary key
     * @return the order entity
     * @throws OrderNotFoundException if not found
     */
    private Order findOrThrow(Long id) {
        return orderRepo.findById(id)
                .orElseThrow(() -> new OrderNotFoundException("Order not found with id: " + id));
    }

    /**
     * Converts an Order entity to an OrderResponse DTO.
     *
     * @param o the order entity
     * @return the response DTO with all fields and items
     */
    private OrderResponse toResponse(Order o) {
        OrderResponse r = new OrderResponse();
        r.setId(o.getId());
        r.setCustomerId(o.getCustomerId());
        r.setCustomerEmail(o.getCustomerEmail());
        r.setStatus(o.getStatus().name());
        r.setTotalAmount(o.getTotalAmount());
        r.setDeliveryAddress(o.getDeliveryAddress());
        r.setPrescriptionId(o.getPrescriptionId());
        r.setCreatedAt(o.getCreatedAt());
        r.setStatusChangedAt(o.getStatusChangedAt());
        r.setItems(o.getItems().stream().map(i -> {
            OrderResponse.ItemDto d = new OrderResponse.ItemDto();
            d.setMedicineId(i.getMedicineId());
            d.setMedicineName(i.getMedicineName());
            d.setQuantity(i.getQuantity());
            d.setUnitPrice(i.getUnitPrice());
            return d;
        }).collect(Collectors.toList()));
        return r;
    }
}
