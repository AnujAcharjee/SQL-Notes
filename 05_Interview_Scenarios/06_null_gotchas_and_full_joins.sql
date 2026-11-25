-- ============================================================================
-- SCENARIO 6: NULL Gotchas, COUNT(*) vs COUNT(col), NOT IN vs NOT EXISTS,
--             and FULL OUTER JOIN / CROSS JOIN
-- ============================================================================
CREATE DATABASE IF NOT EXISTS sql_interview_practice;
USE sql_interview_practice;

DROP TABLE IF EXISTS emp_projects;
DROP TABLE IF EXISTS staff;

CREATE TABLE staff (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    bonus INT
);

CREATE TABLE emp_projects (
    proj_id INT PRIMARY KEY,
    lead_emp_id INT, -- Intentionally allows NULL
    proj_name VARCHAR(50)
);

INSERT INTO staff VALUES
(1, 'Aarav', 5000),
(2, 'Sneha', NULL),
(3, 'Raj',   3000),
(4, 'Priya', NULL);

INSERT INTO emp_projects VALUES
(101, 1,    'Website Redesign'),
(102, 3,    'Mobile App'),
(103, NULL, 'Unassigned R&D'), -- NULL lead_emp_id!
(104, 99,   'External Audit'); -- Orphan lead_emp_id (99 not in staff)

-- ----------------------------------------------------------------------------
-- Q1: COUNT(*) vs COUNT(column)
--
-- What happens:
--   COUNT(*)     -> Counts ALL rows (returns 4).
--   COUNT(bonus) -> Ignores NULLs (returns 2).
-- ----------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_staff,
    COUNT(bonus) AS staff_with_bonus
FROM staff;

-- ----------------------------------------------------------------------------
-- Q2: COALESCE() and NULLIF() (Safe Fallback & Division-by-Zero Protection)
--
-- What we are doing:
--   - COALESCE(bonus, 0) replaces NULL bonus with 0.
--   - NULLIF(x, 0) returns NULL if x = 0, preventing a division-by-zero error.
-- ----------------------------------------------------------------------------
SELECT
    name,
    COALESCE(bonus, 0) AS safe_bonus,
    10000 / NULLIF(COALESCE(bonus, 0), 0) AS ratio_safe
FROM staff;

-- ----------------------------------------------------------------------------
-- Q3: The `NOT IN` Trap with NULLs vs `NOT EXISTS`
-- Goal: Find staff members who are NOT leading any project.
--
-- TRAP: `emp_projects` has a row where `lead_emp_id` IS NULL (proj_id 103).
--       `NOT IN (1, 3, NULL, 99)` evaluates to UNKNOWN for every row -> 0 rows!
-- FIX:  Use `NOT EXISTS` (always NULL-safe).
-- ----------------------------------------------------------------------------
-- BAD (returns 0 rows because of NULL in emp_projects.lead_emp_id):
SELECT name
FROM staff
WHERE emp_id NOT IN (SELECT lead_emp_id FROM emp_projects);

-- GOOD (NULL-safe, properly returns Sneha and Priya):
SELECT s.name
FROM staff s
WHERE NOT EXISTS (
    SELECT 1
    FROM emp_projects p
    WHERE p.lead_emp_id = s.emp_id
);

-- ----------------------------------------------------------------------------
-- Q4: FULL OUTER JOIN in MySQL (Keep ALL staff AND ALL projects)
--
-- MySQL does not have a `FULL OUTER JOIN` keyword.
-- Simulate it by combining a LEFT JOIN and a RIGHT JOIN with `UNION`.
-- ----------------------------------------------------------------------------
SELECT s.emp_id, s.name, p.proj_name
FROM staff s
LEFT JOIN emp_projects p
    ON s.emp_id = p.lead_emp_id
UNION
SELECT s.emp_id, s.name, p.proj_name
FROM staff s
RIGHT JOIN emp_projects p
    ON s.emp_id = p.lead_emp_id;
