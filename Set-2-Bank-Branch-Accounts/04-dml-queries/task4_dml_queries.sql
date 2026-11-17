-- Day 5 - Set 2 : Task 4
-- insert, update, delete and filtered SELECT

USE BankBranchDB;
GO
-- [shot:t4_insert]
-- new customer opens a savings account
INSERT INTO Customer (full_name, pan_no, phone, address_line, city)
VALUES ('Nithya Ramesh', 'KLMPR1122V', '9000000011', '14, Gandhi Street, Adyar', 'Chennai');

INSERT INTO Account (account_number, account_type, branch_id, rm_id, balance, opened_on)
VALUES ('100100000013', 'Savings', 2, 3, 20000.00, '2026-11-17');

INSERT INTO AccountHolder (account_id, customer_id)
VALUES (SCOPE_IDENTITY(), (SELECT customer_id FROM Customer WHERE pan_no = 'KLMPR1122V'));

SELECT a.account_id, a.account_number, c.full_name, a.account_type, a.balance, a.status
FROM Account a
JOIN AccountHolder h ON h.account_id = a.account_id
JOIN Customer c      ON c.customer_id = h.customer_id
WHERE a.account_number = '100100000013';
GO
-- [shot:t4_update]
-- deposit of 15,000 into account 100100000003 and dormant account made active again
SELECT account_number, balance, status FROM Account
WHERE account_number IN ('100100000003', '100100000006');

UPDATE Account SET balance = balance + 15000
WHERE account_number = '100100000003';

UPDATE Account SET status = 'Active'
WHERE account_number = '100100000006' AND status = 'Dormant';

SELECT account_number, balance, status FROM Account
WHERE account_number IN ('100100000003', '100100000006');
GO
-- [shot:t4_delete]
-- remove the closed account that has no transactions
SELECT account_id, account_number, status, balance FROM Account WHERE status = 'Closed';

DELETE FROM Account
WHERE status = 'Closed' AND balance = 0
  AND account_id NOT IN (SELECT account_id FROM AccountTransaction);

SELECT account_id, account_number, status, balance FROM Account WHERE status = 'Closed';
SELECT COUNT(*) AS holder_rows_for_deleted_account FROM AccountHolder WHERE account_id = 10;  -- removed by cascade
GO
-- [shot:t4_last_quarter]
-- accounts opened in the last quarter with balance above 50,000
DECLARE @q_start DATE = DATEADD(QUARTER, DATEDIFF(QUARTER, 0, GETDATE()) - 1, 0);
DECLARE @q_end   DATE = DATEADD(DAY, -1, DATEADD(QUARTER, DATEDIFF(QUARTER, 0, GETDATE()), 0));
DECLARE @min_balance DECIMAL(12,2) = 50000;

SELECT @q_start AS quarter_start, @q_end AS quarter_end, @min_balance AS threshold;

SELECT a.account_number, c.full_name, a.account_type, b.branch_name,
       a.balance, a.opened_on, a.status
FROM Account a
JOIN AccountHolder h ON h.account_id = a.account_id AND h.holder_role = 'Primary'
JOIN Customer c      ON c.customer_id = h.customer_id
JOIN Branch b        ON b.branch_id = a.branch_id
WHERE a.opened_on BETWEEN @q_start AND @q_end
  AND a.balance > @min_balance
  AND a.account_type IN ('Savings', 'Current')
  AND (a.status = 'Active' OR a.status = 'Dormant')
ORDER BY a.opened_on;
GO
