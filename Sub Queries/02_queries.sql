-- 01. Get all student_name, student_branch, exam_score 
-- who scored more than avg score of the class in exam_scores table
SELECT *
FROM exam_scores;
SELECT AVG(score) as class_avg
FROM exam_scores;
SELECT s.name as student_name,
  s.branch as student_branch,
  e.score as exam_score
FROM exam_scores as e
  INNER JOIN students as s ON s.student_id = e.student_id
WHERE e.score >= (
    SELECT AVG(score) as class_avg
    FROM exam_scores
  );


-- 02. 
-- Placement Drive criteria
-- At least 1 exam attempt have score >= 90
-- AND 
-- Any one of their projects should have marks >+ 85

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


-- 03.
-- We need to have total score student has earned and number of exam attempted
-- we also need student name and branch in the result

SELECT 
  s.name,
  s.branch,
  total_stats.total_score,
  total_stats.number_attempts
FROM (
  SELECT 
    student_id,
    SUM(score) as total_score, 
    COUNT(*) as number_attempts
  FROM exam_scores
  GROUP BY student_id
) as total_stats
INNER JOIN students as s ON s.student_id = total_stats.student_id
ORDER BY total_stats.total_score DESC;

-- Above we making a temp table and then join it 


-- 04.
-- From each project get student name, branch, project marks
-- and their avg exam score on the same row

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


-- 05.
-- There is a need of a report where we have list of exams attempts
-- which are above average (score > average class score)
-- also include name of the student in the report

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
FROM exam_scores as e
INNER JOIN students as s ON s.student_id = e.student_id
WHERE e.score > (
  SELECT AVG(score) FROM exam_scores
);

SELECT * FROM high_scorers_report;



