-- Day 5 - Set 3 : Task 3
-- ALTER TABLE : add a column, rename a table, drop a constraint

USE HospitalDB;
GO
-- [shot:t3_add_column]
-- 1. add insurance_id to Patient
ALTER TABLE Patient ADD insurance_id VARCHAR(20) NULL;
GO
UPDATE Patient SET insurance_id = 'STAR-HL-77812' WHERE patient_id = 5001;
UPDATE Patient SET insurance_id = 'ICICI-LMB-4501' WHERE patient_id = 5004;

SELECT patient_id, full_name, insurance_id FROM Patient WHERE patient_id <= 5005;
GO
-- [shot:t3_rename]
-- 2. rename Billing to PatientBill
EXEC sp_rename 'Billing', 'PatientBill';
GO
SELECT name AS table_name FROM sys.tables ORDER BY name;

SELECT name AS foreign_key, OBJECT_NAME(parent_object_id) AS child_table,
       OBJECT_NAME(referenced_object_id) AS parent_table
FROM sys.foreign_keys WHERE name = 'FK_Billing_Visit';
GO
SELECT TOP 1 * FROM Billing;   -- old name no longer works
GO
-- [shot:t3_drop_constraint]
-- 3. drop the UNIQUE constraint on doctor phone (doctors can share the department landline)
INSERT INTO Doctor (doctor_name, specialisation, phone, dept_id)
VALUES ('Dr. Kiran Shetty', 'Cardiologist', '9840200002', 1);    -- fails, phone already used
GO
ALTER TABLE Doctor DROP CONSTRAINT UQ_Doctor_Phone;
GO
INSERT INTO Doctor (doctor_name, specialisation, phone, dept_id)
VALUES ('Dr. Kiran Shetty', 'Cardiologist', '9840200002', 1);    -- works now

SELECT doctor_id, doctor_name, phone FROM Doctor WHERE phone = '9840200002';
GO
