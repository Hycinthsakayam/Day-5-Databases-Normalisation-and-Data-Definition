-- Day 5 - Set 3 : Task 4
-- insert, update, delete and retrieval with WHERE and LIKE

USE HospitalDB;
GO
-- [shot:t4_insert]
-- new visit for Priya Nair with its bill
INSERT INTO Visit (patient_id, doctor_id, visit_date, diagnosis, prescription)
VALUES (5008, 104, '2026-11-17', 'Migraine', 'Sumatriptan 50mg when needed');

INSERT INTO PatientBill (visit_id, bill_amount) VALUES (SCOPE_IDENTITY(), 600.00);

SELECT v.visit_id, p.full_name, v.visit_date, v.diagnosis, v.status, b.bill_amount, b.paid
FROM Visit v
JOIN Patient p          ON p.patient_id = v.patient_id
LEFT JOIN PatientBill b ON b.visit_id = v.visit_id
WHERE v.visit_date = '2026-11-17';
GO
-- [shot:t4_update]
-- visit 9 is finished, close it and mark the bill as paid
SELECT v.visit_id, v.status, v.prescription, b.paid
FROM Visit v JOIN PatientBill b ON b.visit_id = v.visit_id WHERE v.visit_id = 9;

UPDATE Visit
SET status = 'Closed', prescription = 'Physiotherapy 2 weeks, knee brace'
WHERE visit_id = 9;

UPDATE PatientBill SET paid = 1 WHERE visit_id = 9;

SELECT v.visit_id, v.status, v.prescription, b.paid
FROM Visit v JOIN PatientBill b ON b.visit_id = v.visit_id WHERE v.visit_id = 9;
GO
-- [shot:t4_delete]
-- remove the cancelled visit
SELECT visit_id, patient_id, visit_date, diagnosis, status FROM Visit WHERE status = 'Cancelled';

DELETE FROM Visit WHERE status = 'Cancelled';

SELECT visit_id, patient_id, visit_date, diagnosis, status FROM Visit WHERE status = 'Cancelled';
GO
-- [shot:t4_month]
-- patients who visited in October 2026
SELECT p.patient_id, p.full_name, v.visit_date, v.diagnosis, d.doctor_name
FROM Visit v
JOIN Patient p ON p.patient_id = v.patient_id
JOIN Doctor d  ON d.doctor_id = v.doctor_id
WHERE v.visit_date >= '2026-10-01' AND v.visit_date < '2026-11-01'
ORDER BY v.visit_date;
GO
-- [shot:t4_like]
-- doctors of departments starting with 'Cardio' (Cardiology and Cardiothoracic Surgery)
SELECT d.doctor_id, d.doctor_name, d.specialisation, dp.dept_name
FROM Doctor d
JOIN Department dp ON dp.dept_id = d.dept_id
WHERE dp.dept_name LIKE 'Cardio%'
ORDER BY dp.dept_name, d.doctor_name;

-- doctors whose name starts with 'Dr. S'
SELECT doctor_id, doctor_name, specialisation
FROM Doctor
WHERE doctor_name LIKE 'Dr. S%';
GO
