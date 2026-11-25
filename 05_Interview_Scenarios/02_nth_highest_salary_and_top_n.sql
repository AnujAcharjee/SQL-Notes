-- ============================================================================
-- SCENARIO 2: 2nd / Nth Highest Salary & Top-N Per Group
-- ============================================================================
CREATE DATABASE IF NOT EXISTS sql_interview_practice;
USE sql_interview_practice;

DROP TABLE IF EXISTS emp_salaries;

CREATE TABLE emp_salaries (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

INSERT INTO emp_salaries VALUES
(1, 'Aarav',  'Engineering', 100000),
(2, 'Sneha',  'Engineering', 100000), -- Tie for 1st in Engineering
(3, 'Raj',    'Engineering', 85000),
(4, 'Priya',  'Engineering', 70000),
(5, 'Amit',   'Marketing',   90000),
(6, 'Neha',   'Marketing',   80000),
(7, 'Vikram', 'Marketing',   65000);

-- ============================================================================
-- VISUAL DATA IN TABLE:
-- ============================================================================
--
--  [ emp_salaries ]
--  +--------+--------+-------------+--------+
--  | emp_id | name   | department  | salary |
--  +--------+--------+-------------+--------+
--  | 1      | Aarav  | Engineering | 100000 | <-- Tie for 1st in Engineering
--  | 2      | Sneha  | Engineering | 100000 | <-- Tie for 1st in Engineering
--  | 3      | Raj    | Engineering | 85000  |
--  | 4      | Priya  | Engineering | 70000  |
--  | 5      | Amit   | Marketing   | 90000  |
--  | 6      | Neha   | Marketing   | 80000  |
--  | 7      | Vikram | Marketing   | 65000  |
--  +--------+--------+-------------+--------+
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q1: Find the 2nd highest DISTINCT salary overall.
--
-- Method A: Subquery (works in almost every SQL database)
-- Think: "What is the maximum salary that is strictly less than the overall max?"
--
-- Expected Output:
-- +-----------------------+
-- | second_highest_salary |
-- +-----------------------+
-- | 90000                 |
-- +-----------------------+
-- ----------------------------------------------------------------------------
SELECT MAX(salary) AS second_highest_salary
FROM emp_salaries
WHERE salary < (SELECT MAX(salary) FROM emp_salaries);

-- ----------------------------------------------------------------------------
-- Method B: ORDER BY + DISTINCT + LIMIT/OFFSET (MySQL / PostgreSQL)
-- Think: Sort unique salaries descending, skip 1st (OFFSET 1), take 1 (LIMIT 1).
-- To get Nth highest, use: LIMIT 1 OFFSET (N - 1)
-- ----------------------------------------------------------------------------
SELECT DISTINCT salary AS second_highest_salary
FROM emp_salaries
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

-- ----------------------------------------------------------------------------
-- Method C: DENSE_RANK() inside a CTE (Best for Nth highest & handling ties)
-- Why DENSE_RANK() instead of RANK() or ROW_NUMBER()?
--   Salaries: 100k, 100k, 90k
--   ROW_NUMBER() -> 1, 2, 3 (treats 100k as 2nd!)
--   RANK()       -> 1, 1, 3 (skips 2nd!)
--   DENSE_RANK() -> 1, 1, 2 (90k is properly 2nd!)
--
-- Expected Output:
-- +------+--------+
-- | name | salary |
-- +------+--------+
-- | Amit | 90000  |
-- +------+--------+
-- ----------------------------------------------------------------------------
WITH ranked_salaries AS (
    SELECT
        name,
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM emp_salaries
)
SELECT name, salary
FROM ranked_salaries
WHERE rnk = 2;

-- ----------------------------------------------------------------------------
-- Q2: Find the TOP 2 highest-paid employees in EACH department.
--
-- How to think about it:
-- 1. "In each department" -> PARTITION BY department.
-- 2. "Highest-paid" -> ORDER BY salary DESC.
-- 3. Filter rnk <= 2 in an outer query / CTE (cannot filter window functions in WHERE).
--
-- Expected Output:
-- +-------------+-------+--------+-----------+
-- | department  | name  | salary | dept_rank |
-- +-------------+-------+--------+-----------+
-- | Engineering | Aarav | 100000 | 1         |
-- | Engineering | Sneha | 100000 | 1         |
-- | Engineering | Raj   | 85000  | 2         |
-- | Marketing   | Amit  | 90000  | 1         |
-- | Marketing   | Neha  | 80000  | 2         |
-- +-------------+-------+--------+-----------+
-- ----------------------------------------------------------------------------
WITH dept_ranked AS (
    SELECT
        emp_id,
        name,
        department,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS dept_rank
    FROM emp_salaries
)
SELECT department, name, salary, dept_rank
FROM dept_ranked
WHERE dept_rank <= 2
ORDER BY department, dept_rank;
