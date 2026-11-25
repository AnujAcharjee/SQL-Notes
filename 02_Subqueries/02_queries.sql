-- ============================================================================
-- SUBQUERIES: A query nested inside another SQL query
-- ============================================================================
-- Where subqueries can be used:
--   1. WHERE clause  -> Filter rows using a computed value or existence check
--   2. FROM / JOIN   -> Create a temporary "derived table" to join against
--   3. INSERT/UPDATE -> Populate or update rows based on another query
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 01. Scalar Subquery in WHERE
-- Goal: Get student name, branch, and exam score for attempts >= class average.
--
-- What we are doing:
--   - Inner query: Computes a single number (the overall average score).
--   - Outer query: Joins students & exam_scores, then keeps only rows where
--     e.score >= that single average value.
-- ----------------------------------------------------------------------------
SELECT *
FROM exam_scores;

SELECT AVG(score) AS class_avg
FROM exam_scores;

SELECT
    s.name AS student_name,
    s.branch AS student_branch,
    e.score AS exam_score
FROM exam_scores AS e
INNER JOIN students AS s
    ON s.student_id = e.student_id
WHERE e.score >= (
    SELECT AVG(score) AS class_avg -- Returns 1 value (scalar subquery)
    FROM exam_scores
);


-- ----------------------------------------------------------------------------
-- 02. Correlated Subquery with EXISTS
-- Goal: Find students eligible for the Placement Drive:
--   - At least 1 exam attempt with score >= 90
--   - AND at least 1 project with marks >= 85
--
-- What we are doing:
--   - EXISTS checks if the inner query returns AT LEAST ONE row (TRUE/FALSE).
--   - Notice `e.student_id = s.student_id` inside the inner query: it references
--     the outer `students` row, so it runs once per student (correlated).
--   - `SELECT 1` is a convention because EXISTS only cares if a row exists,
--     not what columns are returned.
-- ----------------------------------------------------------------------------
SELECT
    s.name AS student_name
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


-- ----------------------------------------------------------------------------
-- 03. Derived Table (Subquery in FROM)
-- Goal: Get each student's total exam score and number of attempts, along with
--       their name and branch, sorted from highest to lowest total score.
--
-- What we are doing:
--   - Inner query (total_stats): Aggregates exam_scores per student_id first,
--     creating a temporary table in memory with (student_id, total_score, number_attempts).
--   - Outer query: Joins that temporary table to `students` to attach name & branch.
-- ----------------------------------------------------------------------------
SELECT
    s.name,
    s.branch,
    total_stats.total_score,
    total_stats.number_attempts
FROM (
    SELECT
        student_id,
        SUM(score) AS total_score,
        COUNT(*) AS number_attempts
    FROM exam_scores
    GROUP BY student_id
) AS total_stats
INNER JOIN students AS s
    ON s.student_id = total_stats.student_id
ORDER BY total_stats.total_score DESC;


-- ----------------------------------------------------------------------------
-- 04. Derived Table in INNER JOIN
-- Goal: For each project, show student name, branch, project title, project
--       marks, AND that student's average exam score on the same row.
--
-- What we are doing:
--   - Inner query (exam_avg): Computes each student's average exam score.
--   - Outer query: Joins projects -> students -> exam_avg on student_id so
--     we don't have to GROUP BY project columns.
-- ----------------------------------------------------------------------------
SELECT
    s.name,
    s.branch,
    p.title,
    p.marks,
    exam_avg.avg_score
FROM projects AS p
INNER JOIN students AS s
    ON s.student_id = p.student_id
INNER JOIN (
    SELECT
        student_id,
        AVG(score) AS avg_score
    FROM exam_scores
    GROUP BY student_id
) AS exam_avg
    ON exam_avg.student_id = p.student_id;


-- ----------------------------------------------------------------------------
-- 05. Subquery inside INSERT INTO ... SELECT
-- Goal: Archive all above-average exam attempts into `high_scorers_report`.
--
-- What we are doing:
--   - Instead of inserting hardcoded VALUES(...), we insert the result of a
--     SELECT query filtered by a scalar subquery (`e.score > class avg`).
-- ----------------------------------------------------------------------------

-- CREATE TABLE high_scorers_report (
--     id INT AUTO_INCREMENT PRIMARY KEY,
--     student_id INT NOT NULL,
--     student_name VARCHAR(50) NOT NULL,
--     subject VARCHAR(30) NOT NULL,
--     score INT NOT NULL,
--     archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

INSERT INTO high_scorers_report (
    student_id,
    student_name,
    subject,
    score
)
SELECT
    s.student_id,
    s.name,
    e.subject,
    e.score
FROM exam_scores AS e
INNER JOIN students AS s
    ON s.student_id = e.student_id
WHERE e.score > (
    SELECT AVG(score) FROM exam_scores
);

SELECT * FROM high_scorers_report;
