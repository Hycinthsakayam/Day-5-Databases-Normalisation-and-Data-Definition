-- Day 5 - Set 3 : Hospital Patient Records
-- seed_data.sql : sample rows for every table

USE HospitalDB;
GO
INSERT INTO Department (dept_name, floor_no) VALUES
('Cardiology', 2), ('Cardiothoracic Surgery', 3), ('General Medicine', 1),
('Orthopaedics', 2), ('Paediatrics', 1);

INSERT INTO Doctor (doctor_name, specialisation, phone, dept_id) VALUES
('Dr. Ramesh Iyer',    'Interventional Cardiology', '9840200001', 1),
('Dr. Sangeetha Rao',  'Cardiologist',              '9840200002', 1),
('Dr. Arvind Kumar',   'Cardiac Surgeon',           '9840200003', 2),
('Dr. Fathima Begum',  'General Physician',         '9840200004', 3),
('Dr. Suresh Babu',    'Diabetologist',             '9840200005', 3),
('Dr. Naveen Reddy',   'Orthopaedic Surgeon',       '9840200006', 4),
('Dr. Shalini Menon',  'Sports Medicine',           '9840200007', 4),
('Dr. Priya Varma',    'Paediatrician',             '9840200008', 5);

INSERT INTO Patient (full_name, date_of_birth, gender, phone, address_line, city) VALUES
('Arun Prakash',  '1980-03-14', 'M', '9000100001', '12, 2nd Main Road, Anna Nagar', 'Chennai'),
('Divya Menon',   '1992-07-22', 'F', '9000100002', '45, Usman Road, T Nagar',       'Chennai'),
('Karthik Raja',  '1975-11-05', 'M', '9000100003', '7, Lake View Street',           'Chennai'),
('Meena Iyer',    '1968-01-30', 'F', '9000100004', '22, 5th Block, Koramangala',    'Bengaluru'),
('Rahul Sharma',  '2001-09-18', 'M', '9000100005', '9, HSR Layout',                 'Bengaluru'),
('Sneha Patil',   '2016-04-02', 'F', '9000100006', '101, DLF Road, Gachibowli',     'Hyderabad'),
('Vikram Singh',  '1958-12-25', 'M', '9000100007', '3, Kondapur Main Road',         'Hyderabad'),
('Priya Nair',    '1988-06-10', 'F', '9000100008', '18, Velachery Bypass',          'Chennai'),
('Lakshmi Devi',  '1950-08-08', 'F', '9000100009', '5, Mylapore Tank Street',       'Chennai'),
('Aarav Gupta',   '2019-02-14', 'M', '9000100010', '60, Indiranagar',               'Bengaluru');

INSERT INTO Visit (patient_id, doctor_id, visit_date, diagnosis, prescription, status) VALUES
(5001, 101, '2026-09-08', 'Hypertension',            'Amlodipine 5mg once daily',          'Closed'),
(5004, 105, '2026-09-19', 'Type 2 Diabetes',         'Metformin 500mg twice daily',        'Closed'),
(5007, 102, '2026-10-02', 'Coronary Artery Disease', 'Aspirin 75mg, Atorvastatin 20mg',    'Closed'),
(5002, 104, '2026-10-06', 'Viral Fever',             'Paracetamol 650mg, rest 3 days',     'Closed'),
(5005, 106, '2026-10-11', 'Ankle Sprain',            'Ibuprofen 400mg, crepe bandage',     'Closed'),
(5006, 108, '2026-10-15', 'Viral Fever',             'Paracetamol syrup 5ml',              'Closed'),
(5009, 105, '2026-10-21', 'Type 2 Diabetes',         'Glimepiride 1mg once daily',         'Closed'),
(5003, 103, '2026-10-29', 'Coronary Artery Disease', 'Planned for bypass review',          'Open'),
(5008, 107, '2026-11-03', 'Knee Ligament Strain',    'Physiotherapy 2 weeks',              'Open'),
(5010, 108, '2026-11-07', 'Common Cold',             'Saline nasal drops',                 'Closed'),
(5001, 101, '2026-11-10', 'Hypertension',            'Continue Amlodipine 5mg',            'Open'),
(5004, 105, '2026-11-12', 'Type 2 Diabetes',         NULL,                                 'Cancelled');

-- status not given, so it takes the default 'Open'
INSERT INTO Visit (patient_id, doctor_id, visit_date, diagnosis, prescription)
VALUES (5007, 102, '2026-11-14', 'Chest Pain - Evaluation', 'ECG and Troponin test');

INSERT INTO Billing (visit_id, bill_date, bill_amount, paid) VALUES
(1, '2026-09-08',  800.00, 1), (2, '2026-09-19',  650.00, 1),
(3, '2026-10-02', 4500.00, 1), (4, '2026-10-06',  500.00, 1),
(5, '2026-10-11', 1200.00, 1), (6, '2026-10-15',  450.00, 1),
(7, '2026-10-21',  700.00, 0), (8, '2026-10-29', 2500.00, 0),
(9, '2026-11-03', 1800.00, 0), (10,'2026-11-07',  350.00, 1),
(11,'2026-11-10',  800.00, 0);
GO
-- [shot:t2_tests]
-- default status
SELECT visit_id, diagnosis, status FROM Visit WHERE visit_id = 13;
GO
-- visit date in the future (should fail)
INSERT INTO Visit (patient_id, doctor_id, visit_date, diagnosis)
VALUES (5002, 104, '2027-01-15', 'Follow up');
GO
-- negative bill amount (should fail)
INSERT INTO Billing (visit_id, bill_amount) VALUES (12, -100.00);
GO
-- [shot:t4_counts]
SELECT 'Department' AS table_name, COUNT(*) AS rows FROM Department
UNION ALL SELECT 'Doctor',  COUNT(*) FROM Doctor
UNION ALL SELECT 'Patient', COUNT(*) FROM Patient
UNION ALL SELECT 'Visit',   COUNT(*) FROM Visit
UNION ALL SELECT 'Billing', COUNT(*) FROM Billing;
GO
