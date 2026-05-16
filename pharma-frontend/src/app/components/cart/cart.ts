/**
 * CartComponent — The shopping cart page (/cart).
 *
 * PRESCRIPTION FLOW (new):
 *   1. Customer adds a prescription-required medicine to cart.
 *   2. Cart detects this and shows a prescription upload section.
 *   3. Customer uploads a prescription — it is saved with PENDING status.
 *   4. Customer fills in delivery address and clicks "Place Order".
 *   5. Order is created with status AWAITING_PRESCRIPTION (not PENDING).
 *   6. Cart is cleared. Customer sees a confirmation message.
 *   7. Admin approves the prescription → order-service transitions the order to PENDING.
 *   8. Customer visits "My Orders", sees the order is now PENDING, and pays.
 *
 * NON-PRESCRIPTION FLOW (unchanged):
 *   Customer adds medicines → fills address → clicks "Place Order" → goes to /payment/:orderId.
 */

import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { CartService } from '../../services/cart.service';
import { AuthService } from '../../services/auth.service';
import { OrderService } from '../../services/order.service';
import { FormsModule } from '@angular/forms';
import { MedicineService } from '../../services/medicine.service';
import { Prescription } from '../../models/medicine.models';

@Component({
  selector: 'app-cart',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './cart.html',
  styleUrls: ['./cart.scss']
})
export class CartComponent implements OnInit {
  cart            = inject(CartService);
  auth            = inject(AuthService);
  orderService    = inject(OrderService);
  medicineService = inject(MedicineService);
  router          = inject(Router);

  /** Two-way bound to the delivery address textarea */
  deliveryAddress = '';

  /** Shows the loading spinner on the "Place Order" button */
  loading = false;

  /** Shows validation or API error messages */
  error = '';

  /** True when the cart contains at least one prescription-required medicine */
  needsPrescription = false;

  // ── Prescription upload state ──────────────────────────────────────────

  /** The file the customer selected for upload */
  selectedFile: File | null = null;

  /** Base64 preview of the selected file */
  previewUrl: string | null = null;

  /** Whether the user is dragging a file over the drop zone */
  isDragOver = false;

  /** True while the prescription upload API call is in progress */
  uploading = false;

  /** Error message from the upload step */
  uploadError = '';

  /** The prescription that was uploaded and is awaiting admin approval */
  uploadedPrescription: Prescription | null = null;

  /** True once the customer has at least one admin-approved prescription */
  hasApprovedPrescription = false;

  /** Confirmation message shown after a prescription-order is placed */
  prescriptionOrderPlaced = false;

  ngOnInit() {
    this.checkPrescriptionNeeded();
    if (this.auth.isLoggedIn()) {
      this.refreshPrescriptionStatus();
    }
  }

  /** Checks whether any cart item requires a prescription */
  private checkPrescriptionNeeded() {
    this.needsPrescription = this.cart.cartItems().some(i => i.medicine.requiresPrescription);
  }

  /** Fetches the customer's prescriptions and checks for an approved one */
  private refreshPrescriptionStatus() {
    this.medicineService.getMyPrescriptions(this.auth.getUserId()).subscribe({
      next: (prescriptions) => {
        this.hasApprovedPrescription = prescriptions.some(p => p.status === 'APPROVED');
        // If there's a pending prescription already uploaded this session, find it
        if (!this.uploadedPrescription) {
          const pending = prescriptions.find(p => p.status === 'PENDING');
          if (pending) {
            this.uploadedPrescription = pending;
          }
        }
      },
      error: () => { this.hasApprovedPrescription = false; }
    });
  }

  // ── File drag-and-drop ─────────────────────────────────────────────────

  onDragOver(event: DragEvent) {
    event.preventDefault();
    event.stopPropagation();
    this.isDragOver = true;
  }

  onDragLeave(event: DragEvent) {
    event.preventDefault();
    event.stopPropagation();
    this.isDragOver = false;
  }

  onFileDrop(event: DragEvent) {
    event.preventDefault();
    event.stopPropagation();
    this.isDragOver = false;
    const files = event.dataTransfer?.files;
    if (files && files.length > 0) this.handleFile(files[0]);
  }

  onFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) this.handleFile(input.files[0]);
  }

  private handleFile(file: File) {
    const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'application/pdf'];
    if (!validTypes.includes(file.type)) {
      this.uploadError = 'Invalid file type. Please upload JPG, PNG, or PDF.';
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      this.uploadError = 'File too large. Maximum size is 5MB.';
      return;
    }
    this.uploadError = '';
    this.selectedFile = file;
    if (file.type.startsWith('image/')) {
      const reader = new FileReader();
      reader.onload = () => { this.previewUrl = reader.result as string; };
      reader.readAsDataURL(file);
    } else {
      this.previewUrl = null;
    }
  }

  removeFile(event: Event) {
    event.stopPropagation();
    this.selectedFile = null;
    this.previewUrl = null;
  }

  // ── Prescription upload ────────────────────────────────────────────────

  /**
   * Uploads the selected prescription file.
   * On success, stores the returned prescription so its ID can be sent with the order.
   */
  uploadPrescription() {
    if (!this.selectedFile) {
      this.uploadError = 'Please select a prescription file first.';
      return;
    }
    this.uploading = true;
    this.uploadError = '';

    const reader = new FileReader();
    reader.onload = () => {
      const dataUrl = reader.result as string;
      const customerId = this.auth.getUserId();
      const email      = this.auth.getUserEmail();

      this.medicineService.uploadPrescription(customerId, dataUrl, email).subscribe({
        next: (prescription) => {
          this.uploading = false;
          this.uploadedPrescription = prescription;
          this.selectedFile = null;
          this.previewUrl = null;
        },
        error: (err) => {
          this.uploading = false;
          this.uploadError = err.error?.message || 'Upload failed. Please try again.';
        }
      });
    };
    reader.onerror = () => {
      this.uploading = false;
      this.uploadError = 'Failed to read the file. Please try again.';
    };
    reader.readAsDataURL(this.selectedFile);
  }

  // ── Order placement ────────────────────────────────────────────────────

  /**
   * Places the order.
   *
   * If the cart has prescription-required items:
   *   - Requires an uploaded prescription (PENDING or APPROVED).
   *   - If prescription is APPROVED: places order as PENDING → goes to payment.
   *   - If prescription is PENDING: places order as AWAITING_PRESCRIPTION → shows confirmation.
   *
   * If no prescription items: places order as PENDING → goes to payment.
   */
  placeOrder() {
    if (!this.auth.isLoggedIn()) {
      this.router.navigate(['/login']);
      return;
    }
    if (!this.deliveryAddress.trim()) {
      this.error = 'Please enter a delivery address.';
      return;
    }
    if (this.cart.cartItems().length === 0) {
      this.error = 'Your cart is empty.';
      return;
    }

    this.checkPrescriptionNeeded();

    // Prescription-required items: must have uploaded a prescription
    if (this.needsPrescription && !this.hasApprovedPrescription) {
      if (!this.uploadedPrescription) {
        this.error = 'Please upload a prescription for the prescription-required medicines in your cart.';
        return;
      }
      // Prescription is uploaded but still PENDING — place order as AWAITING_PRESCRIPTION
      this.submitOrder(this.uploadedPrescription.id);
      return;
    }

    // No prescription needed, or already approved — place order normally
    this.submitOrder(undefined);
  }

  private submitOrder(prescriptionId: number | undefined) {
    this.loading = true;
    this.error = '';

    const user       = this.auth.currentUser();
    const customerId = this.auth.getUserId();

    const request: any = {
      customerId,
      deliveryAddress: this.deliveryAddress,
      items: this.cart.cartItems().map(i => ({
        medicineId: i.medicine.id!,
        quantity: i.quantity
      }))
    };

    if (prescriptionId != null) {
      request.prescriptionId = prescriptionId;
    }

    this.orderService.placeOrder(request, user?.email ?? '').subscribe({
      next: (order) => {
        this.loading = false;
        this.cart.clearCart();

        if (order.status === 'AWAITING_PRESCRIPTION') {
          // Order is waiting for admin to approve the prescription
          this.prescriptionOrderPlaced = true;
        } else {
          // Normal flow — go to payment
          this.router.navigate(['/payment', order.id]);
        }
      },
      error: (err) => {
        this.loading = false;
        this.error = err.error?.message || 'Failed to place order. Please try again.';
      }
    });
  }
}
