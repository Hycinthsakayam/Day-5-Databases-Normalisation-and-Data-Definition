/* =====================================================================
   Day 5 - Set 1 : Retail Inventory and Product Reviews
   File          : task4_update_delete.sql   (Task 4)
   Purpose       : UPDATE and DELETE with WHERE, with SELECT before/after.
   ===================================================================== */

USE RetailInventoryDB;
GO

/* ---------- A. Correct a supplier phone number ---------- */
PRINT '=== A1. BEFORE update : Chennai Electronics ===';
SELECT supplier_id, supplier_name, phone
FROM   dbo.Supplier
WHERE  supplier_name = 'Chennai Electronics';
GO

UPDATE dbo.Supplier
SET    phone = '+91 9876543210'
WHERE  supplier_name = 'Chennai Electronics';
GO

PRINT '=== A2. AFTER update : Chennai Electronics ===';
SELECT supplier_id, supplier_name, phone
FROM   dbo.Supplier
WHERE  supplier_name = 'Chennai Electronics';
GO

/* ---------- B. Remove discontinued SKUs ---------- */
PRINT '=== B1. BEFORE delete : discontinued products and their stock rows ===';
SELECT sku, product_name, is_discontinued
FROM   dbo.Product
WHERE  is_discontinued = 1;

SELECT i.sku, i.warehouse_id, i.quantity
FROM   dbo.Inventory i
JOIN   dbo.Product p ON p.sku = i.sku
WHERE  p.is_discontinued = 1;

SELECT (SELECT COUNT(*) FROM dbo.Product)   AS product_rows,
       (SELECT COUNT(*) FROM dbo.Inventory) AS inventory_rows;
GO

DELETE FROM dbo.Product
WHERE  is_discontinued = 1;     -- FK_Inventory_Product ON DELETE CASCADE removes the stock rows
GO

PRINT '=== B2. AFTER delete ===';
SELECT sku, product_name, is_discontinued
FROM   dbo.Product
WHERE  is_discontinued = 1;

SELECT sku, warehouse_id, quantity
FROM   dbo.Inventory
WHERE  sku IN ('SKU-1011', 'SKU-1012');

SELECT (SELECT COUNT(*) FROM dbo.Product)   AS product_rows,
       (SELECT COUNT(*) FROM dbo.Inventory) AS inventory_rows;
GO
