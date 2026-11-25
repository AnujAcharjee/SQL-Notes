-- ============================================================================
-- WINDOW FUNCTIONS: Calculations across a set of rows WITHOUT collapsing them
-- ============================================================================
-- Key Difference:
--   - GROUP BY     -> Collapses rows into ONE row per group.
--   - PARTITION BY -> Keeps EVERY row, and adds a calculated column per group.
-- ============================================================================

SELECT * FROM exam_scores;

-- ----------------------------------------------------------------------------
-- 01. GROUP BY vs. Window Function (SUM() OVER PARTITION BY)
-- Goal: Show each subject's total score alongside the exam_scores data.
-- ----------------------------------------------------------------------------

-- With GROUP BY: 21 exam rows collapse into 3 summary rows (1 per subject).
SELECT
    e.subject,
    SUM(e.score) AS total_sub_score
FROM exam_scores AS e
GROUP BY e.subject;

-- With Window Function: Keeps all 21 rows, and attaches `subject_total` to each row.
-- `PARTITION BY e.subject` tells SQL: calculate SUM() separately per subject.
SELECT
    e.*,
    SUM(e.score) OVER (
        PARTITION BY e.subject
    ) AS subject_total
FROM exam_scores AS e;


-- ----------------------------------------------------------------------------
-- 02. Running / Cumulative Total (Bank Passbook Example)
-- Goal: Calculate a running closing balance for each account holder over time.
--
-- Example:
--   Dec 01: +100  -> closing_balance = 100
--   Dec 05: +500  -> closing_balance = 600
--   Dec 11: +500  -> closing_balance = 1100
--   Dec 15: +1000 -> closing_balance = 2100
--
-- What we are doing:
--   - PARTITION BY account_holder -> Separate running balance per person.
--   - ORDER BY transaction_date   -> Adding ORDER BY inside OVER() changes SUM()
--                                    from a group total into a cumulative total!
-- ----------------------------------------------------------------------------
SELECT
    *,
    SUM(amount) OVER (
        PARTITION BY account_holder
        ORDER BY transaction_date
    ) AS closing_balance
FROM bank_transactions;


-- ----------------------------------------------------------------------------
-- 03. Ranking Functions: ROW_NUMBER() vs. RANK() vs. DENSE_RANK()
-- Goal: Calculate each student's total score across all exams, and rank them
--       within their branch.
--
-- What we are doing:
--   1. INNER JOIN + GROUP BY computes each student's `total_score` first.
--   2. Window functions run AFTER GROUP BY, so they can rank by `SUM(e.score)`!
--   3. PARTITION BY s.branch restarts ranking at 1 for each branch.
--
-- How ties (e.g., 2 students tied at 2nd place) are handled:
--   - ROW_NUMBER() -> 1, 2, 3, 4 (always unique, arbitrary tie-break)
--   - RANK()       -> 1, 2, 2, 4 (same rank for ties, SKIPS next number)
--   - DENSE_RANK() -> 1, 2, 2, 3 (same rank for ties, NO gap in numbers)
-- ----------------------------------------------------------------------------
SELECT
    e.student_id,
    s.name,
    s.branch,
    SUM(e.score) AS total_score,

    ROW_NUMBER() OVER (
        PARTITION BY s.branch
        ORDER BY SUM(e.score) DESC
    ) AS row_num,

    RANK() OVER (
        PARTITION BY s.branch
        ORDER BY SUM(e.score) DESC
    ) AS rank_num,

    DENSE_RANK() OVER (
        PARTITION BY s.branch
        ORDER BY SUM(e.score) DESC
    ) AS dense_rank_num

FROM exam_scores AS e
INNER JOIN students AS s
    ON s.student_id = e.student_id
GROUP BY
    e.student_id,
    s.name,
    s.branch;
