# How to Approach Any SQL Interview Scenario

When an interviewer gives you a problem statement, don't jump straight into typing `SELECT`. Follow this 5-step mental checklist:

## 1. Identify the Output & Grain
- **What columns** do you need to return?
- **What does one row in the output represent?** (e.g., one row per employee, one row per department, one row per user per day).

## 2. Pick Your Tables & `JOIN` Type
- Which tables hold those columns?
- Do you only want matching rows (`INNER JOIN`), or do you need to keep all rows from one table even if there's no match (`LEFT JOIN`)?
- Are you comparing rows within the *same* table? Use a **`SELF JOIN`**.

## 3. Filter Individual Rows First (`WHERE`)
- Apply conditions that don't need aggregation (e.g., `status = 'Completed'`, `salary > 50000`, `created_at >= '2026-01-01'`).
- Remember: `WHERE` runs **before** `GROUP BY`.

## 4. Group & Aggregate (`GROUP BY` + `HAVING`)
- If the prompt asks for *"total"*, *"average"*, *"count"*, *"per department"*, or *"per user"*, you need `GROUP BY`.
- If you need to filter *after* aggregating (e.g., *"departments with more than 5 employees"*), use **`HAVING`**.

## 5. Rank, Deduplicate, or Limit (`OVER`, `DISTINCT`, `LIMIT`)
- Need *"top N per group"* or *"2nd highest"*? Use **Window Functions** (`ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`) inside a **CTE (`WITH ... AS`)**.
- Need *"top N overall"*? Use `ORDER BY ... LIMIT N`.

---

## Scenario Files in This Folder

1. [01_joins_and_missing_data.sql](file:///c:/Users/anuja/OneDrive/Desktop/coding/SQL/05_Interview_Scenarios/01_joins_and_missing_data.sql) — `LEFT JOIN`, anti-joins ("never ordered / no bonus"), and `SELF JOIN` (employee–manager).
2. [02_nth_highest_salary_and_top_n.sql](file:///c:/Users/anuja/OneDrive/Desktop/coding/SQL/05_Interview_Scenarios/02_nth_highest_salary_and_top_n.sql) — 2nd/Nth highest salary (`LIMIT/OFFSET`, subquery, `DENSE_RANK`) and Top-N per group.
3. [03_duplicates_and_cleanup.sql](file:///c:/Users/anuja/OneDrive/Desktop/coding/SQL/05_Interview_Scenarios/03_duplicates_and_cleanup.sql) — Finding duplicates, deleting duplicates safely, and finding users who bought *all/both* items.
4. [04_aggregation_and_conditional_counting.sql](file:///c:/Users/anuja/OneDrive/Desktop/coding/SQL/05_Interview_Scenarios/04_aggregation_and_conditional_counting.sql) — `GROUP BY` + `HAVING`, conditional counting with `CASE WHEN`, and rate/percentage calculations.
5. [05_running_totals_and_growth.sql](file:///c:/Users/anuja/OneDrive/Desktop/coding/SQL/05_Interview_Scenarios/05_running_totals_and_growth.sql) — Cumulative running totals (`SUM() OVER`) and Month-over-Month growth (`LAG()`).
6. [06_null_gotchas_and_full_joins.sql](file:///c:/Users/anuja/OneDrive/Desktop/coding/SQL/05_Interview_Scenarios/06_null_gotchas_and_full_joins.sql) — `COUNT(*)` vs `COUNT(col)`, `COALESCE`/`NULLIF`, `NOT IN` vs `NOT EXISTS`, and `FULL OUTER JOIN` in MySQL.
