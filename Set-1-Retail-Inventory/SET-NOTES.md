# Set 1 – Retail Inventory and Product Reviews

**Scenario:** a retailer keeps stock in one spreadsheet (SKU, product name, category, supplier name, supplier phone,
warehouse, quantity, reorder level) and stores customer reviews as free text.

| Question | Folder |
|---|---|
| 1. Normalise to 3NF, anomalies, ER diagram | [01-normalisation-er](./01-normalisation-er/) |
| 2. Create database and tables with constraints | [02-create-tables](./02-create-tables/) |
| 3. Insert 10+ rows per table and four failing inserts | [03-insert-data](./03-insert-data/) |
| 4. UPDATE and DELETE with WHERE (before / after) | [04-update-delete](./04-update-delete/) |
| 5. MongoDB reviews collection with $jsonSchema | [05-mongodb-reviews](./05-mongodb-reviews/) |

**Deliverables:** `schema.sql` (Task 2), `seed_data.sql` (Task 3), `collections.js` (Task 5), ER diagram (Task 1) and the
comparison table below.

## SQL Server vs MongoDB operations used

| Operation | SQL Server 2025 | MongoDB 8.0 |
|---|---|---|
| Create container | `CREATE DATABASE RetailInventoryDB` | `db.getSiblingDB('retail_reviews')` (created on first write) |
| Define structure | `CREATE TABLE` with fixed columns | `db.createCollection('reviews', { validator })` |
| Validation | PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, NOT NULL, DEFAULT | `$jsonSchema`: required, bsonType, minimum / maximum, pattern |
| Relationships | FOREIGN KEY with ON DELETE CASCADE / NO ACTION | not enforced; sku stored as a value, customer embedded |
| Insert many | `INSERT INTO ... VALUES (...), (...)` | `insertMany([...])` |
| Read | `SELECT ... WHERE ... ORDER BY` | `find(filter, projection).sort()` |
| Update | `UPDATE Supplier SET phone = ... WHERE ...` | `updateOne(filter, { $set, $inc })` |
| Delete | `DELETE FROM Product WHERE is_discontinued = 1` | `deleteOne(filter)` |
| Rejected write | Msg 2627 / 547 / 515, row not stored | `Document failed validation` |
| Count | `SELECT COUNT(*)` | `countDocuments()` |
| New column / field | needs `ALTER TABLE` | just add it (seller_reply added by updateOne) |
