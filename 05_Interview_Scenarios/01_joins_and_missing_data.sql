-- ============================================================================
-- SCENARIO 1: JOINs, Missing Data (Anti-Join), and Self-Join
-- ============================================================================
CREATE DATABASE IF NOT EXISTS sql_interview_practice;
USE sql_interview_practice;

DROP TABLE IF EXISTS bonuses;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    dept_id INT,
    manager_id INT,
    salary INT
);

CREATE TABLE bonuses (
    bonus_id INT PRIMARY KEY,
    emp_id INT,
    bonus_amount INT
);

INSERT INTO departments VALUES
(1, 'Engineering'),
(2, 'Marketing'),
(3, 'HR');

INSERT INTO employees VALUES
(1, 'Aarav', 1, NULL, 120000), -- CEO / no manager
(2, 'Sneha', 1, 1, 90000),
(3, 'Raj',   2, 1, 75000),
(4, 'Priya', NULL, 2, 65000), -- No department assigned
(5, 'Amit',  3, 1, 60000);

INSERT INTO bonuses VALUES
(101, 1, 15000),
(102, 2, 10000),
(103, 99, 5000); -- Orphan bonus record (emp_id 99 does not exist)

-- ----------------------------------------------------------------------------
-- Q1: List ALL employees and their department names (even if dept is NULL).
--
-- How to think about it:
-- 1. Output grain: 1 row per employee.
-- 2. "Keep all employees" -> employees is the LEFT table -> use LEFT JOIN.
-- ----------------------------------------------------------------------------
SELECT
    e.emp_id,
    e.name,
    COALESCE(d.dept_name, 'Unassigned') AS department
FROM employees e
LEFT JOIN departments d
    ON e.dept_id = d.dept_id;

-- ----------------------------------------------------------------------------
-- Q2 (Anti-Join): Find employees who did NOT receive any bonus.
--
-- How to think about it:
-- 1. Start with LEFT JOIN from employees to bonuses.
-- 2. Employees with no bonus will have NULL in bonuses.bonus_id.
-- 3. Filter with WHERE b.bonus_id IS NULL.
-- (Same pattern for: "Customers who never placed an order")
-- ----------------------------------------------------------------------------
SELECT
    e.emp_id,
    e.name
FROM employees e
LEFT JOIN bonuses b
    ON e.emp_id = b.emp_id
WHERE b.bonus_id IS NULL;

-- ----------------------------------------------------------------------------
-- Q3: Find each employee's name along with their manager's name.
--
-- How to think about it:
-- 1. Both employee and manager live in the SAME table (employees) -> SELF JOIN.
-- 2. Alias e = employee, m = manager.
-- 3. Match e.manager_id = m.emp_id.
-- 4. Use LEFT JOIN so the CEO (manager_id IS NULL) is still included.
-- ----------------------------------------------------------------------------
SELECT
    e.name AS employee_name,
    COALESCE(m.name, 'No Manager') AS manager_name
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.emp_id;
