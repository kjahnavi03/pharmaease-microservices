-- Add 6 more medicines to catalog_db (corrected for actual table structure)
USE catalog_db;

-- 1. Diabetes Medicine
INSERT INTO medicines (name, description, price, stock_quantity, requires_prescription, expiry_date, category_id)
VALUES ('Metformin 500mg', 'Oral diabetes medicine that helps control blood sugar levels for type 2 diabetes', 120.00, 150, 1, '2026-12-31', NULL);

-- 2. Blood Pressure Medicine
INSERT INTO medicines (name, description, price, stock_quantity, requires_prescription, expiry_date, category_id)
VALUES ('Amlodipine 5mg', 'Calcium channel blocker for high blood pressure and chest pain', 95.00, 200, 1, '2026-12-31', NULL);

-- 3. Antibiotic
INSERT INTO medicines (name, description, price, stock_quantity, requires_prescription, expiry_date, category_id)
VALUES ('Azithromycin 500mg', 'Antibiotic for bacterial infections including respiratory and skin infections', 180.00, 100, 1, '2026-06-30', NULL);

-- 4. Vitamin Supplement (No prescription)
INSERT INTO medicines (name, description, price, stock_quantity, requires_prescription, expiry_date, category_id)
VALUES ('Vitamin D3 60K', 'Vitamin D3 supplement for bone health immunity and overall wellness', 85.00, 300, 0, '2027-12-31', NULL);

-- 5. Thyroid Medicine
INSERT INTO medicines (name, description, price, stock_quantity, requires_prescription, expiry_date, category_id)
VALUES ('Thyronorm 50mcg', 'Levothyroxine for hypothyroidism to restore normal thyroid hormone levels', 75.00, 180, 1, '2026-12-31', NULL);

-- 6. Antacid (No prescription)
INSERT INTO medicines (name, description, price, stock_quantity, requires_prescription, expiry_date, category_id)
VALUES ('Pantoprazole 40mg', 'Proton pump inhibitor for acid reflux heartburn and stomach ulcers', 65.00, 250, 0, '2026-12-31', NULL);

-- Verify
SELECT id, name, price, requires_prescription, stock_quantity FROM medicines ORDER BY id;
