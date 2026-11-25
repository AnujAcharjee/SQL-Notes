-- ============================================================================
-- SCENARIO 5: Running Totals & Month-over-Month (MoM) Growth
-- ============================================================================
CREATE DATABASE IF NOT EXISTS sql_interview_practice;
USE sql_interview_practice;

DROP TABLE IF EXISTS monthly_sales;

CREATE TABLE monthly_sales (
    sales_month VARCHAR(7) PRIMARY KEY, -- Format: 'YYYY-MM'
    revenue DECIMAL(10, 2)
);

INSERT INTO monthly_sales VALUES
('2026-01', 10000.00),
('2026-02', 12500.00),
('2026-03', 11000.00),
('2026-04', 15000.00);

-- ----------------------------------------------------------------------------
-- Q1: Calculate the cumulative (running) revenue month by month.
--
-- How to think about it:
-- SUM(revenue) OVER (ORDER BY sales_month) adds up all rows from the start
-- up to the current row in chronological order.
-- ----------------------------------------------------------------------------
SELECT
    sales_month,
    revenue,
    SUM(revenue) OVER (ORDER BY sales_month) AS running_total
FROM monthly_sales;

-- ----------------------------------------------------------------------------
-- Q2: Calculate Month-over-Month (MoM) revenue difference and growth (%).
--
-- How to think about it:
-- 1. Use LAG(revenue) OVER (ORDER BY sales_month) to grab the previous month's revenue.
-- 2. Wrap it in a CTE so you can cleanly compute (current - previous) / previous * 100.
-- ----------------------------------------------------------------------------
WITH sales_with_prev AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month) AS prev_month_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    revenue,
    prev_month_revenue,
    (revenue - prev_month_revenue) AS mom_diff,
    ROUND(
        100.0 * (revenue - prev_month_revenue) / prev_month_revenue,
        2
    ) AS mom_growth_pct
FROM sales_with_prev;
