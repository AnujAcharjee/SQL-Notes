# SQL Key Notes (Interview Essentials)

> Based on [The Ultimate SQL Tutorial (CodeWithHarry)](https://www.codewithharry.com/blogpost/the-ultimate-sql-course) — focused on the core concepts, syntax, and comparisons most commonly asked in interviews.

---

## 1. Database & SQL Basics

- **DBMS (Database Management System):** Software that interacts with users, applications, and the database to store, retrieve, update, and manage data (e.g., MySQL, PostgreSQL).
- **Database:** A container holding related **tables** (like a folder of files, or an Excel workbook of sheets).
- **Table:** Structured data organized in **rows** (records) and **columns** (fields).

### Basic Database Commands
```sql
CREATE DATABASE startersql;
USE startersql;
DROP DATABASE startersql; -- Deletes the entire database and all tables
```

### Common Data Types
| Data Type | Purpose | Example |
| :--- | :--- | :--- |
| `INT` | Whole numbers | `id INT` |
| `VARCHAR(n)` | Variable-length string (up to `n` chars) | `name VARCHAR(100)` |
| `ENUM(...)` | String chosen from a fixed list of values | `gender ENUM('Male', 'Female', 'Other')` |
| `DATE` | Date value (`YYYY-MM-DD`) | `date_of_birth DATE` |
| `TIMESTAMP` | Date & time (often auto-set on creation) | `created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP` |
| `BOOLEAN` | `TRUE` or `FALSE` flags | `is_active BOOLEAN DEFAULT TRUE` |
| `DECIMAL(p, s)` | Exact numeric value (`p` total digits, `s` after decimal) — ideal for money | `salary DECIMAL(10, 2)` |

---

## 2. Table Operations (DDL)

### Create, Rename, Truncate, Drop
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

RENAME TABLE users TO customers;
TRUNCATE TABLE users; -- Removes all rows, keeps structure (faster than DELETE, cannot be rolled back)
DROP TABLE users;     -- Deletes both data and table structure permanently
```

### `ALTER TABLE` (Modifying Structure)
```sql
ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE users DROP COLUMN is_active;
ALTER TABLE users MODIFY COLUMN name VARCHAR(150); -- Change datatype/constraints only
ALTER TABLE users CHANGE COLUMN city location VARCHAR(150); -- Rename AND change datatype
```

> **Interview Q — `DELETE` vs `TRUNCATE` vs `DROP`:**
> - `DELETE`: DML command. Removes specific rows (with `WHERE`) or all rows. Can be rolled back; slower (logs each row).
> - `TRUNCATE`: DDL command. Removes **all** rows at once, keeps table structure. Faster; generally cannot be rolled back.
> - `DROP`: DDL command. Deletes the entire table (data + structure).

---

## 3. CRUD Operations (DML)

```sql
-- INSERT (best practice: specify column names)
INSERT INTO users (name, email, gender, date_of_birth)
VALUES
    ('Bob', 'bob@example.com', 'Male', '1990-11-23'),
    ('Charlie', 'charlie@example.com', 'Other', '1988-02-17');

-- SELECT
SELECT * FROM users;
SELECT name, email FROM users;
SELECT DISTINCT gender FROM users; -- Unique values only

-- UPDATE (always include WHERE unless updating every row)
UPDATE users SET salary = 70000 WHERE id = 5;

-- DELETE (always include WHERE unless deleting every row)
DELETE FROM users WHERE id = 3;
```

---

## 4. Filtering, Sorting & Pagination

### `WHERE` Operators
- **Comparison:** `=`, `!=` or `<>`, `<`, `>`, `<=`, `>=`
- **Logical:** `AND`, `OR`, `NOT`
- **Range & List:**
  ```sql
  SELECT * FROM users WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31';
  SELECT * FROM users WHERE gender IN ('Male', 'Other');
  ```
- **NULL Checks** (never use `= NULL`):
  ```sql
  SELECT * FROM users WHERE date_of_birth IS NULL;
  SELECT * FROM users WHERE date_of_birth IS NOT NULL;
  ```
- **Pattern Matching (`LIKE`):**
  - `%` matches **0 or more** characters (`'A%'` starts with A, `'%li%'` contains 'li').
  - `_` matches **exactly 1** character (`'_a%'` has 'a' as the 2nd letter).

### `ORDER BY`, `LIMIT`, and `OFFSET`
```sql
SELECT * FROM users
WHERE salary > 60000
ORDER BY salary DESC, name ASC
LIMIT 5 OFFSET 10; -- Skips first 10 rows, returns next 5 (MySQL shorthand: LIMIT 10, 5)
```

---

## 5. Constraints & Keys

Constraints enforce data accuracy and integrity at the column/table level:
- `NOT NULL`: Disallows `NULL` values.
- `UNIQUE`: Ensures all values in a column are distinct.
- `CHECK`: Enforces a condition (e.g., `CONSTRAINT chk_dob CHECK (date_of_birth > '2000-01-01')`).
- `DEFAULT`: Assigns a fallback value if none is provided.
- `AUTO_INCREMENT`: Automatically generates sequential integers (commonly paired with `PRIMARY KEY`).

### `PRIMARY KEY` vs `UNIQUE` (Classic Interview Question)
| Feature | `PRIMARY KEY` | `UNIQUE` |
| :--- | :--- | :--- |
| Must be unique? | Yes | Yes |
| Allows `NULL`? | **No** | **Yes** |
| How many per table? | **Only 1** | **Multiple** |
| Purpose | Main row identifier | Enforce non-duplicate values (e.g., `email`) |

### `FOREIGN KEY` & Referential Integrity
Links a column in a child table to a `PRIMARY KEY` in a parent table:
```sql
CREATE TABLE addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    city VARCHAR(100),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);
```
- **`ON DELETE` Options:**
  - `RESTRICT` (default): Prevents deleting the parent row if child rows exist.
  - `CASCADE`: Automatically deletes matching child rows when the parent is deleted.
  - `SET NULL`: Sets the foreign key column in child rows to `NULL`.

---

## 6. Essential SQL Functions

- **Aggregate Functions** (return a single summary value):
  - `COUNT(*)`, `SUM(col)`, `AVG(col)`, `MIN(col)`, `MAX(col)`
- **String Functions:**
  - `LENGTH(str)`, `LOWER(str)`, `UPPER(str)`, `CONCAT(s1, s2, ...)`
- **Date Functions:**
  - `NOW()`, `CURDATE()`, `YEAR(date)`, `MONTH(date)`, `DAY(date)`
  - `DATEDIFF(d1, d2)` (days between dates), `TIMESTAMPDIFF(YEAR, dob, CURDATE())` (age in years)
- **Math & Conditional:**
  - `ROUND(num)`, `FLOOR(num)`, `CEIL(num)`, `MOD(a, b)`
  - `IF(condition, true_val, false_val)`

---

## 7. Grouping & Filtering Groups (`GROUP BY` & `HAVING`)

```sql
SELECT gender, AVG(salary) AS avg_salary
FROM users
WHERE is_active = TRUE
GROUP BY gender
HAVING AVG(salary) > 75000;
```

> **Interview Q — `WHERE` vs `HAVING`:**
> - `WHERE` filters **individual rows before** grouping; **cannot** use aggregate functions.
> - `HAVING` filters **groups after** `GROUP BY`; **can** use aggregate functions.

- **`WITH ROLLUP`:** Appends subtotal/grand total rows to a `GROUP BY` result (`GROUP BY gender WITH ROLLUP`).

---

## 8. SQL `JOIN`s

Used to combine rows from two or more tables based on a related column (typically `PK = FK`).

| JOIN Type | Behavior |
| :--- | :--- |
| `INNER JOIN` | Only matching rows from both tables |
| `LEFT JOIN` | All rows from the **left** table + matching rows from the right (`NULL` if no match) |
| `RIGHT JOIN` | All rows from the **right** table + matching rows from the left (`NULL` if no match) |
| `FULL OUTER JOIN` | All rows from **both** tables (`NULL` where no match; in MySQL, simulate via `LEFT JOIN UNION RIGHT JOIN`) |
| `CROSS JOIN` | Cartesian product — every row of Table A paired with every row of Table B |
| `SELF JOIN` | A table joined with **itself** using aliases (e.g., employee–manager or user–referrer) |

### Example Scenario
- **`LEFT JOIN`:** You have a list of all employees and want to find their bonuses — keep every employee, even those with no bonus (`NULL` bonus).
- **`RIGHT JOIN`:** You have a list of all bonuses and want to find the employees receiving them — keep every bonus, even if an employee record is missing.

```sql
-- LEFT JOIN
SELECT users.name, addresses.city
FROM users
LEFT JOIN addresses ON users.id = addresses.user_id;

