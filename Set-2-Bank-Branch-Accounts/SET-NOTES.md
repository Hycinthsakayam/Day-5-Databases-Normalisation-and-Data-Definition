# Set 2 – Bank Branch Accounts and Customer Activity

**Scenario:** a bank branch tracks accounts in a de-normalised sheet (customer, address, account number, account type,
branch, relationship manager, balance, last transaction text).

| Question | Folder |
|---|---|
| 1. Normalise to 3NF / BCNF, keys, ER diagram | [01-normalisation-er](./01-normalisation-er/) |
| 2. Tables with IDENTITY, CHECK, UNIQUE and cascading rules | [02-create-tables](./02-create-tables/) |
| 3. DROP vs TRUNCATE vs DELETE | [03-drop-truncate-delete](./03-drop-truncate-delete/) |
| 4. Insert, update, delete and filtered SELECT | [04-dml-queries](./04-dml-queries/) |
| 5. Activity logs in a MongoDB capped collection | [05-mongodb-activity-logs](./05-mongodb-activity-logs/) |

**Deliverables:** `schema.sql` (Task 2), `seed_data.sql` (Task 4), `collections.js` (Task 5) and the note on activity logs
(Task 5).
