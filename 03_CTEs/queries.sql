-- ============================================================================
-- CTE: Common Table Expression (WITH ... AS)
-- ============================================================================
-- What a CTE is:
--   A temporary, named result set defined at the top of a query using `WITH`.
--   It exists only for the duration of that single query.
--
-- Syntax:
--   WITH cte_name AS (
--       SELECT ...
--   )
--   SELECT * FROM cte_name;
--
-- Why use a CTE instead of nested subqueries?
--   - Much easier to read and debug top-to-bottom.
--   - Can be referenced multiple times in the main query.
--   - Can chain multiple CTEs together (comma-separated).
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 01. Scalar Subquery vs. CTE with CROSS JOIN
-- Goal: Find all exam attempts where score > overall class average.
-- ----------------------------------------------------------------------------

-- Approach A: Traditional Subquery in WHERE
SELECT
    s.name AS student_name,
    s.branch AS student_branch,
    e.score AS exam_score
FROM exam_scores AS e
INNER JOIN students AS s
    ON s.student_id = e.student_id
WHERE e.score > (
    SELECT AVG(score) AS class_avg
    FROM exam_scores
);

-- Approach B: Using a CTE (also lets us display `class_avg` in the output!)
-- What we are doing:
--   1. `cls_avg` CTE computes the 1-row overall average.
--   2. `CROSS JOIN cls_avg` attaches that single average value to every row
--      of `exam_scores` so we can both filter by it and display it.
WITH cls_avg AS (
    SELECT AVG(score) AS class_avg
    FROM exam_scores
)
SELECT
    s.name AS student_name,
    s.branch AS student_branch,
    e.score AS exam_score,
    ca.class_avg
FROM exam_scores AS e
INNER JOIN students AS s
    ON s.student_id = e.student_id
CROSS JOIN cls_avg AS ca
WHERE e.score > ca.class_avg;


-- ----------------------------------------------------------------------------
-- 02. Correlated EXISTS Subqueries vs. Chained Multiple CTEs
-- Goal: Find students who have BOTH:
--   - At least one exam score >= 90
--   - At least one project with marks >= 85
-- ----------------------------------------------------------------------------

-- Approach A: Using EXISTS subqueries
SELECT s.name AS student_name
FROM students AS s
WHERE EXISTS (
    SELECT 1
    FROM exam_scores AS e
    WHERE e.student_id = s.student_id
      AND e.score >= 90
)
AND EXISTS (
    SELECT 1
    FROM projects AS p
    WHERE p.student_id = s.student_id
      AND p.marks >= 85
);

-- Approach B: Using Multiple CTEs + INNER JOIN
-- What we are doing:
--   1. `exam_toppers`: Finds unique student_ids with exam score >= 90.
--   2. `project_toppers`: Finds unique student_ids with project marks >= 85.
--   3. Main query: INNER JOINs `students` with both CTEs — only students
--      present in BOTH lists survive the inner joins.
WITH exam_toppers AS (
    SELECT DISTINCT student_id
    FROM exam_scores
    WHERE score >= 90
),
project_toppers AS (
    SELECT DISTINCT student_id
    FROM projects
    WHERE marks >= 85
)
SELECT
    s.*
FROM students AS s
INNER JOIN exam_toppers AS et
    ON et.student_id = s.student_id
INNER JOIN project_toppers AS pt
    ON pt.student_id = s.student_id;
