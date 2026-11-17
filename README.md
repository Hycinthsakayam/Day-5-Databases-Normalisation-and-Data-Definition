# Day 5 – Databases, Normalisation and Data Definition

This repository contains my solutions for the Day 5 assignment on SQL Server 2025 and MongoDB 8.0. Each question is in its own folder with the script, the output and a flowchart.

The assignment has three sets, with five questions in each set.

## What I'm working on

- Finding update, insert and delete anomalies and normalising to 3NF / BCNF.
- Creating databases and tables with keys, CHECK, UNIQUE, DEFAULT and cascading rules.
- Inserting, updating and deleting data and testing failing inserts.
- Comparing DELETE, TRUNCATE and DROP, and using ALTER TABLE.
- Filtering with WHERE, AND, OR, IN, BETWEEN and LIKE.
- Creating MongoDB collections with $jsonSchema validation and capped collections.

## Assignment sets

### Set 1 – Retail Inventory and Product Reviews
Normalising the stock spreadsheet to 3NF, creating the tables with constraints, inserting data and failing inserts, UPDATE / DELETE with WHERE, and a MongoDB reviews collection.

[Open Set 1](./Set-1-Retail-Inventory/)

### Set 2 – Bank Branch Accounts and Customer Activity
Normalising the accounts sheet to 3NF / BCNF, creating tables with IDENTITY and cascading rules, comparing DELETE, TRUNCATE and DROP, filtered queries, and activity logs in a capped collection.

[Open Set 2](./Set-2-Bank-Branch-Accounts/)

### Set 3 – Hospital Patient Records and Clinical Notes
Splitting the visits sheet into Patient, Doctor, Department, Visit and Billing, constraints on dates and amounts, ALTER TABLE changes, WHERE / LIKE queries and clinical notes with two document shapes.

[Open Set 3](./Set-3-Hospital-Patient-Records/)

## How the folders are organised

Each question has its own folder. Inside, you can find:

- The SQL script (`schema.sql`, `seed_data.sql`, ...) or MongoDB script (`collections.js`).
- `output.txt` with the result of running it, and screenshots of the output (`.png`).
- `explanation.md` with what the question asks and what the output shows.
- `flowchart.svg`, which shows the steps followed.

Question 1 of each set has the normalisation steps and the ER diagram. Each set also has a `SET-NOTES.md`.

## Running

Run the SQL scripts with SQL Server Management Studio or sqlcmd in this order: `schema.sql`, `seed_data.sql`, then the other task scripts. Run the MongoDB script with `mongosh collections.js`.