-- SELF JOIN (user referrals)
SELECT a.name AS user_name, b.name AS referred_by
FROM users a
LEFT JOIN users b ON a.referred_by_id = b.id;
```

---

## 9. `UNION` vs `UNION ALL`

Combines the result sets of two or more `SELECT` statements vertically.
- **Rules:** Every `SELECT` must have the **same number of columns** and **compatible data types**.
- `UNION`: Combines results and **removes duplicates** (slower due to deduplication).
- `UNION ALL`: Combines results and **keeps all duplicates** (faster).

```sql
SELECT name FROM users
UNION
SELECT name FROM admin_users
ORDER BY name;
```

---

## 10. Subqueries

A query nested inside another query (`SELECT`, `WHERE`, or `FROM`).

- **Scalar Subquery** (returns a single value):
  ```sql
  SELECT id, name, salary
  FROM users
  WHERE salary > (SELECT AVG(salary) FROM users);
  ```
- **Multi-row Subquery with `IN`**:
  ```sql
  SELECT id, name
  FROM users
  WHERE referred_by_id IN (SELECT id FROM users WHERE salary > 75000);
  ```
- **Derived Table:** A subquery in the `FROM` clause acting as a temporary virtual table.

---

## 11. Views, Indexes, Transactions, Procedures & Triggers

### Views
A **virtual table** saved from a `SELECT` query. It stores **no data** itself and always reflects live changes in the base tables.
```sql
CREATE VIEW high_salary_users AS
SELECT id, name, salary FROM users WHERE salary > 70000;

