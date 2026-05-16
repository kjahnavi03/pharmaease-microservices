-- Add more medicines for different diseases to catalog_db
-- Run this script in MySQL to add 6 new medicines

USE catalog_db;

-- 1. Diabetes Medicine
INSERT INTO medicine (name, description, price, category, manufacturer, stock_quantity, requires_prescription, image_url, created_at, updated_at)
VALUES (
    'Metformin 500mg',
    'Oral diabetes medicine that helps control blood sugar levels. Used to treat type 2 diabetes.',
    120.00,
    'Diabetes',
    'Sun Pharma',
    150,
    true,
    'https://via.placeholder.com/200x200/4A90E2/FFFFFF?text=Metformin',
    NOW(),
    NOW()
);

-- 2. Blood Pressure Medicine
INSERT INTO medicine (name, description, price, category, manufacturer, stock_quantity, requires_prescription, image_url, created_at, updated_at)
VALUES (
    'Amlodipine 5mg',
    'Calcium channel blocker used to treat high blood pressure and chest pain (angina).',
    95.00,
    'Cardiovascular',
    'Cipla',
    200,
    true,
    'https://via.placeholder.com/200x200/E74C3C/FFFFFF?text=Amlodipine',
    NOW(),
    NOW()
);

-- 3. Antibiotic
INSERT INTO medicine (name, description, price, category, manufacturer, stock_quantity, requires_prescription, image_url, created_at, updated_at)
VALUES (
    'Azithromycin 500mg',
    'Antibiotic used to treat various bacterial infections including respiratory infections, skin infections, and ear infections.',
    180.00,
    'Antibiotic',
    'Dr. Reddy\'s',
    100,
    true,
    'https://via.placeholder.com/200x200/27AE60/FFFFFF?text=Azithromycin',
    NOW(),
    NOW()
);

-- 4. Vitamin Supplement (No prescription)
INSERT INTO medicine (name, description, price, category, manufacturer, stock_quantity, requires_prescription, image_url, created_at, updated_at)
VALUES (
    'Vitamin D3 60K',
    'Vitamin D3 supplement for bone health, immunity, and overall wellness. Helps prevent vitamin D deficiency.',
    85.00,
    'Vitamins',
    'HealthKart',
    300,
    false,
    'https://via.placeholder.com/200x200/F39C12/FFFFFF?text=Vitamin+D3',
    NOW(),
    NOW()
);

-- 5. Thyroid Medicine
INSERT INTO medicine (name, description, price, category, manufacturer, stock_quantity, requires_prescription, image_url, created_at, updated_at)
VALUES (
    'Thyronorm 50mcg',
    'Levothyroxine sodium used to treat hypothyroidism (underactive thyroid). Helps restore normal thyroid hormone levels.',
    75.00,
    'Endocrine',
    'Abbott',
    180,
    true,
    'https://via.placeholder.com/200x200/9B59B6/FFFFFF?text=Thyronorm',
    NOW(),
    NOW()
);

-- 6. Antacid (No prescription)
INSERT INTO medicine (name, description, price, category, manufacturer, stock_quantity, requires_prescription, image_url, created_at, updated_at)
VALUES (
    'Pantoprazole 40mg',
    'Proton pump inhibitor used to treat acid reflux, heartburn, and stomach ulcers. Reduces stomach acid production.',
    65.00,
    'Gastro',
    'Lupin',
    250,
    false,
    'https://via.placeholder.com/200x200/1ABC9C/FFFFFF?text=Pantoprazole',
    NOW(),
    NOW()
);

-- Verify the medicines were added
SELECT id, name, category, price, requires_prescription, stock_quantity FROM medicine ORDER BY id;
