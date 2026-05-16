-- Add categories for Syrups and Ointments
USE catalog_db;

-- Add new categories
INSERT INTO categories (name, description) VALUES 
('Syrups', 'Liquid medicines and cough syrups'),
('Ointments & Creams', 'Topical applications and skin treatments');

-- Get category IDs (they should be 10 and 11)
-- Add Syrups (5 medicines)
INSERT INTO medicines (name, description, price, stock_quantity, requires_prescription, expiry_date, category_id) VALUES
('Benadryl Cough Syrup 100ml', 'Relief from dry cough and throat irritation', 95.00, 150, 0, '2026-12-31', 10),
('Chericof Syrup 100ml', 'Cough syrup for wet cough with expectorant action', 85.00, 120, 0, '2026-11-30', 10),
('Ascoril LS Syrup 100ml', 'Relieves cough with mucus and breathing difficulty', 125.00, 100, 1, '2026-10-31', 10),
('Zincovit Syrup 200ml', 'Multivitamin and mineral supplement syrup for immunity', 145.00, 180, 0, '2027-06-30', 10),
('Calpol 250mg Syrup 60ml', 'Paracetamol syrup for fever and pain relief in children', 65.00, 200, 0, '2027-03-31', 10);

-- Add Ointments & Creams (5 medicines)
INSERT INTO medicines (name, description, price, stock_quantity, requires_prescription, expiry_date, category_id) VALUES
('Betnovate Cream 20g', 'Steroid cream for skin inflammation and allergic reactions', 78.00, 140, 1, '2026-09-30', 11),
('Moov Pain Relief Cream 50g', 'Ayurvedic pain relief cream for muscle and joint pain', 125.00, 160, 0, '2027-12-31', 11),
('Boroline Antiseptic Cream 20g', 'Antiseptic cream for cuts wounds and dry skin', 45.00, 220, 0, '2027-06-30', 11),
('Candid Cream 30g', 'Antifungal cream for skin infections and ringworm', 95.00, 130, 1, '2026-12-31', 11),
('Lacto Calamine Lotion 120ml', 'Soothing lotion for skin irritation sunburn and rashes', 115.00, 170, 0, '2027-03-31', 11);

-- Verify the additions
SELECT m.id, m.name, c.name as category, m.price, m.stock_quantity 
FROM medicines m 
LEFT JOIN categories c ON m.category_id = c.id 
WHERE c.name IN ('Syrups', 'Ointments & Creams')
ORDER BY c.name, m.name;