DROP VIEW high_salary_users;
```

### Indexes
Speed up `SELECT` queries (`WHERE`, `JOIN`, `ORDER BY`), at the cost of extra disk space and slightly slower `INSERT`/`UPDATE`/`DELETE` operations.
```sql
CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_gender_salary ON users(gender, salary); -- Multi-column: order matters!
SHOW INDEXES FROM users;
DROP INDEX idx_email ON users;
```
> **Leftmost Prefix Rule:** An index on `(gender, salary)` speeds up queries filtering by `gender` or `(gender, salary)`, but **not** queries filtering only by `salary`.

### Transactions, AutoCommit & ACID
By default, MySQL auto-commits every statement. Disable AutoCommit to group changes atomically:
```sql
SET autocommit = 0;
UPDATE users SET salary = 80000 WHERE id = 5;
COMMIT;   -- Save changes permanently
ROLLBACK; -- Or revert changes to last COMMIT/ROLLBACK
SET autocommit = 1;
```
- **ACID Properties:**
  - **Atomicity:** All operations in a transaction succeed together, or all roll back.
  - **Consistency:** Database moves from one valid state to another (constraints remain valid).
  - **Isolation:** Concurrent transactions do not interfere with each other.
  - **Durability:** Once committed, data persists even after a crash.

### Stored Procedures
Reusable SQL code blocks stored in the database. Change `DELIMITER` temporarily so internal `;` characters don't end the procedure prematurely.
```sql
DELIMITER $$
CREATE PROCEDURE AddUser(IN p_name VARCHAR(100), IN p_email VARCHAR(100))
BEGIN
    INSERT INTO users (name, email) VALUES (p_name, p_email);
END $$
DELIMITER ;

CALL AddUser('Kiran', 'kiran@example.com');
DROP PROCEDURE IF EXISTS AddUser;
```

### Triggers
Stored programs that fire automatically `BEFORE` or `AFTER` an `INSERT`, `UPDATE`, or `DELETE` on a table (`FOR EACH ROW`).
- `NEW.col`: Refers to the new row (`INSERT`, `UPDATE`).
- `OLD.col`: Refers to the previous row (`UPDATE`, `DELETE`).
```sql
DELIMITER $$
CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_log (user_id, name) VALUES (NEW.id, NEW.name);
END $$
DELIMITER ;
```

---

## 12. Extra Interview Essentials

### SQL Logical Order of Execution
Explains why `SELECT` aliases and window functions cannot be used in `WHERE`:
1. `FROM` / `JOIN`
2. `WHERE`
3. `GROUP BY`
4. `HAVING`
5. `SELECT` *(and Window Functions)*
6. `DISTINCT`
7. `ORDER BY`
8. `LIMIT` / `OFFSET`

### `NULL` Gotchas & Helper Functions
- **`COUNT(*)` vs `COUNT(col)`:** `COUNT(*)` counts all rows (including `NULL`s); `COUNT(col)` **ignores `NULL`s**.
- **`NOT IN` Trap:** `WHERE id NOT IN (1, 2, NULL)` returns **0 rows** because `id != NULL` evaluates to `UNKNOWN`. Use `NOT EXISTS` instead.
- **`COALESCE(a, b, 'default')`:** Returns the first non-`NULL` value.
- **`NULLIF(a, b)`:** Returns `NULL` if `a = b` (prevents division-by-zero: `total / NULLIF(count, 0)`).

### `IN` vs `EXISTS`
- `EXISTS` stops scanning as soon as it finds the first match (often faster on large subqueries) and handles `NULL`s safely with `NOT EXISTS`.

### Database Normalization (1NF, 2NF, 3NF)
- **1NF:** Atomic values in each cell (no comma-separated lists) + unique rows.
- **2NF:** 1NF + no partial dependency on a composite primary key.
- **3NF:** 2NF + no transitive dependency (non-key columns shouldn't depend on other non-key columns).
