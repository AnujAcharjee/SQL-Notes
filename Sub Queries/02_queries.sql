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


-- 02. Placement Drive criteria
-- At least 1 exam attempt have score >= 90
-- AND 
-- Any one of their projects should have marks >+ 85
-- Get student_name, subject, sub_score, project_title, project_score

SELECT s.name as student_name,
  e.subject as subject,
  e.score as sub_score,
  p.title as project_title,
  p.score as project_score
FROM students as s
WHERE s.student_id IN (
    SELECT student_id
    FROM exam_scores
    WHERE score >= 90
  )
  AND s.student_id IN (
    SELECT student_id
    FROM projects
    WHERE marks >= 85
  );