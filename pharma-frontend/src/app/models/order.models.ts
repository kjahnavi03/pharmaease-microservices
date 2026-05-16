export interface OrderItem {
  id?: number;
  medicineId: number;
  medicineName?: string;
  quantity: number;
  unitPrice?: number;
}

export interface Order {
  id?: number;
  customerId: number;
  customerEmail?: string;
  status?: OrderStatus;
  totalAmount?: number;
  deliveryAddress: string;
  prescriptionId?: number;
  createdAt?: string;
  statusChangedAt?: string;
  items: OrderItem[];
}

export type OrderStatus = 'AWAITING_PRESCRIPTION' | 'PENDING' | 'PAID' | 'PACKED' | 'SHIPPED' | 'DELIVERED' | 'CANCELLED';

export interface PlaceOrderRequest {
  customerId: number;
  deliveryAddress: string;
  items: { medicineId: number; quantity: number }[];
  prescriptionId?: number;
}

export interface UpdateOrderStatusRequest {
  status: OrderStatus;
}

export interface RevenueResponse {
  revenue: number;
}

export interface CartItem {
  medicine: import('./medicine.models').Medicine;
  quantity: number;
}
