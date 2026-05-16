/**
 * PrescriptionsComponent — The customer's prescription management page (/prescriptions).
 *
 * WHAT IT SHOWS:
 *   1. Upload section — a drag-and-drop file picker for prescription images + "Upload" button
 *   2. Prescription history — cards showing all uploaded prescriptions with their status
 *
 * PRESCRIPTION STATUS FLOW:
 *   PENDING → (admin reviews) → APPROVED or REJECTED
 *
 *   PENDING  = ⏳ orange  — waiting for admin to review
 *   APPROVED = ✅ green   — admin approved, customer can buy Rx medicines
 *   REJECTED = ❌ red     — admin rejected with a reason
 *
 * HOW UPLOAD WORKS:
 *   The user drags & drops (or browses) an image file.
 *   The file is converted to a base64 data URL on the frontend.
 *   The data URL is sent as the imageUrl to the backend prescription endpoint.
 *
 * WHY PRESCRIPTIONS?
 *   Some medicines require a valid prescription (requiresPrescription = true).
 *   Customers must upload a prescription and get it approved before buying those medicines.
 *   The admin reviews the image and approves or rejects it.
 *
 * IMAGE ERROR HANDLING:
 *   onImgError() is called if the prescription image URL fails to load.
 *   It replaces the broken image with a placeholder image.
 */

import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MedicineService } from '../../services/medicine.service';
import { AuthService } from '../../services/auth.service';
import { Prescription } from '../../models/medicine.models';

@Component({
  selector: 'app-prescriptions',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './prescriptions.html',
  styleUrls: ['./prescriptions.scss']
})
export class PrescriptionsComponent implements OnInit {
  medicineService = inject(MedicineService);
  auth            = inject(AuthService);

  /** All prescriptions uploaded by the current customer */
  prescriptions: Prescription[] = [];

  /** Controls the loading spinner while fetching prescriptions */
  loading = false;

  /** Controls the loading spinner on the Upload button */
  uploading = false;

  /** The selected file from drag-drop or file picker */
  selectedFile: File | null = null;

  /** Preview data URL for showing a thumbnail of the selected file */
  previewUrl: string | null = null;

  /** Whether user is currently dragging a file over the drop zone */
  isDragOver = false;

  /** Legacy — kept for backward compat but no longer shown in UI */
  imageUrl = '';

  /** Error message shown if upload fails */
  error = '';

  /** Success message shown after a successful upload */
  success = '';

  ngOnInit() {
    this.loadPrescriptions();
  }

  /**
   * Fetches all prescriptions for the current customer.
   */
  loadPrescriptions() {
    this.loading = true;
    const customerId = this.auth.getUserId();

    this.medicineService.getMyPrescriptions(customerId).subscribe({
      next: (data) => {
        this.prescriptions = data;
        this.loading = false;
      },
      error: () => { this.loading = false; }
    });
  }

  // ── File handling ───────────────────────────────────────────────────────

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
    if (files && files.length > 0) {
      this.handleFile(files[0]);
    }
  }

  onFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      this.handleFile(input.files[0]);
    }
  }

  private handleFile(file: File) {
    // Validate file type
    const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'application/pdf'];
    if (!validTypes.includes(file.type)) {
      this.error = 'Invalid file type. Please upload JPG, PNG, or PDF.';
      return;
    }

    // Validate file size (5MB)
    if (file.size > 5 * 1024 * 1024) {
      this.error = 'File too large. Maximum size is 5MB.';
      return;
    }

    this.error = '';
    this.selectedFile = file;

    // Generate preview for images
    if (file.type.startsWith('image/')) {
      const reader = new FileReader();
      reader.onload = () => {
        this.previewUrl = reader.result as string;
      };
      reader.readAsDataURL(file);
    } else {
      this.previewUrl = null; // No preview for PDFs
    }
  }

  removeFile(event: Event) {
    event.stopPropagation(); // Don't trigger the drop zone click
    this.selectedFile = null;
    this.previewUrl = null;
  }

  // ── Upload ──────────────────────────────────────────────────────────────

  /**
   * Uploads the selected file as a base64 data URL for admin review.
   */
  uploadPrescription() {
    if (!this.selectedFile) {
      this.error = 'Please select a prescription file.';
      return;
    }

    this.uploading = true;
    this.error = '';
    this.success = '';

    // Convert file to base64 data URL
    const reader = new FileReader();
    reader.onload = () => {
      const dataUrl = reader.result as string;
      const customerId = this.auth.getUserId();
      const email      = this.auth.getUserEmail();

      this.medicineService.uploadPrescription(customerId, dataUrl, email).subscribe({
        next: () => {
          this.uploading = false;
          this.success = 'Prescription uploaded successfully! Awaiting admin review.';
          this.selectedFile = null;
          this.previewUrl = null;
          this.loadPrescriptions();
        },
        error: (err) => {
          this.uploading = false;
          this.error = err.error?.message || 'Upload failed. Please try again.';
        }
      });
    };
    reader.onerror = () => {
      this.uploading = false;
      this.error = 'Failed to read the file. Please try again.';
    };
    reader.readAsDataURL(this.selectedFile);
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  onImgError(event: Event) {
    (event.target as HTMLImageElement).src =
      'https://placehold.co/300x200/1a1a2e/white?text=Prescription';
  }

  getStatusClass(status: string): string {
    const map: Record<string, string> = {
      PENDING:  'status-pending',
      APPROVED: 'status-approved',
      REJECTED: 'status-rejected'
    };
    return map[status] || '';
  }

  getStatusIcon(status: string): string {
    const map: Record<string, string> = {
      PENDING: '⏳', APPROVED: '✅', REJECTED: '❌'
    };
    return map[status] || '⏳';
  }
}
