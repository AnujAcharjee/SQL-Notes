-- ============================================================================
-- SCENARIO 3: Finding Duplicates, Deleting Duplicates & "Bought Both" Queries
-- ============================================================================
CREATE DATABASE IF NOT EXISTS sql_interview_practice;
USE sql_interview_practice;

DROP TABLE IF EXISTS contacts;
DROP TABLE IF EXISTS purchases;

CREATE TABLE contacts (
    id INT PRIMARY KEY,
    email VARCHAR(100)
);

INSERT INTO contacts VALUES
(1, 'alice@example.com'),
(2, 'bob@example.com'),
(3, 'alice@example.com'), -- duplicate
(4, 'charlie@example.com'),
(5, 'bob@example.com');   -- duplicate

-- ============================================================================
-- VISUAL DATA IN TABLE:
-- ============================================================================
--
--  [ contacts ]
--  +----+---------------------+
--  | id | email               |
--  +----+---------------------+
--  | 1  | alice@example.com   | <-- First occurrence of alice
--  | 2  | bob@example.com     | <-- First occurrence of bob
--  | 3  | alice@example.com   | <-- Duplicate!
--  | 4  | charlie@example.com |
--  | 5  | bob@example.com     | <-- Duplicate!
--  +----+---------------------+
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q1: Find all duplicate emails (and how many times they appear).
--
-- How to think about it:
-- 1. Group by email.
-- 2. Keep only groups where count > 1 -> HAVING COUNT(*) > 1.
--
-- Expected Output:
-- +-------------------+-------------+
-- | email             | occurrences |
-- +-------------------+-------------+
-- | alice@example.com | 2           |
-- | bob@example.com   | 2           |
-- +-------------------+-------------+
-- ----------------------------------------------------------------------------
SELECT
    email,
    COUNT(*) AS occurrences
FROM contacts
GROUP BY email
HAVING COUNT(*) > 1;

-- ----------------------------------------------------------------------------
-- Q2: Delete duplicate rows, keeping only the row with the LOWEST id.
--
-- How to think about it:
-- Self-join contacts c1 and c2 on the same email, where c1.id > c2.id.
-- Any c1 row that has a smaller c2.id with the same email is a duplicate.
--
-- Rows deleted: id = 3 (alice) and id = 5 (bob).
-- Result remaining in contacts:
-- +----+---------------------+
-- | id | email               |
-- +----+---------------------+
-- | 1  | alice@example.com   |
-- | 2  | bob@example.com     |
-- | 4  | charlie@example.com |
-- +----+---------------------+
-- ----------------------------------------------------------------------------
DELETE c1
FROM contacts c1
INNER JOIN contacts c2
    ON c1.email = c2.email
   AND c1.id > c2.id;

SELECT * FROM contacts ORDER BY id;

-- ----------------------------------------------------------------------------
-- Q3: Find customers who bought BOTH 'Laptop' AND 'Mouse'.
-- ----------------------------------------------------------------------------
CREATE TABLE purchases (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product VARCHAR(50)
);

INSERT INTO purchases VALUES
(1, 101, 'Laptop'),
(2, 101, 'Mouse'),
(3, 102, 'Laptop'),
(4, 102, 'Laptop'), -- Bought Laptop twice, no Mouse
(5, 103, 'Mouse'),
(6, 104, 'Laptop'),
(7, 104, 'Mouse'),
(8, 104, 'Keyboard');

-- ============================================================================
-- VISUAL DATA IN TABLE:
-- ============================================================================
--
--  [ purchases ]
--  +----------+-------------+----------+
--  | order_id | customer_id | product  |
--  +----------+-------------+----------+
--  | 1        | 101         | Laptop   | <-- Has both Laptop & Mouse
--  | 2        | 101         | Mouse    |
--  | 3        | 102         | Laptop   | <-- Has only Laptop (twice)
--  | 4        | 102         | Laptop   |
--  | 5        | 103         | Mouse    | <-- Has only Mouse
--  | 6        | 104         | Laptop   | <-- Has both Laptop & Mouse (and Keyboard)
--  | 7        | 104         | Mouse    |
--  | 8        | 104         | Keyboard |
--  +----------+-------------+----------+
-- ============================================================================

-- How to think about it:
-- 1. Filter to only the products we care about: WHERE product IN ('Laptop', 'Mouse').
-- 2. Group by customer_id.
-- 3. Check that the count of DISTINCT matching products equals 2.
--    (DISTINCT is critical in case a customer bought 2 Laptops and 0 Mice!)
--
-- Expected Output:
-- +-------------+
-- | customer_id |
-- +-------------+
-- | 101         |
-- | 104         |
-- +-------------+
-- ----------------------------------------------------------------------------
SELECT customer_id
FROM purchases
WHERE product IN ('Laptop', 'Mouse')
GROUP BY customer_id
HAVING COUNT(DISTINCT product) = 2;
