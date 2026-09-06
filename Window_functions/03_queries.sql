SELECT * FROM exam_scores;

-- Arrange all the subjects such that each Subject - total score on that by all students

SELECT e.subject,
  SUM(e.score) AS total_sub_score
FROM exam_scores AS e
GROUP BY e.subject;


-- GROUP BY reduces the columns from 21 to 3 (ie, can SELECT only the col we Grouping BY "subject")
-- we need the all 21 cols and another col with these total_scores
-- Window function

SELECT e.*,
  SUM(e.score) OVER (
    PARTITION BY e.subject -- tells SQL: Calculate the SUM separately for each subject.
  ) AS subject_total
FROM exam_scores AS e;


-- # GROUP BY -> Combines rows -> ONE row per subject
-- # PARTITION BY -> Does NOT combine rows -> Keeps every row + calculates within subject 


-- Bank Passbook

-- 31st Dec 100 rupees  100
-- 1st Dec 500 rupees  600
-- 11st Dec 500 rupees  1100
-- 15st Dec 1000 rupees  2100

-- this is called Rolling total/ cumulative total
-- bank_transactions

SELECT *,
  SUM(amount) OVER (
    PARTITION BY account_holder
    ORDER BY transaction_date -- sorts the window in ascending order wrt to date
  ) AS closing_balance
FROM bank_transactions;


-- # Ranking window function
-- ROW_NUMBER(), RANK(), DENSE_RANK()

-- INSERT INTO exam_scores
-- (score_id, student_id, subject, score, exam_month) VALUES
-- (22, 7, 'English', 94, '2024-11'),
-- (23, 7, 'History', 95, '2024-11'),
-- (24, 5, 'Math', 50, '2024-09'),
-- (25, 5, 'SQL', 50, '2024-10'),
-- (26, 5, 'English', 100, '2024-10');

SELECT * FROM exam_scores;
SELECT * FROM students;


-- Get total score of a student (sum of all marks) and rank of the student in his branch

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


-- If total score is the same for two students:

-- ROW_NUMBER()
-- → assigns a different number to each row
-- → 1, 2, 3, 4

-- RANK()
-- → same rank for tied scores
-- → skips the next rank
-- → 1, 2, 2, 4

-- DENSE_RANK()
-- → same rank for tied scores
-- → does NOT skip the next rank
-- → 1, 2, 2, 3