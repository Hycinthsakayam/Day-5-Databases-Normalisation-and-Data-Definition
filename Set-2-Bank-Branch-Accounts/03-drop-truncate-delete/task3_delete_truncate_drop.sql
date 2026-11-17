-- Day 5 - Set 2 : Task 3
-- DELETE vs TRUNCATE vs DROP on a test table (identity value + rollback)

USE BankBranchDB;
GO
IF OBJECT_ID('TestTxn') IS NOT NULL DROP TABLE TestTxn;
CREATE TABLE TestTxn (
    id     INT IDENTITY(1,1) PRIMARY KEY,
    note   VARCHAR(30)
);
INSERT INTO TestTxn (note) VALUES ('row A'), ('row B'), ('row C');
GO
SET NOCOUNT ON;
GO
-- [shot:t3_delete]
-- 1. DELETE inside a transaction, then ROLLBACK
BEGIN TRAN;
    DELETE FROM TestTxn;
    SELECT COUNT(*) AS rows_inside_tran FROM TestTxn;
ROLLBACK;
SELECT COUNT(*) AS rows_after_rollback FROM TestTxn;

-- DELETE for real, then insert a new row
DELETE FROM TestTxn;
INSERT INTO TestTxn (note) VALUES ('after delete');
SELECT id, note FROM TestTxn;   -- id continues from 4, identity is NOT reset
GO
-- [shot:t3_truncate]
-- 2. TRUNCATE inside a transaction, then ROLLBACK
INSERT INTO TestTxn (note) VALUES ('row E'), ('row F');
BEGIN TRAN;
    TRUNCATE TABLE TestTxn;
    SELECT COUNT(*) AS rows_inside_tran FROM TestTxn;
ROLLBACK;
SELECT COUNT(*) AS rows_after_rollback FROM TestTxn;

-- TRUNCATE for real, then insert a new row
TRUNCATE TABLE TestTxn;
INSERT INTO TestTxn (note) VALUES ('after truncate');
SELECT id, note FROM TestTxn;   -- id starts again from 1, identity IS reset
GO
-- [shot:t3_drop]
-- 3. DROP inside a transaction, then ROLLBACK
BEGIN TRAN;
    DROP TABLE TestTxn;
    SELECT CASE WHEN OBJECT_ID('TestTxn') IS NULL THEN 'table gone' ELSE 'table exists' END AS inside_tran;
ROLLBACK;
SELECT CASE WHEN OBJECT_ID('TestTxn') IS NULL THEN 'table gone' ELSE 'table exists' END AS after_rollback;
SELECT id, note FROM TestTxn;

-- DROP for real
DROP TABLE TestTxn;
GO
SELECT * FROM TestTxn;   -- fails, the table and its identity are gone
GO
