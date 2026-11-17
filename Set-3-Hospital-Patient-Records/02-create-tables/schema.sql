-- Day 5 - Set 3 : Hospital Patient Records
-- schema.sql : creates HospitalDB and the normalised tables

USE master;
GO
IF DB_ID('HospitalDB') IS NOT NULL
BEGIN
    ALTER DATABASE HospitalDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HospitalDB;
END
GO
CREATE DATABASE HospitalDB;
GO
USE HospitalDB;
GO
-- [shot:t2_tables]
CREATE TABLE Department (
    dept_id      INT IDENTITY(1,1) PRIMARY KEY,
    dept_name    VARCHAR(50) NOT NULL UNIQUE,
    floor_no     TINYINT     NOT NULL
);

CREATE TABLE Doctor (
    doctor_id      INT IDENTITY(101,1) PRIMARY KEY,
    doctor_name    VARCHAR(60) NOT NULL,
    specialisation VARCHAR(60) NOT NULL,
    phone          VARCHAR(15) NOT NULL,
    dept_id        INT         NOT NULL,
    CONSTRAINT UQ_Doctor_Phone UNIQUE (phone),
    CONSTRAINT FK_Doctor_Dept  FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Patient (
    patient_id    INT IDENTITY(5001,1) PRIMARY KEY,
    full_name     VARCHAR(60)  NOT NULL,
    date_of_birth DATE         NOT NULL,
    gender        CHAR(1)      NOT NULL CHECK (gender IN ('M', 'F', 'O')),
    phone         VARCHAR(15)  NOT NULL,
    address_line  VARCHAR(120) NOT NULL,
    city          VARCHAR(40)  NOT NULL
);

CREATE TABLE Visit (
    visit_id      INT IDENTITY(1,1) PRIMARY KEY,
    patient_id    INT          NOT NULL,
    doctor_id     INT          NOT NULL,
    visit_date    DATE         NOT NULL,
    diagnosis     VARCHAR(100) NOT NULL,
    prescription  VARCHAR(200) NULL,
    status        VARCHAR(10)  NOT NULL CONSTRAINT DF_Visit_Status DEFAULT 'Open',
    CONSTRAINT CK_Visit_Date   CHECK (visit_date >= '2000-01-01' AND visit_date <= CAST(GETDATE() AS DATE)),
    CONSTRAINT CK_Visit_Status CHECK (status IN ('Open', 'Closed', 'Cancelled')),
    CONSTRAINT FK_Visit_Patient FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    CONSTRAINT FK_Visit_Doctor  FOREIGN KEY (doctor_id)  REFERENCES Doctor(doctor_id)
);

CREATE TABLE Billing (
    bill_id       INT IDENTITY(1,1) PRIMARY KEY,
    visit_id      INT           NOT NULL UNIQUE,     -- one bill per visit
    bill_date     DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    bill_amount   DECIMAL(10,2) NOT NULL,
    paid          BIT           NOT NULL DEFAULT 0,
    CONSTRAINT CK_Bill_Amount  CHECK (bill_amount >= 0),
    CONSTRAINT FK_Billing_Visit FOREIGN KEY (visit_id) REFERENCES Visit(visit_id) ON DELETE CASCADE
);
GO
-- [shot:t2_check]
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

SELECT OBJECT_NAME(parent_object_id) AS table_name, name AS default_name, definition
FROM sys.default_constraints;
GO
