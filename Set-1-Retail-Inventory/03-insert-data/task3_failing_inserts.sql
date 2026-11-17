/* =====================================================================
   Day 5 - Set 1 : Retail Inventory and Product Reviews
   File          : task3_failing_inserts.sql   (Task 3 - part B)
   Purpose       : Four inserts that are meant to fail, one per constraint.
                   Each runs in its own batch so the others still run.
   ===================================================================== */

USE RetailInventoryDB;
GO

PRINT '--- 1) Duplicate key : SKU-1001 already exists (PK_Product) ---';
INSERT INTO dbo.Product (sku, product_name, category_id, supplier_id, unit_price)
VALUES ('SKU-1001', 'Duplicate Speaker', 1, 2, 999.00);
GO

PRINT '--- 2) Missing parent : supplier_id 99 does not exist (FK_Product_Supplier) ---';
INSERT INTO dbo.Product (sku, product_name, category_id, supplier_id, unit_price)
VALUES ('SKU-2001', 'Smart Watch', 1, 99, 2499.00);
GO

PRINT '--- 3) Negative quantity : -5 breaks CK_Inventory_Qty ---';
INSERT INTO dbo.Inventory (sku, warehouse_id, quantity, reorder_level)
VALUES ('SKU-1002', 4, -5, 10);
GO

PRINT '--- 4) NULL in a mandatory column : product_name is NOT NULL ---';
INSERT INTO dbo.Product (sku, product_name, category_id, supplier_id, unit_price)
VALUES ('SKU-2002', NULL, 2, 3, 120.00);
GO

PRINT '--- Check : none of the failed rows were stored ---';
SELECT (SELECT COUNT(*) FROM dbo.Product   WHERE sku IN ('SKU-2001','SKU-2002')) AS bad_products_saved,
       (SELECT COUNT(*) FROM dbo.Inventory WHERE quantity < 0)                   AS negative_rows_saved,
       (SELECT COUNT(*) FROM dbo.Product)                                       AS product_rows;
GO
