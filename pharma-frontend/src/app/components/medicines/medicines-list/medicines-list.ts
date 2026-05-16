import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { MedicineService } from '../../../services/medicine.service';
import { CartService } from '../../../services/cart.service';
import { AuthService } from '../../../services/auth.service';
import { Medicine } from '../../../models/medicine.models';

@Component({
  selector: 'app-medicines-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './medicines-list.html',
  styleUrls: ['./medicines-list.scss']
})
export class MedicinesListComponent implements OnInit {
  medicineService = inject(MedicineService);
  cart = inject(CartService);
  auth = inject(AuthService);

  medicines: Medicine[] = [];
  filtered: Medicine[] = [];
  loading = false;
  searchQuery = '';
  filterRx: 'all' | 'rx' | 'otc' = 'all';
  filterCategory: string = 'all'; // New category filter
  sortBy: 'name' | 'price-asc' | 'price-desc' = 'name';
  addedToCart: Set<number> = new Set();

  // Available categories extracted from medicines
  categories: string[] = [];

  ngOnInit() {
    this.loadMedicines();
  }

  loadMedicines() {
    this.loading = true;
    this.medicineService.getAllMedicines().subscribe({
      next: (data) => {
        this.medicines = data;
        this.extractCategories();
        this.applyFilters();
        this.loading = false;
      },
      error: () => { this.loading = false; }
    });
  }

  extractCategories() {
    // Extract unique categories from medicines
    const categorySet = new Set<string>();
    this.medicines.forEach(m => {
      if (m.categoryName) {
        categorySet.add(m.categoryName);
      }
    });
    this.categories = Array.from(categorySet).sort();
  }

  onSearch() {
    if (this.searchQuery.trim().length >= 2) {
      this.medicineService.searchMedicines(this.searchQuery).subscribe({
        next: (data) => {
          this.medicines = data;
          this.applyFilters();
        }
      });
    } else if (this.searchQuery.trim().length === 0) {
      this.loadMedicines();
    }
  }

  applyFilters() {
    let result = [...this.medicines];

    // Filter by prescription requirement
    if (this.filterRx === 'rx') result = result.filter(m => m.requiresPrescription);
    if (this.filterRx === 'otc') result = result.filter(m => !m.requiresPrescription);

    // Filter by category
    if (this.filterCategory !== 'all') {
      result = result.filter(m => m.categoryName === this.filterCategory);
    }

    // Sort
    if (this.sortBy === 'name') result.sort((a, b) => a.name.localeCompare(b.name));
    if (this.sortBy === 'price-asc') result.sort((a, b) => a.price - b.price);
    if (this.sortBy === 'price-desc') result.sort((a, b) => b.price - a.price);

    this.filtered = result;
  }

  loginRequired = false;

  addToCart(medicine: Medicine) {
    const added = this.cart.addToCart(medicine);
    if (added) {
      this.addedToCart.add(medicine.id!);
      setTimeout(() => this.addedToCart.delete(medicine.id!), 1500);
    } else {
      this.loginRequired = true;
      setTimeout(() => this.loginRequired = false, 3000);
    }
  }
}
