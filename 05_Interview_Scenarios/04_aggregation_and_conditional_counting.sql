-- ============================================================================
-- SCENARIO 4: GROUP BY, HAVING, Conditional Counting (CASE WHEN) & Rates
-- ============================================================================
CREATE DATABASE IF NOT EXISTS sql_interview_practice;
USE sql_interview_practice;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    amount DECIMAL(10, 2),
    status ENUM('Completed', 'Cancelled', 'Pending')
);

INSERT INTO orders VALUES
(1, 1, '2026-01-10', 500.00,  'Completed'),
(2, 1, '2026-01-11', 300.00,  'Cancelled'),
(3, 1, '2026-01-12', 1200.00, 'Completed'),
(4, 2, '2026-01-10', 250.00,  'Completed'),
(5, 2, '2026-01-11', 150.00,  'Pending'),
(6, 3, '2026-01-10', 900.00,  'Cancelled'),
(7, 3, '2026-01-12', 400.00,  'Cancelled');

-- ============================================================================
-- VISUAL DATA IN TABLE:
-- ============================================================================
--
--  [ orders ]
--  +----------+---------+------------+---------+-----------+
--  | order_id | user_id | order_date | amount  | status    |
--  +----------+---------+------------+---------+-----------+
--  | 1        | 1       | 2026-01-10 | 500.00  | Completed |
--  | 2        | 1       | 2026-01-11 | 300.00  | Cancelled |
--  | 3        | 1       | 2026-01-12 | 1200.00 | Completed |
--  | 4        | 2       | 2026-01-10 | 250.00  | Completed |
--  | 5        | 2       | 2026-01-11 | 150.00  | Pending   |
--  | 6        | 3       | 2026-01-10 | 900.00  | Cancelled |
--  | 7        | 3       | 2026-01-12 | 400.00  | Cancelled |
--  +----------+---------+------------+---------+-----------+
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q1: Find users whose total COMPLETED spend is > 1000.
--
-- How to think about it:
-- 1. Filter to Completed orders BEFORE grouping -> WHERE status = 'Completed'.
-- 2. Group by user_id and sum amount.
-- 3. Filter the summed result AFTER grouping -> HAVING SUM(amount) > 1000.
--
-- Expected Output:
-- +---------+------------------+-------------+
-- | user_id | completed_orders | total_spent |
-- +---------+------------------+-------------+
-- | 1       | 2                | 1700.00     |  (500 + 1200)
-- +---------+------------------+-------------+
-- ----------------------------------------------------------------------------
SELECT
    user_id,
    COUNT(*) AS completed_orders,
    SUM(amount) AS total_spent
FROM orders
WHERE status = 'Completed'
GROUP BY user_id
HAVING SUM(amount) > 1000;

-- ----------------------------------------------------------------------------
-- Q2 (Conditional Aggregation): Show each user's total orders broken down
--     by status (completed, cancelled, pending) in ONE row per user.
--
-- How to think about it:
-- Use SUM(CASE WHEN condition THEN 1 ELSE 0 END) to count conditionally
-- without filtering out the other rows in WHERE!
--
-- Expected Output:
-- +---------+--------------+-----------------+-----------------+---------------+
-- | user_id | total_orders | completed_count | cancelled_count | pending_count |
-- +---------+--------------+-----------------+-----------------+---------------+
-- | 1       | 3            | 2               | 1               | 0             |
-- | 2       | 2            | 1               | 0               | 1             |
-- | 3       | 2            | 0               | 2               | 0             |
-- +---------+--------------+-----------------+-----------------+---------------+
-- ----------------------------------------------------------------------------
SELECT
    user_id,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_count,
    SUM(CASE WHEN status = 'Pending'   THEN 1 ELSE 0 END) AS pending_count
FROM orders
GROUP BY user_id;

-- ----------------------------------------------------------------------------
-- Q3: Calculate the cancellation rate (%) per user, rounded to 2 decimals.
--
-- How to think about it:
-- Cancellation rate = (cancelled orders / total orders) * 100.
-- Multiply by 100.0 (float) or use DECIMAL to avoid integer division truncation.
--
-- Expected Output:
-- +---------+-----------------------+
-- | user_id | cancellation_rate_pct |
-- +---------+-----------------------+
-- | 1       | 33.33                 | (1 / 3 = 33.33%)
-- | 2       | 0.00                  | (0 / 2 = 0.00%)
-- | 3       | 100.00                | (2 / 2 = 100.00%)
-- +---------+-----------------------+
-- ----------------------------------------------------------------------------
SELECT
    user_id,
    ROUND(
        100.0 * SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM orders
GROUP BY user_id;
