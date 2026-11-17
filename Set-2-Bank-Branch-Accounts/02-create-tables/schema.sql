-- Day 5 - Set 2 : Bank Branch Accounts
-- schema.sql : creates BankBranchDB and the normalised tables

USE master;
GO
IF DB_ID('BankBranchDB') IS NOT NULL
BEGIN
    ALTER DATABASE BankBranchDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BankBranchDB;
END
GO
-- [shot:t2_db]
CREATE DATABASE BankBranchDB;
GO
USE BankBranchDB;
GO
-- [shot:t2_tables]
CREATE TABLE Branch (
    branch_id     INT IDENTITY(1,1) PRIMARY KEY,
    branch_code   CHAR(6)      NOT NULL UNIQUE,      -- e.g. CHN001
    branch_name   VARCHAR(60)  NOT NULL,
    city          VARCHAR(40)  NOT NULL
);

CREATE TABLE RelationshipManager (
    rm_id         INT IDENTITY(1,1) PRIMARY KEY,
    rm_name       VARCHAR(60)  NOT NULL,
    phone         VARCHAR(15)  NOT NULL UNIQUE,
    branch_id     INT          NOT NULL,
    CONSTRAINT FK_RM_Branch FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id) ON DELETE NO ACTION
);

CREATE TABLE Customer (
    customer_id   INT IDENTITY(1001,1) PRIMARY KEY,
    full_name     VARCHAR(60)  NOT NULL,
    pan_no        CHAR(10)     NOT NULL UNIQUE,      -- candidate key
    phone         VARCHAR(15)  NOT NULL,
    address_line  VARCHAR(120) NOT NULL,
    city          VARCHAR(40)  NOT NULL
);

CREATE TABLE Account (
    account_id     INT IDENTITY(1,1) PRIMARY KEY,
    account_number CHAR(12)      NOT NULL,
    account_type   VARCHAR(10)   NOT NULL,
    branch_id      INT           NOT NULL,
    rm_id          INT           NULL,
    balance        DECIMAL(12,2) NOT NULL DEFAULT 0,
    opened_on      DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    status         VARCHAR(10)   NOT NULL DEFAULT 'Active',
    CONSTRAINT UQ_Account_Number  UNIQUE (account_number),
    CONSTRAINT CK_Account_Type    CHECK (account_type IN ('Savings', 'Current')),
    CONSTRAINT CK_Savings_Balance CHECK (account_type <> 'Savings' OR balance >= 0),
    CONSTRAINT CK_Account_Status  CHECK (status IN ('Active', 'Dormant', 'Closed')),
    CONSTRAINT FK_Account_Branch  FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id) ON DELETE NO ACTION,
    CONSTRAINT FK_Account_RM      FOREIGN KEY (rm_id)
        REFERENCES RelationshipManager(rm_id) ON DELETE SET NULL
);

-- one account can have joint holders, so the key is (account_id, customer_id)
CREATE TABLE AccountHolder (
    account_id    INT         NOT NULL,
    customer_id   INT         NOT NULL,
    holder_role   VARCHAR(10) NOT NULL DEFAULT 'Primary',
    CONSTRAINT PK_AccountHolder PRIMARY KEY (account_id, customer_id),
    CONSTRAINT CK_Holder_Role   CHECK (holder_role IN ('Primary', 'Joint')),
    CONSTRAINT FK_Holder_Account  FOREIGN KEY (account_id)
        REFERENCES Account(account_id) ON DELETE CASCADE,
    CONSTRAINT FK_Holder_Customer FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id) ON DELETE NO ACTION
);

CREATE TABLE AccountTransaction (
    txn_id        INT IDENTITY(1,1) PRIMARY KEY,
    account_id    INT           NOT NULL,
    txn_date      DATETIME2(0)  NOT NULL DEFAULT SYSDATETIME(),
    txn_type      VARCHAR(6)    NOT NULL CHECK (txn_type IN ('CREDIT', 'DEBIT')),
    amount        DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    remarks       VARCHAR(100)  NULL,
    CONSTRAINT FK_Txn_Account FOREIGN KEY (account_id)
        REFERENCES Account(account_id) ON DELETE NO ACTION
);
GO
-- [shot:t2_check]
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

SELECT name AS foreign_key,
       OBJECT_NAME(parent_object_id)     AS child_table,
       OBJECT_NAME(referenced_object_id) AS parent_table,
       delete_referential_action_desc    AS on_delete
FROM sys.foreign_keys
ORDER BY child_table;
GO
