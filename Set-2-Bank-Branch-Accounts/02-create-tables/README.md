# Question 2 – Create Tables

IDENTITY keys, UNIQUE account numbers, and `CK_Savings_Balance` so a savings balance cannot go below 0 (a current account can, as overdraft).

**Cascading rules**

- AccountHolder → Account: **ON DELETE CASCADE**. A holder link means nothing once the account is gone.
- AccountHolder → Customer: **NO ACTION**. A customer who still has accounts should not be deleted.
- Account → RelationshipManager: **SET NULL**. If a manager leaves, the account stays and gets a new manager later.
- Account → Branch, RelationshipManager → Branch: **NO ACTION**. A branch with accounts or staff cannot be removed.
- AccountTransaction → Account: **NO ACTION**. Transaction history must never be deleted automatically.

## Query files

- [schema.sql](schema.sql)

## Output

Full text output: [output.txt](output.txt)

**Create tables**

![t2_tables.png](t2_tables.png)

**Constraints and foreign keys**

![t2_check.png](t2_check.png)

**Testing CHECK and UNIQUE**

![t2_savings_check.png](t2_savings_check.png)


## Approach

![flowchart](flowchart.svg)
