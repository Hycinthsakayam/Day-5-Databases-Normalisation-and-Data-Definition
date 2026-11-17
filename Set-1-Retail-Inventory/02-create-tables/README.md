# Question 2 – Create Database and Tables

Creates RetailInventoryDB with PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK (quantity >= 0), DEFAULT and referential actions (Inventory → Product ON DELETE CASCADE; Product → Category / Supplier ON DELETE NO ACTION, ON UPDATE CASCADE).

## Query files

- [schema.sql](schema.sql)

## Output

Full text output: [output.txt](output.txt)

![task2_1.png](task2_1.png)

![task2_2.png](task2_2.png)

**Constraints, defaults and foreign keys created**

![task2_3.png](task2_3.png)


## Approach

![flowchart](flowchart.svg)
