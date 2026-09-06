-- CTE : Common Table Expression

-- WITH ____ AS (
--     -- SQL QUERY
-- )

-- result of the SQL query get stored in ____ (sone variable), temporarily
-- no optimization, just better way of writing sub queries


-- 01.

SELECT *
FROM exam_scores;
SELECT AVG(score) as class_avg
FROM exam_scores;
SELECT s.name as student_name,
  s.branch as student_branch,
  e.score as exam_score
FROM exam_scores as e
  INNER JOIN students as s ON s.student_id = e.student_id
WHERE e.score > (
    SELECT AVG(score) as class_avg
    FROM exam_scores
  );
-- 
-- Better way to write first sub query with CTE
-- 
WITH cls_avg AS (
  SELECT AVG(score) AS class_avg
  FROM exam_scores
) -- return a single row
SELECT s.name AS student_name,
  s.branch AS student_branch,
  e.score AS exam_score,
  ca.class_avg
FROM exam_scores AS e
  INNER JOIN students AS s ON s.student_id = e.student_id
  CROSS JOIN cls_avg AS ca -- cross join: join class_avg with every row
WHERE e.score > ca.class_avg;


-- 02.

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
-- 
-- 
-- 
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