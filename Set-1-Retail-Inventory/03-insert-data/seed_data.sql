/* =====================================================================
   Day 5 - Set 1 : Retail Inventory and Product Reviews
   File          : seed_data.sql   (Task 3 - part A)
   Purpose       : Insert at least 10 valid rows into every table.
   ===================================================================== */

USE RetailInventoryDB;
GO
SET NOCOUNT OFF;
GO

/* ---------- Category (10 rows) ---------- */
INSERT INTO dbo.Category (category_name) VALUES
 ('Electronics'), ('Groceries'), ('Stationery'), ('Home Appliances'), ('Furniture'),
 ('Clothing'), ('Footwear'), ('Sports'), ('Toys'), ('Personal Care');
GO

/* ---------- Supplier (10 rows) ---------- */
INSERT INTO dbo.Supplier (supplier_name, phone, email) VALUES
 ('Sri Lakshmi Traders',   '+91 9840011111', 'sales@srilakshmi.in'),
 ('Chennai Electronics',   '+91 9840022222', 'orders@chennaielec.in'),
 ('Kaveri Foods Pvt Ltd',  '+91 9840033333', 'supply@kaverifoods.in'),
 ('Classmate Distributors','+91 9840044444', 'dist@classmate.in'),
 ('HomeCraft Appliances',  '+91 9840055555', 'b2b@homecraft.in'),
 ('WoodWorks Furniture',   '+91 9840066666', 'trade@woodworks.in'),
 ('Fabindia Wholesale',    '+91 9840077777', 'wholesale@fabwh.in'),
 ('StepUp Footwear',       '+91 9840088888', 'orders@stepup.in'),
 ('Victory Sports',        '+91 9840099999', 'sales@victorysports.in'),
 ('Herbal Care Co',        '+91 9840010101', 'hello@herbalcare.in');
GO

/* ---------- Warehouse (10 rows) ---------- */
INSERT INTO dbo.Warehouse (warehouse_name, city) VALUES
 ('WH-Chennai-North', 'Chennai'),  ('WH-Chennai-South', 'Chennai'),
 ('WH-Bengaluru',     'Bengaluru'),('WH-Hyderabad',     'Hyderabad'),
 ('WH-Coimbatore',    'Coimbatore'),('WH-Madurai',      'Madurai'),
 ('WH-Mumbai',        'Mumbai'),   ('WH-Pune',          'Pune'),
 ('WH-Delhi',         'Delhi'),    ('WH-Kolkata',       'Kolkata');
GO

/* ---------- Product (12 rows; 2 flagged as discontinued) ---------- */
INSERT INTO dbo.Product (sku, product_name, category_id, supplier_id, unit_price, is_discontinued) VALUES
 ('SKU-1001', 'Bluetooth Speaker',        1,  2, 1499.00, 0),
 ('SKU-1002', 'USB-C Charger 25W',        1,  2,  899.00, 0),
 ('SKU-1003', 'Basmati Rice 5kg',         2,  3,  645.00, 0),
 ('SKU-1004', 'A4 Notebook (Pack of 6)',  3,  4,  360.00, 0),
 ('SKU-1005', 'Mixer Grinder 750W',       4,  5, 3299.00, 0),
 ('SKU-1006', 'Study Table',              5,  6, 5499.00, 0),
 ('SKU-1007', 'Cotton Kurta',             6,  7,  799.00, 0),
 ('SKU-1008', 'Running Shoes',            7,  8, 2199.00, 0),
 ('SKU-1009', 'Cricket Bat',              8,  9, 1850.00, 0),
 ('SKU-1010', 'Building Blocks Set',      9,  1,  999.00, 0),
 ('SKU-1011', 'Neem Face Wash',          10, 10,  175.00, 1),   -- discontinued
 ('SKU-1012', 'Wired Earphones (3.5mm)',  1,  2,  299.00, 1);   -- discontinued
GO

/* ---------- Inventory (15 rows) ---------- */
INSERT INTO dbo.Inventory (sku, warehouse_id, quantity, reorder_level) VALUES
 ('SKU-1001', 1,  120, 20), ('SKU-1001', 3,   45, 20),
 ('SKU-1002', 1,  300, 50), ('SKU-1003', 2,  500, 100),
 ('SKU-1004', 5,  250, 40), ('SKU-1005', 4,   35, 10),
 ('SKU-1006', 6,   12,  5), ('SKU-1007', 7,  180, 30),
 ('SKU-1008', 8,   60, 15), ('SKU-1009', 9,   25, 10),
 ('SKU-1010', 10,  90, 20), ('SKU-1011', 2,    8, 10),
 ('SKU-1012', 1,    0, 25), ('SKU-1012', 3,    4, 25);
-- one row uses the DEFAULT values for quantity and reorder_level
INSERT INTO dbo.Inventory (sku, warehouse_id) VALUES ('SKU-1003', 6);
GO

/* ---------- Row counts per table ---------- */
SELECT 'Category'  AS table_name, COUNT(*) AS row_count FROM dbo.Category  UNION ALL
SELECT 'Supplier',               COUNT(*)              FROM dbo.Supplier  UNION ALL
SELECT 'Warehouse',              COUNT(*)              FROM dbo.Warehouse UNION ALL
SELECT 'Product',                COUNT(*)              FROM dbo.Product   UNION ALL
SELECT 'Inventory',              COUNT(*)              FROM dbo.Inventory;
GO

/* ---------- Rebuilt "spreadsheet" view through joins ---------- */
SELECT  p.sku, p.product_name, c.category_name, s.supplier_name, s.phone,
        w.warehouse_name, i.quantity, i.reorder_level
FROM    dbo.Inventory i
JOIN    dbo.Product   p ON p.sku = i.sku
JOIN    dbo.Category  c ON c.category_id = p.category_id
JOIN    dbo.Supplier  s ON s.supplier_id = p.supplier_id
JOIN    dbo.Warehouse w ON w.warehouse_id = i.warehouse_id
ORDER BY p.sku, w.warehouse_name;
GO
