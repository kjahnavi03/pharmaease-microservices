-- Update syrups and ointments to use disease-based categories instead of separate categories
USE catalog_db;

-- First, let's remove the medicines we just added
DELETE FROM medicines WHERE id >= 18;

-- Remove the Syrups and Ointments categories
DELETE FROM categories WHERE name IN ('Syrups', 'Ointments & Creams');

-- Now add medicines with proper disease-based categories
-- Category IDs: 1=Pain Relief, 2=Diabetes, 3=Cardiovascular, 4=Antibiotics, 
--               5=Vitamins & Supplements, 6=Thyroid, 7=Gastro & Acidity, 
--               8=Allergy & Cold, 9=Cholesterol

-- SYRUPS (5 medicines)
INSERT INTO medicines (name, description, price, stock_quantity, requires_prescription, expiry_date, category_id) VALUES
-- Allergy & Cold category
('Benadryl Cough Syrup 100ml', 'Relief from dry cough and throat irritation', 95.00, 150, 0, '2026-12-31', 8),
('Chericof Syrup 100ml', 'Cough syrup for wet cough with expectorant action', 85.00, 120, 0, '2026-11-30', 8),
('Ascoril LS Syrup 100ml', 'Relieves cough with mucus and breathing difficulty', 125.00, 100, 1, '2026-10-31', 8),

-- Vitamins & Supplements category
('Zincovit Syrup 200ml', 'Multivitamin and mineral supplement syrup for immunity', 145.00, 180, 0, '2027-06-30', 5),

-- Pain Relief category
('Calpol 250mg Syrup 60ml', 'Paracetamol syrup for fever and pain relief in children', 65.00, 200, 0, '2027-03-31', 1);

-- OINTMENTS & CREAMS (5 medicines)
INSERT INTO medicines (name, description, price, stock_quantity, requires_prescription, expiry_date, category_id) VALUES
-- Allergy & Cold category
('Betnovate Cream 20g', 'Steroid cream for skin inflammation and allergic reactions', 78.00, 140, 1, '2026-09-30', 8),
('Lacto Calamine Lotion 120ml', 'Soothing lotion for skin irritation sunburn and rashes', 115.00, 170, 0, '2027-03-31', 8),

-- Pain Relief category
('Moov Pain Relief Cream 50g', 'Ayurvedic pain relief cream for muscle and joint pain', 125.00, 160, 0, '2027-12-31', 1),
('Boroline Antiseptic Cream 20g', 'Antiseptic cream for cuts wounds and dry skin', 45.00, 220, 0, '2027-06-30', 1),

-- Antibiotics category (antifungal)
('Candid Cream 30g', 'Antifungal cream for skin infections and ringworm', 95.00, 130, 1, '2026-12-31', 4);

-- Verify the additions
SELECT m.id, m.name, c.name as category, m.price, m.stock_quantity, m.requires_prescription
FROM medicines m 
LEFT JOIN categories c ON m.category_id = c.id 
WHERE m.id >= 18
ORDER BY c.name, m.name;
