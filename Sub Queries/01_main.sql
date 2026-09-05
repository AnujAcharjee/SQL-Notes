-- CREATE TABLE students (
--   student_id INT PRIMARY KEY,
--   name VARCHAR(50) NOT NULL,
--   branch VARCHAR(50) NOT NULL
-- );

-- CREATE TABLE exam_scores (
--   score_id INT PRIMARY KEY,
--   student_id INT NOT NULL,
--   subject VARCHAR(50) NOT NULL,
--   score INT NOT NULL CHECK (
--     score BETWEEN 0 AND 100
--   ),
--   exam_month VARCHAR(7) NOT NULL,
--   FOREIGN KEY (student_id) REFERENCES students(student_id)
-- );

-- CREATE TABLE projects (
--   project_id INT AUTO_INCREMENT PRIMARY KEY,
--   student_id INT NOT NULL,
--   title VARCHAR(100) NOT NULL,
--   marks INT NOT NULL CHECK (
--     marks BETWEEN 0 AND 100
--   ),
--   FOREIGN KEY (student_id) REFERENCES students(student_id)
-- );



-- Students
INSERT INTO students (student_id, name, branch) VALUES
(1, 'Anuj', 'CSE'),
(2, 'Rahul', 'CSE'),
(3, 'Priya', 'ECE'),
(4, 'Amit', 'ME'),
(5, 'Sneha', 'CSE'),
(6, 'Riya', 'ECE'),
(7, 'Arjun', 'CSE'),
(8, 'Neha', 'IT');


-- Exam Scores
INSERT INTO exam_scores
(score_id, student_id, subject, score, exam_month) VALUES
(1, 1, 'SQL', 92, '2026-01'),
(2, 1, 'Python', 88, '2026-01'),
(3, 1, 'OS', 79, '2026-02'),

(4, 2, 'SQL', 75, '2026-01'),
(5, 2, 'Python', 81, '2026-01'),
(6, 2, 'OS', 85, '2026-02'),

(7, 3, 'SQL', 90, '2026-01'),
(8, 3, 'Python', 94, '2026-01'),
(9, 3, 'OS', 87, '2026-02'),

(10, 4, 'SQL', 68, '2026-01'),
(11, 4, 'Python', 72, '2026-01'),

(12, 5, 'SQL', 96, '2026-01'),
(13, 5, 'Python', 91, '2026-01'),
(14, 5, 'OS', 95, '2026-02'),

(15, 6, 'SQL', 83, '2026-01'),
(16, 6, 'Python', 78, '2026-01'),

(17, 7, 'SQL', 89, '2026-01'),
(18, 7, 'Python', 85, '2026-01'),
(19, 7, 'OS', 90, '2026-02'),

(20, 8, 'SQL', 76, '2026-01'),
(21, 8, 'Python', 80, '2026-01');


-- Projects
INSERT INTO projects
(project_id, student_id, title, marks) VALUES
(1, 1, 'DSA Visualizer', 95),
(2, 1, 'Chat Application', 88),

(3, 2, 'Expense Tracker', 82),

(4, 3, 'IoT Monitoring System', 94),
(5, 3, 'Smart Home App', 91),

(6, 4, 'Vehicle Management System', 75),

(7, 5, 'AI Study Assistant', 97),
(8, 5, 'E-Commerce Website', 93),

(9, 6, 'Weather Application', 84),

(10, 7, 'Compiler Project', 90),
(11, 7, 'Portfolio Website', 86),

(12, 8, 'Library Management System', 81);