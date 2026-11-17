-- Day 5 - Set 2 : Bank Branch Accounts
-- seed_data.sql : sample rows for every table

USE BankBranchDB;
GO
-- [shot:t4_seed]
INSERT INTO Branch (branch_code, branch_name, city) VALUES
('CHN001', 'Anna Nagar',   'Chennai'),
('CHN002', 'T Nagar',      'Chennai'),
('BLR001', 'Koramangala',  'Bengaluru'),
('HYD001', 'Gachibowli',   'Hyderabad');

INSERT INTO RelationshipManager (rm_name, phone, branch_id) VALUES
('Suresh Kumar',  '9840100001', 1),
('Anitha Raj',    '9840100002', 1),
('Mohan Das',     '9840100003', 2),
('Kavya Reddy',   '9840100004', 3),
('Imran Sheikh',  '9840100005', 4);

INSERT INTO Customer (full_name, pan_no, phone, address_line, city) VALUES
('Arun Prakash',   'ABCPA1234K', '9000000001', '12, 2nd Main Road, Anna Nagar', 'Chennai'),
('Divya Menon',    'BCDPM2345L', '9000000002', '45, Usman Road, T Nagar',       'Chennai'),
('Karthik Raja',   'CDEPR3456M', '9000000003', '7, Lake View Street',           'Chennai'),
('Meena Iyer',     'DEFPI4567N', '9000000004', '22, 5th Block, Koramangala',    'Bengaluru'),
('Rahul Sharma',   'EFGPS5678P', '9000000005', '9, HSR Layout',                 'Bengaluru'),
('Sneha Patil',    'FGHPP6789Q', '9000000006', '101, DLF Road, Gachibowli',     'Hyderabad'),
('Vikram Singh',   'GHIPS7890R', '9000000007', '3, Kondapur Main Road',         'Hyderabad'),
('Priya Nair',     'HIJPN8901S', '9000000008', '18, Velachery Bypass',          'Chennai'),
('Lakshmi Devi',   'IJKPD9012T', '9000000009', '5, Mylapore Tank Street',       'Chennai'),
('Sanjay Gupta',   'JKLPG0123U', '9000000010', '60, Indiranagar',               'Bengaluru');

INSERT INTO Account (account_number, account_type, branch_id, rm_id, balance, opened_on, status) VALUES
('100100000001', 'Savings', 1, 1,  85000.00, '2025-04-10', 'Active'),
('100100000002', 'Current', 1, 2, 240000.00, '2026-07-05', 'Active'),
('100100000003', 'Savings', 2, 3,  12000.00, '2026-07-21', 'Active'),
('100100000004', 'Savings', 3, 4,  98000.00, '2026-08-14', 'Active'),
('100100000005', 'Current', 3, 4, -15000.00, '2026-08-30', 'Active'),   -- overdraft allowed on current
('100100000006', 'Savings', 4, 5, 150000.00, '2026-09-12', 'Dormant'),
('100100000007', 'Savings', 4, 5,  30500.00, '2026-09-28', 'Active'),
('100100000008', 'Savings', 1, 1,  67000.00, '2026-10-03', 'Active'),
('100100000009', 'Current', 2, 3, 510000.00, '2026-06-25', 'Active'),
('100100000010', 'Savings', 2, NULL, 0.00,   '2024-01-15', 'Closed'),
('100100000011', 'Savings', 1, 2,  55000.00, '2026-08-01', 'Active'),
('100100000012', 'Current', 3, 4,  75000.00, '2026-11-02', 'Active');

INSERT INTO AccountHolder (account_id, customer_id, holder_role) VALUES
(1, 1001, 'Primary'), (2, 1002, 'Primary'), (3, 1003, 'Primary'),
(4, 1004, 'Primary'), (5, 1005, 'Primary'), (6, 1006, 'Primary'),
(7, 1007, 'Primary'), (8, 1008, 'Primary'), (9, 1009, 'Primary'),
(10, 1010, 'Primary'), (11, 1001, 'Primary'), (11, 1008, 'Joint'),
(12, 1010, 'Primary'), (4, 1005, 'Joint');

INSERT INTO AccountTransaction (account_id, txn_date, txn_type, amount, remarks) VALUES
(1, '2026-11-01 10:15', 'CREDIT', 25000.00, 'Salary credit'),
(1, '2026-11-05 18:40', 'DEBIT',   2000.00, 'ATM withdrawal'),
(2, '2026-11-03 12:00', 'CREDIT', 90000.00, 'NEFT from client'),
(3, '2026-10-28 09:30', 'DEBIT',   1500.00, 'UPI - electricity bill'),
(4, '2026-11-10 14:05', 'CREDIT', 10000.00, 'Cash deposit'),
(5, '2026-11-11 16:20', 'DEBIT',  20000.00, 'Cheque 000145'),
(6, '2026-09-15 11:00', 'CREDIT', 150000.00,'Opening deposit'),
(7, '2026-11-12 08:45', 'DEBIT',    499.00, 'UPI - mobile recharge'),
(8, '2026-11-13 19:10', 'CREDIT',  5000.00, 'IMPS from Priya'),
(9, '2026-11-14 13:30', 'DEBIT',  45000.00, 'RTGS to supplier'),
(11,'2026-11-15 10:00', 'CREDIT',  7000.00, 'Interest credit'),
(12,'2026-11-16 17:25', 'CREDIT', 75000.00, 'Opening deposit');
GO
-- [shot:t2_savings_check]
-- savings balance cannot go below zero (should fail)
INSERT INTO Account (account_number, account_type, branch_id, rm_id, balance, opened_on)
VALUES ('100100000099', 'Savings', 1, 1, -500.00, '2026-11-17');
GO
-- duplicate account number (should fail)
INSERT INTO Account (account_number, account_type, branch_id, rm_id, balance, opened_on)
VALUES ('100100000001', 'Current', 1, 1, 1000.00, '2026-11-17');
GO
-- [shot:t4_counts]
SELECT 'Branch' AS table_name, COUNT(*) AS rows FROM Branch
UNION ALL SELECT 'RelationshipManager', COUNT(*) FROM RelationshipManager
UNION ALL SELECT 'Customer',            COUNT(*) FROM Customer
UNION ALL SELECT 'Account',             COUNT(*) FROM Account
UNION ALL SELECT 'AccountHolder',       COUNT(*) FROM AccountHolder
UNION ALL SELECT 'AccountTransaction',  COUNT(*) FROM AccountTransaction;
GO
